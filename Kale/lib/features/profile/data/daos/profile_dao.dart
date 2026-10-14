import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/profile/data/tables/profiles_table.dart';

part 'profile_dao.g.dart';

/// DAO for the single-row profiles table.
@DriftAccessor(tables: [Profiles])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  /// Watches the profile row with [id] (null until one is saved).
  Stream<Profile?> watch(String id) =>
      (select(profiles)..where((p) => p.id.equals(id))).watchSingleOrNull();

  /// Gets the profile row with [id], or null.
  Future<Profile?> get(String id) =>
      (select(profiles)..where((p) => p.id.equals(id))).getSingleOrNull();

  /// Inserts or replaces the profile row.
  Future<void> upsert(ProfilesCompanion entry) =>
      into(profiles).insertOnConflictUpdate(entry);

  /// Marks the profile row as synced.
  Future<void> markSynced(String id) =>
      (update(profiles)..where((p) => p.id.equals(id)))
          .write(const ProfilesCompanion(isSynced: Value(true)));

  /// Replaces the profile with the server copy, unless the local row has
  /// changes not yet synced.
  Future<void> replaceIfSynced(ProfilesCompanion serverRow) {
    return transaction(() async {
      final local = await get(serverRow.id.value);
      if (local != null && !local.isSynced) return;
      await upsert(serverRow);
    });
  }
}
