import 'dart:convert';

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

  /// The profile is never deleted from the device.
  @override
  Future<void> pushDelete(String entityId) async {}

  @override
  Future<String?> fetchRemote(String entityId) async {
    final model = await _remote.getProfile();
    return model == null ? null : jsonEncode(model.toJson());
  }

  @override
  Future<void> applyServerVersion(String entityId, String serverPayload) =>
      _local.applyServerProfile(
        ProfileModel.fromJson(
          jsonDecode(serverPayload) as Map<String, dynamic>,
        ),
      );
}
