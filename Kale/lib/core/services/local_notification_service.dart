import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Real notification service using [FlutterLocalNotificationsPlugin].
///
/// Local notifications only (decision Q22): nothing is pushed from a
/// server. Callers pass text already in the app's language.
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
    required int id,
    required String title,
    required String body,
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
    await _plugin.show(NotificationIds.budgetAlert + id, title, body, details);
  }

  @override
  Future<void> showSavingsMilestone({
    required int id,
    required String title,
    required String body,
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
    await _plugin.show(
      NotificationIds.savingsMilestone + id,
      title,
      body,
      details,
    );
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
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
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // Repeats every day at the same time.
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
