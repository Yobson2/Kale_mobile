import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budget_categories_remote_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_local_datasource.dart';
import 'package:kale/features/budget/data/datasources/budgets_remote_datasource.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';
import 'package:kale/features/transactions/data/daos/transactions_dao.dart';
import 'package:uuid/uuid.dart';

/// Offline-first implementation of [BudgetsRepository].
///
/// Saves locally first, enqueues sync operations, and enriches
/// budget category allocations with spent amounts computed
/// from the transactions table, in minor units.
///
/// A budget and its allocations sync as two entity types (`budget` and
/// `budget_category`); a budget is always queued before its allocations.
class BudgetsRepositoryImpl implements BudgetsRepository {
  /// Creates a [BudgetsRepositoryImpl].
  const BudgetsRepositoryImpl({
    required BudgetsRemoteDataSource remoteDataSource,
    required BudgetsLocalDataSource localDataSource,
    required BudgetCategoriesRemoteDataSource categoriesRemoteDataSource,
    required BudgetCategoriesLocalDataSource categoriesLocalDataSource,
    required NetworkInfo networkInfo,
    required TransactionsDao transactionsDao,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _categoriesRemote = categoriesRemoteDataSource,
        _categoriesLocal = categoriesLocalDataSource,
        _networkInfo = networkInfo,
        _transactionsDao = transactionsDao;

  final BudgetsRemoteDataSource _remote;
  final BudgetsLocalDataSource _local;
  final BudgetCategoriesRemoteDataSource _categoriesRemote;
  final BudgetCategoriesLocalDataSource _categoriesLocal;
  final NetworkInfo _networkInfo;
  final TransactionsDao _transactionsDao;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      return Right(await _toEntities(await _local.getBudgets()));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Stream<List<Budget>> watchBudgets() {
    return _local.watchBudgets().asyncMap(_toEntities);
  }

  @override
  Future<Either<Failure, Budget?>> getActiveBudget({
    required CalendarDate today,
  }) async {
    try {
      final model = await _local.getActiveBudget(today);
      if (model == null) return const Right(null);
      return Right(await _toEntity(model));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Budget>> createBudget({
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required CalendarDate startDate,
    required CalendarDate endDate,
    required List<BudgetCategoryAllocation> categories,
    int periodStartDay = BudgetPeriodRange.defaultStartDay,
    int? totalIncomeMinor,
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
        periodStartDay: periodStartDay,
        totalIncomeMinor: totalIncomeMinor,
        isPercentageBased: isPercentageBased,
        createdAt: now,
        updatedAt: now,
      );

      await _local.saveBudget(budgetModel);
      await _local.enqueueSync(
        entityId: budgetId,
        operation: 'create',
        payload: jsonEncode(budgetModel.toJson()),
      );
      await _saveAllocations(budgetId, categories, now);

      return Right(await _toEntity(budgetModel));
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
    required CalendarDate startDate,
    required CalendarDate endDate,
    required List<BudgetCategoryAllocation> categories,
    int periodStartDay = BudgetPeriodRange.defaultStartDay,
    int? totalIncomeMinor,
    bool isPercentageBased = true,
  }) async {
    try {
      final now = DateTime.now();

      // Get the existing budget to preserve serverId and createdAt.
      final existing = await _local.getBudgetById(id);
      if (existing == null) {
        return const Left(CacheFailure(message: 'Budget not found'));
      }

      final updatedModel = existing.copyWith(
        name: name,
        strategy: strategy.name,
        period: period.name,
        startDate: startDate,
        endDate: endDate,
        periodStartDay: periodStartDay,
        totalIncomeMinor: totalIncomeMinor,
        isPercentageBased: isPercentageBased,
        updatedAt: now,
        isSynced: false,
      );

      await _local.saveBudget(updatedModel);
      await _local.enqueueSync(
        entityId: id,
        operation: 'update',
        payload: jsonEncode(updatedModel.toJson()),
      );
      await _saveAllocations(id, categories, now);

      return Right(await _toEntity(updatedModel));
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
      await _categoriesLocal.replaceAllFromServer(
        await _categoriesRemote.getAllBudgetCategories(),
      );
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

  /// Makes [categories] the allocations of budget [budgetId], saving each
  /// as an unsynced change and queueing it: new ones as creates, existing
  /// ones as updates, and dropped ones as deletes.
  ///
  /// An allocation without an id (the setup screen sends none) keeps the
  /// id of the existing allocation for the same category, so editing a
  /// budget updates its allocations rather than replacing them.
  Future<void> _saveAllocations(
    String budgetId,
    List<BudgetCategoryAllocation> categories,
    DateTime now,
  ) async {
    final existing = await _categoriesLocal.getBudgetCategories(budgetId);
    final unmatched = {for (final model in existing) model.id: model};

    for (final category in categories) {
      final match = category.id.isNotEmpty
          ? unmatched.remove(category.id)
          : _takeByCategory(unmatched, category.categoryId);
      final model = BudgetCategoryModel(
        id: match?.id ?? (category.id.isEmpty ? _uuid.v4() : category.id),
        budgetId: budgetId,
        categoryId: category.categoryId,
        groupName: category.groupName,
        allocatedMinor: category.allocatedMinor,
        allocatedPercentage: category.allocatedPercentage,
        createdAt: match?.createdAt ?? now,
        updatedAt: now,
      );
      await _categoriesLocal.saveBudgetCategory(model);
      await _categoriesLocal.enqueueSync(
        entityId: model.id,
        operation: match == null ? 'create' : 'update',
        payload: jsonEncode(model.toJson()),
      );
    }

    for (final dropped in unmatched.values) {
      await _categoriesLocal.deleteBudgetCategory(dropped.id);
      await _categoriesLocal.enqueueSync(
        entityId: dropped.id,
        operation: 'delete',
      );
    }
  }

  static BudgetCategoryModel? _takeByCategory(
    Map<String, BudgetCategoryModel> unmatched,
    String categoryId,
  ) {
    for (final model in unmatched.values) {
      if (model.categoryId == categoryId) return unmatched.remove(model.id);
    }
    return null;
  }

  Future<List<Budget>> _toEntities(List<BudgetModel> models) async {
    final budgets = <Budget>[];
    for (final model in models) {
      budgets.add(await _toEntity(model));
    }
    return budgets;
  }

  /// The budget with its allocations, each enriched with the amount spent
  /// in its category during the budget's period.
  Future<Budget> _toEntity(BudgetModel model) async {
    final categoryModels = await _categoriesLocal.getBudgetCategories(model.id);

    // The period's days, in the device's current time zone: from the first
    // instant of the first day to the last second of the last day
    // (transaction dates are stored to the second).
    final categoryTotals = await _transactionsDao.getCategoryTotals(
      startDate: model.startDate.startOfDayLocal(),
      endDate: model.endDate
          .addDays(1)
          .startOfDayLocal()
          .subtract(const Duration(seconds: 1)),
      type: 'expense',
    );
    final spentMinor = {
      for (final total in categoryTotals) total.categoryId: total.totalMinor,
    };

    return model.toEntity(
      categories: [
        for (final category in categoryModels)
          category.toEntity(spentMinor[category.categoryId] ?? 0),
      ],
    );
  }
}
