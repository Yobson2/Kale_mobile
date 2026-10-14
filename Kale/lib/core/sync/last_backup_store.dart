import 'package:kale/core/storage/local_storage.dart';

/// Persists when the sync queue was last fully pushed, so the backup
/// status survives app restarts.
abstract class LastBackupStore {
  /// The last successful backup time, or null if there never was one.
  DateTime? read();

  /// Records a successful backup at [time].
  Future<void> write(DateTime time);

  /// Forgets the last backup time (the user logged out).
  Future<void> clear();
}

/// [LastBackupStore] backed by [LocalStorage] (SharedPreferences).
class PreferencesLastBackupStore implements LastBackupStore {
  /// Creates a [PreferencesLastBackupStore].
  const PreferencesLastBackupStore(this._storage);

  final LocalStorage _storage;

  @override
  DateTime? read() => _storage.getLastBackupAt();

  @override
  Future<void> write(DateTime time) async {
    await _storage.setLastBackupAt(time);
  }

  @override
  Future<void> clear() async {
    await _storage.clearLastBackupAt();
  }
}

/// [LastBackupStore] that keeps the value in memory only.
class InMemoryLastBackupStore implements LastBackupStore {
  DateTime? _time;

  @override
  DateTime? read() => _time;

  @override
  Future<void> write(DateTime time) async => _time = time;

  @override
  Future<void> clear() async => _time = null;
}
