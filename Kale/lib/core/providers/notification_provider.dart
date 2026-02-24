import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/services/local_notification_service.dart';
import 'package:kale/core/services/notification_service.dart';
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
