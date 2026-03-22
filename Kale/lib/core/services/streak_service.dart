import 'package:kale/core/storage/local_storage.dart';

class StreakService {
  const StreakService(this._storage);

  final LocalStorage _storage;

  static const _countKey = 'streak_count';
  static const _lastDateKey = 'streak_last_date';

  int get currentStreak {
    final countStr = _storage.getString(_countKey);
    return int.tryParse(countStr ?? '') ?? 0;
  }

  Future<void> recordTransaction() async {
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final lastDate = _storage.getString(_lastDateKey);

    if (lastDate == today) return; // Already recorded today

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    int newCount;
    if (lastDate == yesterdayStr) {
      newCount = currentStreak + 1;
    } else {
      newCount = 1;
    }

    await _storage.setString(_countKey, newCount.toString());
    await _storage.setString(_lastDateKey, today);
  }
}
