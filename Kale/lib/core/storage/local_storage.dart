import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive local data.
///
/// Used for settings, cache flags, and feature toggles.
class LocalStorage {
  /// Creates a [LocalStorage] with the given `prefs` instance.
  const LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _firstLaunchKey = 'first_launch';

  // -- Theme --

  /// Gets the persisted theme mode string (system/light/dark).
  String? getThemeMode() => _prefs.getString(_themeModeKey);

  /// Persists the theme mode [value].
  Future<bool> setThemeMode(String value) =>
      _prefs.setString(_themeModeKey, value);

  // -- Locale --

  /// Gets the persisted locale code (e.g. 'en', 'fr').
  String? getLocale() => _prefs.getString(_localeKey);

  /// Persists the locale [code].
  Future<bool> setLocale(String code) => _prefs.setString(_localeKey, code);

  // -- Onboarding --

  /// Whether the user has completed onboarding.
  bool get isOnboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  /// Marks onboarding as complete.
  Future<bool> setOnboardingComplete() =>
      _prefs.setBool(_onboardingCompleteKey, true);

  // -- First Launch --

  /// Whether this is the first app launch.
  bool get isFirstLaunch => _prefs.getBool(_firstLaunchKey) ?? true;

  /// Marks the first launch as done.
  Future<bool> setFirstLaunchDone() => _prefs.setBool(_firstLaunchKey, false);

  // -- Backup --

  static const _lastBackupAtKey = 'last_backup_at';

  /// When the sync queue was last fully pushed, or null if never.
  DateTime? getLastBackupAt() {
    final millis = _prefs.getInt(_lastBackupAtKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Persists the last successful backup [time].
  Future<bool> setLastBackupAt(DateTime time) =>
      _prefs.setInt(_lastBackupAtKey, time.millisecondsSinceEpoch);

  /// Forgets the last backup time (the user logged out).
  Future<bool> clearLastBackupAt() => _prefs.remove(_lastBackupAtKey);

  // -- User progress --

  /// Key prefixes of the signed-in user's own progress: the streak
  /// (`StreakService`), unlocked achievements (`AchievementService`) and the
  /// one-time notifications already shown ([wasNotified]). Device settings
  /// (theme, locale, onboarding, reminder time) are not included.
  static const _userProgressKeyPrefixes = [
    'streak_',
    'achievement_',
    _notifiedKeyPrefix,
  ];

  /// Removes the user's own progress, so the next person to sign in on
  /// this phone does not inherit it.
  Future<void> clearUserProgress() async {
    final keys = _prefs.getKeys().where(
          (key) => _userProgressKeyPrefixes.any(key.startsWith),
        );
    for (final key in keys.toList()) {
      await _prefs.remove(key);
    }
  }

  // -- Notifications --

  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _dailyReminderEnabledKey = 'daily_reminder_enabled';
  static const _dailyReminderMinuteOfDayKey = 'daily_reminder_minute_of_day';
  static const _notifiedKeyPrefix = 'notified_';

  /// Whether notifications are enabled.
  bool get isNotificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? true;

  /// Toggles notifications on/off.
  Future<bool> setNotificationsEnabled({required bool enabled}) =>
      _prefs.setBool(_notificationsEnabledKey, enabled);

  /// Whether the daily reminder is on. Opt-in: off until the user turns it
  /// on (decision Q22).
  bool get isDailyReminderEnabled =>
      _prefs.getBool(_dailyReminderEnabledKey) ?? false;

  /// Toggles daily reminders.
  Future<bool> setDailyReminderEnabled({required bool enabled}) =>
      _prefs.setBool(_dailyReminderEnabledKey, enabled);

  /// When the daily reminder fires, in minutes after midnight (default
  /// 20:00).
  int get dailyReminderMinuteOfDay =>
      _prefs.getInt(_dailyReminderMinuteOfDayKey) ?? 20 * 60;

  /// Sets when the daily reminder fires.
  Future<bool> setDailyReminderMinuteOfDay(int minuteOfDay) =>
      _prefs.setInt(_dailyReminderMinuteOfDayKey, minuteOfDay);

  /// Whether the one-time notification [key] was already shown (a budget
  /// threshold or a savings milestone). Cleared on logout.
  bool wasNotified(String key) =>
      _prefs.getBool('$_notifiedKeyPrefix$key') ?? false;

  /// Records that the one-time notification [key] was shown.
  Future<bool> markNotified(String key) =>
      _prefs.setBool('$_notifiedKeyPrefix$key', true);

  // -- Generic --

  /// Reads a string value by [key].
  String? getString(String key) => _prefs.getString(key);

  /// Writes a string [value] for the given [key].
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Reads a bool value by [key].
  bool? getBool(String key) => _prefs.getBool(key);

  /// Writes a bool [value] for the given [key].
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  /// Removes a value by [key].
  Future<bool> remove(String key) => _prefs.remove(key);

  /// Clears all stored data.
  Future<bool> clear() => _prefs.clear();
}
