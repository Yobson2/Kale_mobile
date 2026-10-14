import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/savings/data/daos/savings_contributions_dao.dart';
import 'package:kale/features/savings/data/daos/savings_goals_dao.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';

/// Local datasource for savings goals (sync entity type `savings_goal`).
///
/// Contributions have their own datasource and entity type: see
/// `SavingsContributionsLocalDataSource`.
abstract class SavingsLocalDataSource {
  Stream<List<SavingsGoal>> watchSavingsGoals();
  Future<List<SavingsGoal>> getSavingsGoals({SavingsGoalStatus? status});

  /// Throws [CacheException] if no live goal has this [id].
  Future<SavingsGoal> getSavingsGoalById(String id);

  /// Saves [model] locally, with its `isSynced` flag as given.
  Future<void> saveSavingsGoal(SavingsGoalModel model);

  /// Deletes a goal and its contributions locally.
  Future<void> deleteSavingsGoal(String id);

  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });
  Future<void> markSynced(String id, {String? serverId});

  /// Replaces synced goals with the server's copy; unsynced goals are kept.
  Future<void> replaceAllFromServer(List<SavingsGoalModel> models);
}

/// Implementation of [SavingsLocalDataSource].
class SavingsLocalDataSourceImpl implements SavingsLocalDataSource {
  /// Creates a [SavingsLocalDataSourceImpl].
  const SavingsLocalDataSourceImpl({
    required SavingsGoalsDao savingsGoalsDao,
    required SavingsContributionsDao savingsContributionsDao,
    required SyncQueueDao syncQueueDao,
  })  : _goalsDao = savingsGoalsDao,
        _contributionsDao = savingsContributionsDao,
        _syncQueueDao = syncQueueDao;

  final SavingsGoalsDao _goalsDao;
  final SavingsContributionsDao _contributionsDao;
  final SyncQueueDao _syncQueueDao;

  static const _entityType = 'savings_goal';

  @override
  Stream<List<SavingsGoal>> watchSavingsGoals() {
    return _goalsDao.watchAll().map(
          (rows) => rows
              .map((r) => SavingsGoalModel.fromDrift(r).toEntity())
              .toList(),
        );
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals({
    SavingsGoalStatus? status,
  }) async {
    try {
      final rows = await _goalsDao.getAll(status: status?.name);
      return rows.map((r) => SavingsGoalModel.fromDrift(r).toEntity()).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get savings goals: $e');
    }
  }

  @override
  Future<SavingsGoal> getSavingsGoalById(String id) async {
    try {
      final row = await _goalsDao.getById(id);
      if (row == null) {
        throw CacheException(message: 'Savings goal not found: $id');
      }
      return SavingsGoalModel.fromDrift(row).toEntity();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to get savings goal: $e');
    }
  }

  @override
  Future<void> saveSavingsGoal(SavingsGoalModel model) async {
    try {
      await _goalsDao.upsert(model.toDriftCompanion(isSynced: model.isSynced));
    } catch (e) {
      throw CacheException(message: 'Failed to save savings goal: $e');
    }
  }

  @override
  Future<void> deleteSavingsGoal(String id) async {
    try {
      await _contributionsDao.deleteByGoalId(id);
      await _goalsDao.deleteById(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete savings goal: $e');
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
      await _goalsDao.markSynced(id, serverId: serverId);
    } catch (e) {
      throw CacheException(message: 'Failed to mark savings goal synced: $e');
    }
  }

  @override
  Future<void> replaceAllFromServer(List<SavingsGoalModel> models) async {
    try {
      await _goalsDao.replaceAll(
        models.map((m) => m.toDriftCompanion(isSynced: true)).toList(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to replace savings goals: $e');
    }
  }
}
