import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive local data.
///
/// Used for settings, cache flags, and feature toggles.
class LocalStorage {
  /// Creates a [LocalStorage] with the given [prefs] instance.
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

  // -- Currency --

  static const _currencyCodeKey = 'currency_code';

  /// Gets the user's preferred currency code (e.g. 'XOF', 'NGN').
  String? getCurrencyCode() => _prefs.getString(_currencyCodeKey);

  /// Persists the user's preferred currency [code].
  Future<bool> setCurrencyCode(String code) =>
      _prefs.setString(_currencyCodeKey, code);

  // -- Notifications --

  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _budgetAlertThresholdKey = 'budget_alert_threshold';
  static const _dailyReminderEnabledKey = 'daily_reminder_enabled';

  /// Whether notifications are enabled.
  bool get isNotificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? true;

  /// Toggles notifications on/off.
  Future<bool> setNotificationsEnabled({required bool enabled}) =>
      _prefs.setBool(_notificationsEnabledKey, enabled);

  /// Gets the budget alert threshold (0.0 to 1.0, default 0.8).
  double get budgetAlertThreshold =>
      _prefs.getDouble(_budgetAlertThresholdKey) ?? 0.8;

  /// Sets the budget alert threshold.
  Future<bool> setBudgetAlertThreshold(double threshold) =>
      _prefs.setDouble(_budgetAlertThresholdKey, threshold);

  /// Whether daily transaction reminders are enabled.
  bool get isDailyReminderEnabled =>
      _prefs.getBool(_dailyReminderEnabledKey) ?? true;

  /// Toggles daily reminders.
  Future<bool> setDailyReminderEnabled({required bool enabled}) =>
      _prefs.setBool(_dailyReminderEnabledKey, enabled);

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
