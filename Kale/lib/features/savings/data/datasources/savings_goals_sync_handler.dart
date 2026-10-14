import 'dart:convert';

import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/savings/data/datasources/savings_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_remote_datasource.dart';
import 'package:kale/features/savings/data/models/savings_goal_model.dart';

/// [SyncHandler] for savings goals (entity type `savings_goal`).
///
/// Payloads are [SavingsGoalModel] JSON. Contributions are queued under
/// their own type and handled by `SavingsContributionsSyncHandler`.
class SavingsGoalsSyncHandler implements SyncHandler {
  /// Creates a [SavingsGoalsSyncHandler].
  const SavingsGoalsSyncHandler({
    required SavingsRemoteDataSource remoteDataSource,
    required SavingsLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final SavingsRemoteDataSource _remote;
  final SavingsLocalDataSource _local;

  @override
  String get entityType => 'savings_goal';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final created = await _remote.createSavingsGoal(_decode(payload));
    await _local.markSynced(entityId, serverId: created.serverId);
    return created.serverId ?? created.id;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    await _remote.updateSavingsGoal(_decode(payload));
    await _local.markSynced(entityId);
  }

  @override
  Future<PulledPage> pullPage({
    required PullCursor? after,
    required int limit,
  }) async {
    final page = await _remote.fetchPage(after: after, limit: limit);
    await _local.mergeFromServer(page.rows);
    return PulledPage(rowCount: page.rows.length, last: page.last);
  }

  @override
  Future<void> requeueAllAsCreates() => _local.enqueueAllAsCreates();

  static SavingsGoalModel _decode(String payload) =>
      SavingsGoalModel.fromJson(jsonDecode(payload) as Map<String, dynamic>);
}
