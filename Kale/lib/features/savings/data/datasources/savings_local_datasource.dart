import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/savings/data/daos/savings_contributions_dao.dart';
import 'package:kale/features/savings/data/daos/savings_goals_dao.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';

/// Abstract local datasource for savings goals.
abstract class SavingsLocalDataSource {
  Stream<List<SavingsGoal>> watchSavingsGoals();
  Future<List<SavingsGoal>> getSavingsGoals({SavingsGoalStatus? status});
  Future<SavingsGoal> getSavingsGoalById(String id);
  Future<void> saveSavingsGoal(SavingsGoalModel model);
  Future<void> deleteSavingsGoal(String id);
  Future<void> updateGoalAmount(String goalId, double newAmount);
  Stream<List<SavingsContribution>> watchContributions(String goalId);
  Future<List<SavingsContribution>> getContributions(String goalId);
  Future<void> saveContribution(SavingsContributionModel model);
  Future<void> enqueueSync({
    required String entityId,
    required String operation,
    String? payload,
  });
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
    return _goalsDao
        .watchAll()
        .map((rows) =>
            rows.map((r) => SavingsGoalModel.fromDrift(r).toEntity()).toList());
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals({
    SavingsGoalStatus? status,
  }) async {
    try {
      final rows = await _goalsDao.getAll(status: status?.name);
      return rows
          .map((r) => SavingsGoalModel.fromDrift(r).toEntity())
          .toList();
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
      await _goalsDao.upsert(model.toDriftCompanion());
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
  Future<void> updateGoalAmount(String goalId, double newAmount) async {
    try {
      await _goalsDao.updateCurrentAmount(goalId, newAmount);
    } catch (e) {
      throw CacheException(message: 'Failed to update goal amount: $e');
    }
  }

  @override
  Stream<List<SavingsContribution>> watchContributions(String goalId) {
    return _contributionsDao.watchByGoalId(goalId).map((rows) =>
        rows
            .map((r) => SavingsContributionModel.fromDrift(r).toEntity())
            .toList());
  }

  @override
  Future<List<SavingsContribution>> getContributions(String goalId) async {
    try {
      final rows = await _contributionsDao.getByGoalId(goalId);
      return rows
          .map((r) => SavingsContributionModel.fromDrift(r).toEntity())
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get contributions: $e');
    }
  }

  @override
  Future<void> saveContribution(SavingsContributionModel model) async {
    try {
      await _contributionsDao.insert(model.toDriftCompanion());
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
  Future<void> replaceAllFromServer(List<SavingsGoalModel> models) async {
    try {
      final companions = models.map((m) => m.toDriftCompanion()).toList();
      await _goalsDao.replaceAll(companions);
    } catch (e) {
      throw CacheException(message: 'Failed to replace savings goals: $e');
    }
  }
}
