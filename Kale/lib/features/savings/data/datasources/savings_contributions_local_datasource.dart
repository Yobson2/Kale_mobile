import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/savings/data/daos/savings_contributions_dao.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';

/// Local datasource for savings contributions (sync entity type
/// `savings_contribution`, distinct from the goal's `savings_goal`).
abstract class SavingsContributionsLocalDataSource {
  Stream<List<SavingsContribution>> watchContributions(String goalId);
  Future<List<SavingsContribution>> getContributions(String goalId);

  /// The total contributed to a goal, in minor units.
  Future<int> getTotalForGoal(String goalId);

  /// Saves [model] locally, with its `isSynced` flag as given.
  Future<void> saveContribution(SavingsContributionModel model);

  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });
  Future<void> markSynced(String id, {String? serverId});

  /// Replaces synced contributions with the server's copy; unsynced ones
  /// are kept.
  Future<void> replaceAllFromServer(List<SavingsContributionModel> models);
}

/// Implementation of [SavingsContributionsLocalDataSource].
class SavingsContributionsLocalDataSourceImpl
    implements SavingsContributionsLocalDataSource {
  /// Creates a [SavingsContributionsLocalDataSourceImpl].
  const SavingsContributionsLocalDataSourceImpl({
    required SavingsContributionsDao savingsContributionsDao,
    required SyncQueueDao syncQueueDao,
  })  : _dao = savingsContributionsDao,
        _syncQueueDao = syncQueueDao;

  final SavingsContributionsDao _dao;
  final SyncQueueDao _syncQueueDao;

  static const _entityType = 'savings_contribution';

  @override
  Stream<List<SavingsContribution>> watchContributions(String goalId) {
    return _dao.watchByGoalId(goalId).map(
          (rows) => rows
              .map((r) => SavingsContributionModel.fromDrift(r).toEntity())
              .toList(),
        );
  }

  @override
  Future<List<SavingsContribution>> getContributions(String goalId) async {
    try {
      final rows = await _dao.getByGoalId(goalId);
      return rows
          .map((r) => SavingsContributionModel.fromDrift(r).toEntity())
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get contributions: $e');
    }
  }

  @override
  Future<int> getTotalForGoal(String goalId) async {
    try {
      return await _dao.getTotalByGoalId(goalId);
    } catch (e) {
      throw CacheException(message: 'Failed to total contributions: $e');
    }
  }

  @override
  Future<void> saveContribution(SavingsContributionModel model) async {
    try {
      await _dao.upsert(model.toDriftCompanion(isSynced: model.isSynced));
    } catch (e) {
      throw CacheException(message: 'Failed to save contribution: $e');
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
      await _dao.markSynced(id, serverId: serverId);
    } catch (e) {
      throw CacheException(message: 'Failed to mark contribution synced: $e');
    }
  }

  @override
  Future<void> replaceAllFromServer(
    List<SavingsContributionModel> models,
  ) async {
    try {
      await _dao.replaceAll(
        models.map((m) => m.toDriftCompanion(isSynced: true)).toList(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to replace contributions: $e');
    }
  }
}
