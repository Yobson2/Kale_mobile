import 'package:kale/core/utils/logger.dart';

/// Notification channel identifiers.
abstract final class NotificationChannels {
  static const String budgetAlert = 'budget_alert';
  static const String budgetAlertName = 'Budget Alerts';
  static const String budgetAlertDesc =
      'Alerts when spending approaches budget limits';

  static const String dailyReminder = 'daily_reminder';
  static const String dailyReminderName = 'Daily Reminders';
  static const String dailyReminderDesc =
      'Reminders to log daily transactions';

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

  /// Show a budget alert notification.
  Future<void> showBudgetAlert({
    required String categoryName,
    required int percentUsed,
    required String budgetAmount,
  });

  /// Show a savings milestone notification.
  Future<void> showSavingsMilestone({
    required String goalName,
    required int milestonePercent,
  });

  /// Schedule a daily reminder notification at the given [hour] and [minute].
  Future<void> scheduleDailyReminder({int hour = 20, int minute = 0});

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
    required String categoryName,
    required int percentUsed,
    required String budgetAmount,
  }) async {
    AppLogger.info(
      'Budget alert: $categoryName at $percentUsed% of $budgetAmount',
      tag: 'Notif',
    );
  }

  @override
  Future<void> showSavingsMilestone({
    required String goalName,
    required int milestonePercent,
  }) async {
    AppLogger.info(
      'Savings milestone: $goalName reached $milestonePercent%',
      tag: 'Notif',
    );
  }

  @override
  Future<void> scheduleDailyReminder({int hour = 20, int minute = 0}) async {
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
