import 'dart:convert';

import 'package:kale/core/sync/pull.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:kale/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';

/// [SyncHandler] for the account profile. The server row always exists
/// (created at sign-up), so creates and updates are both updates.
class ProfileSyncHandler implements SyncHandler {
  const ProfileSyncHandler({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;

  @override
  String get entityType => 'profile';

  @override
  Future<String> pushCreate(String entityId, String payload) async {
    await pushUpdate(entityId, payload);
    return entityId;
  }

  @override
  Future<void> pushUpdate(String entityId, String payload) async {
    final model =
        ProfileModel.fromJson(jsonDecode(payload) as Map<String, dynamic>);
    await _remote.updateProfile(model);
    await _local.markSynced();
  }

  /// The profile is a single row: every pull fetches it whole, with no
  /// cursor, and keeps the local row if it has changes not yet pushed.
  @override
  Future<PulledPage> pullPage({
    required PullCursor? after,
    required int limit,
  }) async {
    final model = await _remote.getProfile();
    if (model == null) return const PulledPage(rowCount: 0);
    await _local.applyServerProfile(model);
    return const PulledPage(rowCount: 1);
  }

  /// The profile is not moved: the account the data moves to keeps its own
  /// profile (and base currency), pulled after the switch.
  @override
  Future<void> requeueAllAsCreates() async {}
}
