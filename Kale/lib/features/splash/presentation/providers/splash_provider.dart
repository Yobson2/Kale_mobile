import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

/// Where the app goes once the splash is done.
enum SplashResult {
  /// First launch: show onboarding.
  onboarding,

  /// Go to the home shell. The router sends an unauthenticated user on to
  /// login.
  home,
}

/// Runs initialization checks: notifications, first launch.
///
/// This provider is a pure reader: it never modifies other providers.
/// The session (restored, or a new anonymous one) is started by
/// `SplashPage` through the auth notifier.
@riverpod
Future<SplashResult> splashInit(Ref ref) async {
  // Run init checks and a minimum 3-second delay in parallel so the
  // splash is always visible for at least 3 seconds.
  final (result, _) = await (
    _resolve(ref),
    Future<void>.delayed(const Duration(seconds: 3)),
  ).wait;

  return result;
}

Future<SplashResult> _resolve(Ref ref) async {
  try {
    final localStorage = ref.read(localStorageProvider);

    // Initialize notification service.
    final notifService = ref.read(notificationServiceProvider);
    await notifService.init();

    // The opt-in daily reminder: rescheduled in the current language and
    // time zone if it is on, cancelled otherwise.
    await ref.read(dailyReminderProvider).restore();

    return localStorage.isFirstLaunch
        ? SplashResult.onboarding
        : SplashResult.home;
  } catch (e, st) {
    AppLogger.error(
      'Splash initialization failed',
      tag: 'SplashInit',
      error: e,
      stackTrace: st,
    );
    return SplashResult.home;
  }
}
