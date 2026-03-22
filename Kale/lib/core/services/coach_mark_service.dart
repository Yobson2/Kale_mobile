import 'package:kale/core/storage/local_storage.dart';

/// Service to track whether the coach mark tour has been completed.
///
/// Uses [LocalStorage] to persist completion state across app sessions.
class CoachMarkService {
  /// Creates a [CoachMarkService] with the given [LocalStorage] instance.
  CoachMarkService(this._storage);

  final LocalStorage _storage;

  static const _completedKey = 'coach_marks_completed';

  /// Returns `true` if the coach mark tour has already been completed.
  bool isCompleted() {
    return _storage.getBool(_completedKey) ?? false;
  }

  /// Marks the coach mark tour as completed.
  Future<bool> markCompleted() {
    return _storage.setBool(_completedKey, value: true);
  }

  /// Resets the coach mark tour so it will show again.
  Future<bool> reset() {
    return _storage.remove(_completedKey);
  }
}
