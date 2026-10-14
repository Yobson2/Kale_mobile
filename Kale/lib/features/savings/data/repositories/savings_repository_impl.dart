import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_remote_datasource.dart';
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
///
/// Goals and contributions are two sync entity types. A goal's saved
/// amount is derived on the device (the sum of its contributions) and
/// pushed as a goal update; the server never computes it.
class SavingsRepositoryImpl implements SavingsRepository {
  /// Creates a [SavingsRepositoryImpl].
  const SavingsRepositoryImpl({
    required SavingsRemoteDataSource remoteDataSource,
    required SavingsLocalDataSource localDataSource,
    required SavingsContributionsRemoteDataSource contributionsRemoteDataSource,
    required SavingsContributionsLocalDataSource contributionsLocalDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _contributionsRemote = contributionsRemoteDataSource,
        _contributionsLocal = contributionsLocalDataSource,
        _networkInfo = networkInfo;

  final SavingsRemoteDataSource _remote;
  final SavingsLocalDataSource _local;
  final SavingsContributionsRemoteDataSource _contributionsRemote;
  final SavingsContributionsLocalDataSource _contributionsLocal;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, SavingsGoal>> createSavingsGoal({
    required String name,
    required int targetAmountMinor,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    if (targetAmountMinor <= 0) {
      return const Left(
        ValidationFailure(message: 'The target must be more than zero'),
      );
    }
    try {
      final now = DateTime.now();
      final model = SavingsGoalModel(
        id: const Uuid().v4(),
        name: name,
        targetAmountMinor: targetAmountMinor,
        description: description,
        deadline: deadline,
        iconName: iconName,
        colorHex: colorHex,
        status: SavingsGoalStatus.active.name,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      await _saveGoal(model, operation: 'create');
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal({
    required String id,
    required String name,
    required int targetAmountMinor,
    required SavingsGoalStatus status,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    if (targetAmountMinor <= 0) {
      return const Left(
        ValidationFailure(message: 'The target must be more than zero'),
      );
    }
    try {
      final existing = await _local.getSavingsGoalById(id);
      final model = _modelOf(existing).copyWith(
        name: name,
        targetAmountMinor: targetAmountMinor,
        description: description,
        deadline: deadline,
        iconName: iconName,
        colorHex: colorHex,
        status: status.name,
        updatedAt: DateTime.now(),
      );

      await _saveGoal(model, operation: 'update');
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavingsGoal(String id) async {
    try {
      // A delete is a soft delete, synced as an update carrying
      // `deleted_at`. The goal's contributions are deleted with it.
      final now = DateTime.now();
      final goal = await _local.deleteSavingsGoal(id, now);
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: jsonEncode(goal.toJson()),
      );
      final contributions =
          await _contributionsLocal.deleteContributionsOfGoal(id, now);
      for (final contribution in contributions) {
        await _contributionsLocal.enqueueSync(
          entityId: contribution.id,
          operation: 'update',
          payload: jsonEncode(contribution.toJson()),
        );
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SavingsContribution>> contributeToGoal({
    required String goalId,
    required int amountMinor,
    required ContributionSource source,
    String? note,
  }) async {
    if (amountMinor <= 0) {
      return const Left(
        ValidationFailure(message: 'A contribution must be more than zero'),
      );
    }
    try {
      final goal = await _local.getSavingsGoalById(goalId);
      final now = DateTime.now();

      final contribution = SavingsContributionModel(
        id: const Uuid().v4(),
        goalId: goalId,
        amountMinor: amountMinor,
        source: source.name,
        note: note,
        date: now,
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );
      await _contributionsLocal.saveContribution(contribution);
      await _contributionsLocal.enqueueSync(
        entityId: contribution.id,
        operation: 'create',
        payload: jsonEncode(contribution.toJson()),
      );

      // The device owns the saved amount: recompute it from the goal's
      // contributions, so it is never counted twice.
      final saved = await _contributionsLocal.getTotalForGoal(goalId);
      final reachedTarget = goal.status == SavingsGoalStatus.active &&
          saved >= goal.targetAmountMinor;
      await _saveGoal(
        _modelOf(goal).copyWith(
          currentAmountMinor: saved,
          status: reachedTarget
              ? SavingsGoalStatus.completed.name
              : goal.status.name,
          updatedAt: now,
        ),
        operation: 'update',
      );

      return Right(contribution.toEntity());
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
      return Right(await _local.getSavingsGoalById(id));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<SavingsGoal>> watchSavingsGoals() => _local.watchSavingsGoals();

  @override
  Future<Either<Failure, List<SavingsContribution>>> getContributions(
    String goalId,
  ) async {
    try {
      return Right(await _contributionsLocal.getContributions(goalId));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<SavingsContribution>> watchContributions(String goalId) =>
      _contributionsLocal.watchContributions(goalId);

  @override
  Future<Either<Failure, void>> refreshFromServer() async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      await _pullFromServer();
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

  /// Saves [model] as an unsynced local change and queues it for sync.
  Future<void> _saveGoal(
    SavingsGoalModel model, {
    required String operation,
  }) async {
    final unsynced = model.copyWith(isSynced: false);
    await _local.saveSavingsGoal(unsynced);
    await _local.enqueueSync(
      entityId: unsynced.id,
      operation: operation,
      payload: jsonEncode(unsynced.toJson()),
    );
  }

  /// Rebuilds the stored model of a goal read back from the device.
  static SavingsGoalModel _modelOf(SavingsGoal goal) => SavingsGoalModel(
        id: goal.id,
        name: goal.name,
        targetAmountMinor: goal.targetAmountMinor,
        currentAmountMinor: goal.currentAmountMinor,
        description: goal.description,
        deadline: goal.deadline,
        iconName: goal.iconName,
        colorHex: goal.colorHex,
        status: goal.status.name,
        createdAt: goal.createdAt,
        updatedAt: goal.updatedAt,
        isSynced: goal.isSynced,
      );

  Future<void> _pullFromServer() async {
    final goals = await _remote.getAllSavingsGoals();
    final contributions = await _contributionsRemote.getAllContributions();
    await _local.replaceAllFromServer(goals);
    await _contributionsLocal.replaceAllFromServer(contributions);
  }

  void _backgroundRefresh() {
    Future(() async {
      try {
        await _pullFromServer();
      } catch (_) {
        // Silently ignore background refresh errors.
      }
    });
  }
}
