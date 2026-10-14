import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/l10n/app_locale.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/budget_alert_checker.dart';
import 'package:kale/core/services/daily_reminder.dart';
import 'package:kale/core/services/local_notification_service.dart';
import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/services/savings_milestone_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

/// Provides the [NotificationService] instance.
///
/// Override this provider to swap implementations:
/// ```dart
/// ProviderScope(
///   overrides: [
///     notificationServiceProvider.overrideWithValue(DevNotificationService()),
///   ],
///   child: const App(),
/// )
/// ```
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return LocalNotificationService();
}

/// Provides the [BudgetAlertChecker], with text in the app's language.
@riverpod
BudgetAlertChecker budgetAlertChecker(Ref ref) => BudgetAlertChecker(
      notificationService: ref.watch(notificationServiceProvider),
      localStorage: ref.watch(localStorageProvider),
      strings: ref.watch(appStringsProvider),
    );

/// Provides the [SavingsMilestoneChecker], with text in the app's
/// language.
@riverpod
SavingsMilestoneChecker savingsMilestoneChecker(Ref ref) =>
    SavingsMilestoneChecker(
      notificationService: ref.watch(notificationServiceProvider),
      localStorage: ref.watch(localStorageProvider),
      strings: ref.watch(appStringsProvider),
    );

/// Provides the [DailyReminder], with text in the app's language.
@riverpod
DailyReminder dailyReminder(Ref ref) => DailyReminder(
      notificationService: ref.watch(notificationServiceProvider),
      localStorage: ref.watch(localStorageProvider),
      strings: ref.watch(appStringsProvider),
    );
