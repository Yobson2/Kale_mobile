import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/budget/data/daos/budgets_dao.dart';
import 'package:kale/features/budget/data/models/budget_model.dart';

/// Local data source for budgets using Drift (SQLite).
abstract class BudgetsLocalDataSource {
  /// Watches all budgets reactively.
  Stream<List<BudgetModel>> watchBudgets();

  /// Gets all budgets.
  Future<List<BudgetModel>> getBudgets();

  /// Gets the budget whose period covers [today].
  Future<BudgetModel?> getActiveBudget(CalendarDate today);

  /// Gets a single budget by ID.
  Future<BudgetModel?> getBudgetById(String id);

  /// Inserts or updates a budget.
  Future<void> saveBudget(BudgetModel model);

  /// Soft-deletes a live budget at [at] and returns it, to be queued as an
  /// update. Its allocations are deleted through their own datasource.
  ///
  /// Throws [CacheException] if no live budget has this [id].
  Future<BudgetModel> deleteBudget(String id, DateTime at);

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
    required SyncQueueDao syncQueueDao,
  })  : _budgetsDao = budgetsDao,
        _syncQueueDao = syncQueueDao;

  final BudgetsDao _budgetsDao;
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
  Future<BudgetModel?> getActiveBudget(CalendarDate today) async {
    try {
      final row = await _budgetsDao.getActiveOn(today);
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
  Future<BudgetModel> deleteBudget(String id, DateTime at) async {
    try {
      final row = await _budgetsDao.markDeleted(id, at);
      if (row == null) {
        throw CacheException(message: 'Budget not found: $id');
      }
      return BudgetModel.fromDrift(row);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to delete budget: $e');
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
