import 'dart:convert';

import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_local_datasource.dart';
import 'package:kale/features/savings/data/datasources/savings_contributions_remote_datasource.dart';
import 'package:kale/features/savings/data/models/savings_contribution_model.dart';

/// [SyncHandler] for savings contributions (entity type
/// `savings_contribution`).
///
/// Payloads are [SavingsContributionModel] JSON. Pushing a contribution
/// never changes its goal on the server: the goal's saved amount is pushed
/// separately, as a goal update computed on the device.
class SavingsContributionsSyncHandler implements SyncHandler {
  /// Creates a [SavingsContributionsSyncHandler].
  const SavingsContributionsSyncHandler({
    required SavingsContributionsRemoteDataSource remoteDataSource,
    required SavingsContributionsLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final SavingsContributionsRemoteDataSource _remote;
  final SavingsContributionsLocalDataSource _local;

  @override
  String get entityType => 'savings_contribution';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    final created = await _remote.createContribution(_decode(payload));
    await _local.markSynced(entityId, serverId: created.serverId);
    return created.serverId ?? created.id;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    await _remote.updateContribution(_decode(payload));
    await _local.markSynced(entityId);
  }

  @override
  Future<String?> fetchRemote(String entityId) async {
    try {
      final model = await _remote.getContributionById(entityId);
      return jsonEncode(model.toJson());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> applyServerVersion(
    String entityId,
    String serverPayload,
  ) async {
    final model = _decode(serverPayload);
    await _local.saveContribution(model.copyWith(isSynced: true));
  }

  static SavingsContributionModel _decode(String payload) =>
      SavingsContributionModel.fromJson(
        jsonDecode(payload) as Map<String, dynamic>,
      );
}
