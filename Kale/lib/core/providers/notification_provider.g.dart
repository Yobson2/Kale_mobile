// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationServiceHash() =>
    r'445de4d12e27916d07943435c5c5a66cb7fc0205';

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
///
/// Copied from [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider = Provider<NotificationService>.internal(
  notificationService,
  name: r'notificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationServiceRef = ProviderRef<NotificationService>;
String _$budgetAlertCheckerHash() =>
    r'0892c2ee1fe7c48523ac92b0bdd061b8f0569ce1';

/// Provides the [BudgetAlertChecker], with text in the app's language.
///
/// Copied from [budgetAlertChecker].
@ProviderFor(budgetAlertChecker)
final budgetAlertCheckerProvider =
    AutoDisposeProvider<BudgetAlertChecker>.internal(
  budgetAlertChecker,
  name: r'budgetAlertCheckerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetAlertCheckerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetAlertCheckerRef = AutoDisposeProviderRef<BudgetAlertChecker>;
String _$savingsMilestoneCheckerHash() =>
    r'9925c517c3984a11e675e24110714c80402ccb3e';

/// Provides the [SavingsMilestoneChecker], with text in the app's
/// language.
///
/// Copied from [savingsMilestoneChecker].
@ProviderFor(savingsMilestoneChecker)
final savingsMilestoneCheckerProvider =
    AutoDisposeProvider<SavingsMilestoneChecker>.internal(
  savingsMilestoneChecker,
  name: r'savingsMilestoneCheckerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savingsMilestoneCheckerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavingsMilestoneCheckerRef
    = AutoDisposeProviderRef<SavingsMilestoneChecker>;
String _$dailyReminderHash() => r'16fb70dfd4d5673f3a4aee34656ca28cb44f79c6';

/// Provides the [DailyReminder], with text in the app's language.
///
/// Copied from [dailyReminder].
@ProviderFor(dailyReminder)
final dailyReminderProvider = AutoDisposeProvider<DailyReminder>.internal(
  dailyReminder,
  name: r'dailyReminderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyReminderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyReminderRef = AutoDisposeProviderRef<DailyReminder>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
