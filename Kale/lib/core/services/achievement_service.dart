import 'package:flutter/material.dart';
import 'package:kale/core/storage/local_storage.dart';

/// Defines all available achievements in the app.
enum Achievement {
  firstTransaction(
    icon: Icons.receipt_long,
    color: Colors.blue,
    threshold: 1,
  ),
  streak7(
    icon: Icons.local_fire_department,
    color: Colors.orange,
    threshold: 7,
  ),
  streak30(
    icon: Icons.whatshot,
    color: Colors.deepOrange,
    threshold: 30,
  ),
  firstBudget(
    icon: Icons.account_balance_wallet,
    color: Colors.teal,
    threshold: 1,
  ),
  underBudget(
    icon: Icons.savings,
    color: Colors.green,
    threshold: 1,
  ),
  firstGoalCompleted(
    icon: Icons.emoji_events,
    color: Colors.amber,
    threshold: 1,
  ),
  transactions100(
    icon: Icons.star,
    color: Colors.purple,
    threshold: 100,
  );

  const Achievement({
    required this.icon,
    required this.color,
    required this.threshold,
  });

  final IconData icon;
  final Color color;
  final int threshold;

  /// Storage key for this achievement.
  String get _key => 'achievement_$name';
}

/// Levels based on total achievements unlocked.
enum UserLevel {
  beginner(0),
  explorer(2),
  pro(4),
  master(6);

  const UserLevel(this.minBadges);

  final int minBadges;
}

/// Tracks and queries achievement state via [LocalStorage].
class AchievementService {
  const AchievementService(this._storage);

  final LocalStorage _storage;

  /// Whether the given [achievement] has been unlocked.
  bool isUnlocked(Achievement achievement) =>
      _storage.getBool(achievement._key) ?? false;

  /// Unlocks the given [achievement]. Returns `true` if newly unlocked.
  Future<bool> unlock(Achievement achievement) async {
    if (isUnlocked(achievement)) return false;
    await _storage.setBool(achievement._key, value: true);
    return true;
  }

  /// Returns all unlocked achievements.
  List<Achievement> get unlockedAchievements =>
      Achievement.values.where(isUnlocked).toList();

  /// Returns the number of unlocked achievements.
  int get unlockedCount => unlockedAchievements.length;

  /// Returns the user's current level based on unlocked achievements.
  UserLevel get currentLevel {
    final count = unlockedCount;
    if (count >= UserLevel.master.minBadges) return UserLevel.master;
    if (count >= UserLevel.pro.minBadges) return UserLevel.pro;
    if (count >= UserLevel.explorer.minBadges) return UserLevel.explorer;
    return UserLevel.beginner;
  }
}
