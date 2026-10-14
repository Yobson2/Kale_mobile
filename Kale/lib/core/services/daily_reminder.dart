import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/storage/local_storage.dart';
import 'package:kale/l10n/app_localizations.dart';

/// The opt-in daily reminder to log transactions (decision Q22): off by
/// default, at a time the user picks, in the app's language.
class DailyReminder {
  /// Creates a [DailyReminder].
  const DailyReminder({
    required NotificationService notificationService,
    required LocalStorage localStorage,
    required AppLocalizations strings,
  })  : _notifications = notificationService,
        _storage = localStorage,
        _strings = strings;

  final NotificationService _notifications;
  final LocalStorage _storage;
  final AppLocalizations _strings;

  /// Whether the reminder is on.
  bool get isEnabled => _storage.isDailyReminderEnabled;

  /// When it fires, in minutes after midnight.
  int get minuteOfDay => _storage.dailyReminderMinuteOfDay;

  /// Turns the reminder on at [minuteOfDay] (minutes after midnight),
  /// replacing any earlier schedule.
  Future<void> enable(int minuteOfDay) async {
    await _storage.setDailyReminderMinuteOfDay(minuteOfDay);
    await _storage.setDailyReminderEnabled(enabled: true);
    await _schedule(minuteOfDay);
  }

  /// Turns the reminder off and cancels it.
  Future<void> disable() async {
    await _storage.setDailyReminderEnabled(enabled: false);
    await _notifications.cancelDailyReminder();
  }

  /// At launch: schedules the reminder again if it is on (so a changed
  /// language or time zone is picked up), and makes sure it is cancelled
  /// otherwise.
  Future<void> restore() =>
      isEnabled ? _schedule(minuteOfDay) : _notifications.cancelDailyReminder();

  Future<void> _schedule(int minuteOfDay) =>
      _notifications.scheduleDailyReminder(
        hour: minuteOfDay ~/ 60,
        minute: minuteOfDay % 60,
        title: _strings.notifDailyReminderTitle,
        body: _strings.notifDailyReminderBody,
      );
}
