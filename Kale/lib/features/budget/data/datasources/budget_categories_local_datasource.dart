import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/budget/data/daos/budget_categories_dao.dart';
import 'package:kale/features/budget/data/models/budget_category_model.dart';

/// Local datasource for budget category allocations (sync entity type
/// `budget_category`, distinct from the budget's `budget`).
abstract class BudgetCategoriesLocalDataSource {
  /// Gets the live allocations of a budget.
  Future<List<BudgetCategoryModel>> getBudgetCategories(String budgetId);

  /// Saves [model] locally, with its `isSynced` flag as given.
  Future<void> saveBudgetCategory(BudgetCategoryModel model);

  /// Removes an allocation from the device.
  Future<void> deleteBudgetCategory(String id);

  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });
  Future<void> markSynced(String id);

  /// Replaces synced allocations with the server's copy; unsynced ones
  /// are kept.
  Future<void> replaceAllFromServer(List<BudgetCategoryModel> models);
}

/// Implementation of [BudgetCategoriesLocalDataSource].
class BudgetCategoriesLocalDataSourceImpl
    implements BudgetCategoriesLocalDataSource {
  /// Creates a [BudgetCategoriesLocalDataSourceImpl].
  const BudgetCategoriesLocalDataSourceImpl({
    required BudgetCategoriesDao budgetCategoriesDao,
    required SyncQueueDao syncQueueDao,
  })  : _dao = budgetCategoriesDao,
        _syncQueueDao = syncQueueDao;

  final BudgetCategoriesDao _dao;
  final SyncQueueDao _syncQueueDao;

  static const _entityType = 'budget_category';

  @override
  Future<List<BudgetCategoryModel>> getBudgetCategories(
    String budgetId,
  ) async {
    try {
      final rows = await _dao.getByBudgetId(budgetId);
      return rows.map(BudgetCategoryModel.fromDrift).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get budget categories: $e');
    }
  }

  @override
  Future<void> saveBudgetCategory(BudgetCategoryModel model) async {
    try {
      await _dao.upsert(model.toDriftCompanion());
    } catch (e) {
      throw CacheException(message: 'Failed to save budget category: $e');
    }
  }

  @override
  Future<void> deleteBudgetCategory(String id) async {
    try {
      await _dao.deleteById(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete budget category: $e');
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
  Future<void> markSynced(String id) async {
    try {
      await _dao.markSynced(id);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark budget category synced: $e',
      );
    }
  }

  @override
  Future<void> replaceAllFromServer(List<BudgetCategoryModel> models) async {
    try {
      await _dao.replaceAll(
        models.map((m) => m.copyWith(isSynced: true).toDriftCompanion()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to replace budget categories: $e');
    }
  }
}
