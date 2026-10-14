import 'package:kale/core/database/daos/sync_queue_dao.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/features/profile/data/daos/profile_dao.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';

/// Local data source for the account profile stored in Drift.
abstract class ProfileLocalDataSource {
  /// Watches the profile; emits null until one is saved.
  Stream<ProfileModel?> watchProfile();

  /// Gets the profile, or null if none is saved yet.
  Future<ProfileModel?> getProfile();

  /// Saves the profile locally as not yet synced.
  Future<void> saveProfile(ProfileModel model);

  /// Enqueues a sync operation for the profile.
  Future<void> enqueueSync({required String operation, String? payload});

  /// Marks the profile as synced.
  Future<void> markSynced();

  /// Applies the server copy, unless local changes are not yet synced.
  Future<void> applyServerProfile(ProfileModel model);
}

/// Drift-backed [ProfileLocalDataSource].
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl({
    required ProfileDao profileDao,
    required SyncQueueDao syncQueueDao,
  })  : _dao = profileDao,
        _syncQueueDao = syncQueueDao;

  final ProfileDao _dao;
  final SyncQueueDao _syncQueueDao;

  /// The entity type used in the sync queue for the profile.
  static const _entityType = 'profile';

  @override
  Stream<ProfileModel?> watchProfile() => _dao
      .watch(ProfileModel.localId)
      .map((row) => row == null ? null : ProfileModel.fromDrift(row));

  @override
  Future<ProfileModel?> getProfile() async {
    try {
      final row = await _dao.get(ProfileModel.localId);
      return row == null ? null : ProfileModel.fromDrift(row);
    } catch (e) {
      throw CacheException(message: 'Failed to read profile: $e');
    }
  }

  @override
  Future<void> saveProfile(ProfileModel model) async {
    try {
      await _dao.upsert(model.toDriftCompanion(isSynced: false));
    } catch (e) {
      throw CacheException(message: 'Failed to save profile: $e');
    }
  }

  @override
  Future<void> enqueueSync({required String operation, String? payload}) async {
    try {
      await _syncQueueDao.enqueue(
        entityType: _entityType,
        entityId: ProfileModel.localId,
        operation: operation,
        payload: payload,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to enqueue sync: $e');
    }
  }

  @override
  Future<void> markSynced() async {
    try {
      await _dao.markSynced(ProfileModel.localId);
    } catch (e) {
      throw CacheException(message: 'Failed to mark synced: $e');
    }
  }

  @override
  Future<void> applyServerProfile(ProfileModel model) async {
    try {
      await _dao.replaceIfSynced(model.toDriftCompanion(isSynced: true));
    } catch (e) {
      throw CacheException(message: 'Failed to apply server profile: $e');
    }
  }
}
