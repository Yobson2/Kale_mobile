import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/features/savings/data/datasources/savings_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/domain/repositories/savings_repository.dart';
import 'package:uuid/uuid.dart';

/// Offline-first implementation of [SavingsRepository].
class SavingsRepositoryImpl implements SavingsRepository {
  /// Creates a [SavingsRepositoryImpl].
  const SavingsRepositoryImpl({
    required SavingsRemoteDataSource remoteDataSource,
    required SavingsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo;

  final SavingsRemoteDataSource _remote;
  final SavingsLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, SavingsGoal>> createSavingsGoal({
    required String name,
    required double targetAmount,
    required String currencyCode,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    try {
      final now = DateTime.now();
      final id = const Uuid().v4();

      final model = SavingsGoalModel(
        id: id,
        name: name,
        targetAmount: targetAmount,
        currentAmount: 0,
        currencyCode: currencyCode,
        description: description,
        deadline: deadline,
        iconName: iconName,
        colorHex: colorHex,
        status: SavingsGoalStatus.active.name,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      await _local.saveSavingsGoal(model);
      await _local.enqueueSync(
        entityId: id,
        operation: 'create',
        payload: jsonEncode(model.toJson()),
      );

      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal({
    required String id,
    required String name,
    required double targetAmount,
    required String currencyCode,
    required SavingsGoalStatus status,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    try {
      final existing = await _local.getSavingsGoalById(id);

      final model = SavingsGoalModel(
        id: id,
        name: name,
        targetAmount: targetAmount,
        currentAmount: existing.currentAmount,
        currencyCode: currencyCode,
        description: description,
        deadline: deadline,
        iconName: iconName,
        colorHex: colorHex,
        status: status.name,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await _local.saveSavingsGoal(model);
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: jsonEncode(model.toJson()),
      );

      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavingsGoal(String id) async {
    try {
      await _local.deleteSavingsGoal(id);
      await _local.enqueueSync(
        entityId: id,
        operation: 'delete',
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SavingsContribution>> contributeToGoal({
    required String goalId,
    required double amount,
    required ContributionSource source,
    String? note,
  }) async {
    try {
      final now = DateTime.now();
      final id = const Uuid().v4();

      final model = SavingsContributionModel(
        id: id,
        goalId: goalId,
        amount: amount,
        source: source.name,
        note: note,
        date: now,
        createdAt: now,
        isSynced: false,
      );

      await _local.saveContribution(model);

      // Update goal's current amount.
      final goal = await _local.getSavingsGoalById(goalId);
      final newAmount = goal.currentAmount + amount;
      await _local.updateGoalAmount(goalId, newAmount);

      // Auto-complete if target reached.
      if (newAmount >= goal.targetAmount) {
        final completedModel = SavingsGoalModel(
          id: goalId,
          name: goal.name,
          targetAmount: goal.targetAmount,
          currentAmount: newAmount,
          currencyCode: goal.currencyCode,
          description: goal.description,
          deadline: goal.deadline,
          iconName: goal.iconName,
          colorHex: goal.colorHex,
          status: SavingsGoalStatus.completed.name,
          createdAt: goal.createdAt,
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await _local.saveSavingsGoal(completedModel);
      }

      await _local.enqueueSync(
        entityId: id,
        operation: 'create',
        payload: jsonEncode(model.toJson()),
      );

      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals({
    SavingsGoalStatus? status,
  }) async {
    try {
      final goals = await _local.getSavingsGoals(status: status);

      if (await _networkInfo.isConnected) {
        _backgroundRefresh();
      }

      return Right(goals);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> getSavingsGoalById(String id) async {
    try {
      final goal = await _local.getSavingsGoalById(id);
      return Right(goal);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<SavingsGoal>> watchSavingsGoals() {
    return _local.watchSavingsGoals();
  }

  @override
  Future<Either<Failure, List<SavingsContribution>>> getContributions(
    String goalId,
  ) async {
    try {
      final contributions = await _local.getContributions(goalId);
      return Right(contributions);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<SavingsContribution>> watchContributions(String goalId) {
    return _local.watchContributions(goalId);
  }

  @override
  Future<Either<Failure, void>> refreshFromServer() async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final remoteModels = await _remote.getAllSavingsGoals();
      await _local.replaceAllFromServer(remoteModels);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  void _backgroundRefresh() {
    Future(() async {
      try {
        final remoteModels = await _remote.getAllSavingsGoals();
        await _local.replaceAllFromServer(remoteModels);
      } catch (_) {
        // Silently ignore background refresh errors.
      }
    });
  }
}
