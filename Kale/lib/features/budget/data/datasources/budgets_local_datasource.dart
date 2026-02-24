import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/budget/data/daos/budget_categories_dao.dart';
import 'package:kale/features/budget/data/daos/budgets_dao.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';

/// Local data source for budgets using Drift (SQLite).
abstract class BudgetsLocalDataSource {
  /// Watches all budgets reactively.
  Stream<List<BudgetModel>> watchBudgets();

  /// Gets all budgets.
  Future<List<BudgetModel>> getBudgets();

  /// Gets the currently active budget.
  Future<BudgetModel?> getActiveBudget();

  /// Gets a single budget by ID.
  Future<BudgetModel?> getBudgetById(String id);

  /// Inserts or updates a budget.
  Future<void> saveBudget(BudgetModel model);

  /// Deletes a budget and its category allocations.
  Future<void> deleteBudget(String id);

  /// Saves category allocations for a budget, replacing existing ones.
  Future<void> saveBudgetCategories(
    String budgetId,
    List<BudgetCategoryModel> categories,
  );

  /// Gets all category allocations for a budget.
  Future<List<BudgetCategoryModel>> getBudgetCategories(String budgetId);

  /// Enqueues a sync operation for the given budget.
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });

  /// Marks a budget as synced.
  Future<void> markSynced(String id, {String? serverId});
}

/// Implementation of [BudgetsLocalDataSource] using Drift DAOs.
class BudgetsLocalDataSourceImpl implements BudgetsLocalDataSource {
  const BudgetsLocalDataSourceImpl({
    required BudgetsDao budgetsDao,
    required BudgetCategoriesDao budgetCategoriesDao,
    required SyncQueueDao syncQueueDao,
  })  : _budgetsDao = budgetsDao,
        _budgetCategoriesDao = budgetCategoriesDao,
        _syncQueueDao = syncQueueDao;

  final BudgetsDao _budgetsDao;
  final BudgetCategoriesDao _budgetCategoriesDao;
  final SyncQueueDao _syncQueueDao;

  static const _entityType = 'budget';

  @override
  Stream<List<BudgetModel>> watchBudgets() {
    return _budgetsDao.watchAll().map(
          (rows) => rows.map(BudgetModel.fromDrift).toList(),
        );
  }

  @override
  Future<List<BudgetModel>> getBudgets() async {
    try {
      final rows = await _budgetsDao.getAll();
      return rows.map(BudgetModel.fromDrift).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get budgets: $e');
    }
  }

  @override
  Future<BudgetModel?> getActiveBudget() async {
    try {
      final row = await _budgetsDao.getActive();
      return row != null ? BudgetModel.fromDrift(row) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get active budget: $e');
    }
  }

  @override
  Future<BudgetModel?> getBudgetById(String id) async {
    try {
      final row = await _budgetsDao.getById(id);
      return row != null ? BudgetModel.fromDrift(row) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get budget: $e');
    }
  }

  @override
  Future<void> saveBudget(BudgetModel model) async {
    try {
      await _budgetsDao.upsert(model.toDriftCompanion());
    } catch (e) {
      throw CacheException(message: 'Failed to save budget: $e');
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    try {
      await _budgetCategoriesDao.deleteByBudgetId(id);
      await _budgetsDao.deleteById(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete budget: $e');
    }
  }

  @override
  Future<void> saveBudgetCategories(
    String budgetId,
    List<BudgetCategoryModel> categories,
  ) async {
    try {
      final companions =
          categories.map((c) => c.toDriftCompanion()).toList();
      await _budgetCategoriesDao.replaceForBudget(budgetId, companions);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save budget categories: $e',
      );
    }
  }

  @override
  Future<List<BudgetCategoryModel>> getBudgetCategories(
    String budgetId,
  ) async {
    try {
      final rows = await _budgetCategoriesDao.getByBudgetId(budgetId);
      return rows.map(BudgetCategoryModel.fromDrift).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get budget categories: $e',
      );
    }
  }

  @override
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  }) async {
    try {
      await _syncQueueDao.enqueue(
        entityType: _entityType,
        entityId: entityId,
        operation: operation,
        payload: payload,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to enqueue sync: $e');
    }
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    try {
      await _budgetsDao.markSynced(id, serverId: serverId);
    } catch (e) {
      throw CacheException(message: 'Failed to mark budget synced: $e');
    }
  }
}
