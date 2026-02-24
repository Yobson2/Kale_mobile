import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Real notification service using [FlutterLocalNotificationsPlugin].
class LocalNotificationService implements NotificationService {
  LocalNotificationService();

  final _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    // Request permissions on Android 13+.
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    AppLogger.info('LocalNotificationService initialized', tag: 'Notif');
  }

  @override
  Future<void> showBudgetAlert({
    required String categoryName,
    required int percentUsed,
    required String budgetAmount,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.budgetAlert,
        NotificationChannels.budgetAlertName,
        channelDescription: NotificationChannels.budgetAlertDesc,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      NotificationIds.budgetAlert + categoryName.hashCode % 999,
      'Budget Alert: $categoryName',
      "You've used $percentUsed% of your $budgetAmount budget for $categoryName.",
      details,
    );
  }

  @override
  Future<void> showSavingsMilestone({
    required String goalName,
    required int milestonePercent,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.savingsMilestone,
        NotificationChannels.savingsMilestoneName,
        channelDescription: NotificationChannels.savingsMilestoneDesc,
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final title = milestonePercent >= 100
        ? 'Goal Complete! $goalName'
        : 'Savings Milestone: $goalName';
    final body = milestonePercent >= 100
        ? 'Congratulations! You\'ve reached your savings goal for "$goalName"!'
        : 'Great progress! "$goalName" is now $milestonePercent% funded.';

    await _plugin.show(
      NotificationIds.savingsMilestone + goalName.hashCode % 999,
      title,
      body,
      details,
    );
  }

  @override
  Future<void> scheduleDailyReminder({int hour = 20, int minute = 0}) async {
    // Cancel existing before rescheduling.
    await cancelDailyReminder();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.dailyReminder,
        NotificationChannels.dailyReminderName,
        channelDescription: NotificationChannels.dailyReminderDesc,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      NotificationIds.dailyReminder,
      'Track Your Spending',
      "Don't forget to log today's transactions!",
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    AppLogger.info(
      'Daily reminder scheduled for $hour:${minute.toString().padLeft(2, '0')}',
      tag: 'Notif',
    );
  }

  @override
  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(NotificationIds.dailyReminder);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
