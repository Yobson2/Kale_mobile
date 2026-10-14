import 'package:kale/core/utils/logger.dart';

/// Notification channel identifiers.
abstract final class NotificationChannels {
  static const String budgetAlert = 'budget_alert';
  static const String budgetAlertName = 'Budget Alerts';
  static const String budgetAlertDesc =
      'Alerts when spending approaches budget limits';

  static const String dailyReminder = 'daily_reminder';
  static const String dailyReminderName = 'Daily Reminders';
  static const String dailyReminderDesc = 'Reminders to log daily transactions';

  static const String savingsMilestone = 'savings_milestone';
  static const String savingsMilestoneName = 'Savings Milestones';
  static const String savingsMilestoneDesc =
      'Celebrations when savings goals hit milestones';
}

/// Notification IDs to avoid collisions.
abstract final class NotificationIds {
  static const int budgetAlert = 1000;
  static const int dailyReminder = 2000;
  static const int savingsMilestone = 3000;
}

/// Abstract notification service interface.
abstract class NotificationService {
  /// Initialize the notification service.
  Future<void> init();

  /// Shows a budget alert. [id] distinguishes alerts (one per category);
  /// [title] and [body] are already in the app's language.
  Future<void> showBudgetAlert({
    required int id,
    required String title,
    required String body,
  });

  /// Shows a savings milestone. [id] distinguishes goals; [title] and
  /// [body] are already in the app's language.
  Future<void> showSavingsMilestone({
    required int id,
    required String title,
    required String body,
  });

  /// Schedules the daily reminder at [hour]:[minute], replacing any
  /// earlier one; [title] and [body] are already in the app's language.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  });

  /// Cancel the daily reminder.
  Future<void> cancelDailyReminder();

  /// Cancel all notifications.
  Future<void> cancelAll();
}

/// Development notification service that only logs.
class DevNotificationService implements NotificationService {
  @override
  Future<void> init() async {
    AppLogger.info('NotificationService initialized (dev mode)', tag: 'Notif');
  }

  @override
  Future<void> showBudgetAlert({
    required int id,
    required String title,
    required String body,
  }) async {
    AppLogger.info('Budget alert: $title — $body', tag: 'Notif');
  }

  @override
  Future<void> showSavingsMilestone({
    required int id,
    required String title,
    required String body,
  }) async {
    AppLogger.info('Savings milestone: $title — $body', tag: 'Notif');
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    AppLogger.info(
      'Daily reminder scheduled for $hour:${minute.toString().padLeft(2, '0')}',
      tag: 'Notif',
    );
  }

  @override
  Future<void> cancelDailyReminder() async {
    AppLogger.info('Daily reminder cancelled', tag: 'Notif');
  }

  @override
  Future<void> cancelAll() async {
    AppLogger.info('All notifications cancelled', tag: 'Notif');
  }
}
