import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/features/budget/data/datasources/budgets_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';
import 'package:kale/features/transactions/data/daos/transactions_dao.dart';
import 'package:uuid/uuid.dart';

/// Offline-first implementation of [BudgetsRepository].
///
/// Saves locally first, enqueues sync operations, and enriches
/// budget category allocations with spent amounts computed
/// from the transactions table.
class BudgetsRepositoryImpl implements BudgetsRepository {
  /// Creates a [BudgetsRepositoryImpl].
  const BudgetsRepositoryImpl({
    required BudgetsRemoteDataSource remoteDataSource,
    required BudgetsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required TransactionsDao transactionsDao,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo,
        _transactionsDao = transactionsDao;

  final BudgetsRemoteDataSource _remote;
  final BudgetsLocalDataSource _local;
  final NetworkInfo _networkInfo;
  final TransactionsDao _transactionsDao;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final models = await _local.getBudgets();
      final budgets = <Budget>[];

      for (final model in models) {
        final categories = await _enrichCategories(
          model.id,
          model.startDate,
          model.endDate,
        );
        budgets.add(model.toEntity(categories: categories));
      }

      return Right(budgets);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<Budget>> watchBudgets() {
    return _local.watchBudgets().asyncMap((models) async {
      final budgets = <Budget>[];
      for (final model in models) {
        final categories = await _enrichCategories(
          model.id,
          model.startDate,
          model.endDate,
        );
        budgets.add(model.toEntity(categories: categories));
      }
      return budgets;
    });
  }

  @override
  Future<Either<Failure, Budget?>> getActiveBudget() async {
    try {
      final model = await _local.getActiveBudget();
      if (model == null) return const Right(null);

      final categories = await _enrichCategories(
        model.id,
        model.startDate,
        model.endDate,
      );

      return Right(model.toEntity(categories: categories));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Budget>> createBudget({
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    required List<BudgetCategoryAllocation> categories,
    double? totalIncome,
    bool isPercentageBased = true,
  }) async {
    try {
      final now = DateTime.now();
      final budgetId = _uuid.v4();

      final budgetModel = BudgetModel(
        id: budgetId,
        name: name,
        strategy: strategy.name,
        period: period.name,
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
        isPercentageBased: isPercentageBased,
        createdAt: now,
        updatedAt: now,
      );

      // Save budget locally.
      await _local.saveBudget(budgetModel);

      // Build and save category allocations.
      final categoryModels = categories.map((cat) {
        return BudgetCategoryModel(
          id: cat.id.isEmpty ? _uuid.v4() : cat.id,
          budgetId: budgetId,
          categoryId: cat.categoryId,
          groupName: cat.groupName,
          allocatedAmount: cat.allocatedAmount,
          allocatedPercentage: cat.allocatedPercentage,
          createdAt: now,
        );
      }).toList();

      await _local.saveBudgetCategories(budgetId, categoryModels);

      // Enqueue sync.
      await _local.enqueueSync(
        entityId: budgetId,
        operation: 'create',
        payload: jsonEncode(budgetModel.toJson()),
      );

      // Return the entity with enriched categories (spent = 0 for new).
      final enrichedCategories = categoryModels
          .map((c) => c.toEntity(0))
          .toList();

      return Right(budgetModel.toEntity(categories: enrichedCategories));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget({
    required String id,
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    required List<BudgetCategoryAllocation> categories,
    double? totalIncome,
    bool isPercentageBased = true,
  }) async {
    try {
      final now = DateTime.now();

      // Get the existing budget to preserve serverId and createdAt.
      final existing = await _local.getBudgetById(id);
      if (existing == null) {
        return const Left(CacheFailure(message: 'Budget not found'));
      }

      final updatedModel = BudgetModel(
        id: id,
        serverId: existing.serverId,
        name: name,
        strategy: strategy.name,
        period: period.name,
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
        isPercentageBased: isPercentageBased,
        createdAt: existing.createdAt,
        updatedAt: now,
      );

      // Save budget locally.
      await _local.saveBudget(updatedModel);

      // Build and save category allocations.
      final categoryModels = categories.map((cat) {
        return BudgetCategoryModel(
          id: cat.id.isEmpty ? _uuid.v4() : cat.id,
          budgetId: id,
          categoryId: cat.categoryId,
          groupName: cat.groupName,
          allocatedAmount: cat.allocatedAmount,
          allocatedPercentage: cat.allocatedPercentage,
          createdAt: cat.createdAt,
        );
      }).toList();

      await _local.saveBudgetCategories(id, categoryModels);

      // Enqueue sync.
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: jsonEncode(updatedModel.toJson()),
      );

      // Enrich with spent amounts.
      final enrichedCategories = await _enrichCategories(
        id,
        startDate,
        endDate,
      );

      return Right(updatedModel.toEntity(categories: enrichedCategories));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await _local.deleteBudget(id);
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
  Future<Either<Failure, void>> refreshFromServer() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final serverModels = await _remote.getAllBudgets();
      for (final model in serverModels) {
        await _local.saveBudget(model.copyWith(isSynced: true));
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  /// Enriches budget category allocations with spent amounts
  /// computed from the transactions table.
  Future<List<BudgetCategoryAllocation>> _enrichCategories(
    String budgetId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final categoryModels = await _local.getBudgetCategories(budgetId);

    // Get expense totals per category for this budget's date range.
    final categoryTotals = await _transactionsDao.getCategoryTotals(
      startDate: startDate,
      endDate: endDate,
      type: 'expense',
    );

    // Build a lookup map: categoryId -> total spent.
    final spentMap = <String, double>{};
    for (final ct in categoryTotals) {
      spentMap[ct.categoryId] = ct.total;
    }

    return categoryModels.map((model) {
      final spent = spentMap[model.categoryId] ?? 0;
      return model.toEntity(spent);
    }).toList();
  }
}
