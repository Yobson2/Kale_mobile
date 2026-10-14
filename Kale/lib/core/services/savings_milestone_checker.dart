import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/storage/local_storage.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/l10n/app_localizations.dart';

/// Celebrates a savings goal reaching 25, 50, 75 and 100% of its target
/// (decision Q22): each milestone once per goal. Which ones were shown is
/// kept on the device ([LocalStorage.wasNotified]) and cleared on logout.
class SavingsMilestoneChecker {
  /// Creates a [SavingsMilestoneChecker].
  const SavingsMilestoneChecker({
    required NotificationService notificationService,
    required LocalStorage localStorage,
    required AppLocalizations strings,
  })  : _notifications = notificationService,
        _storage = localStorage,
        _strings = strings;

  /// The milestones, in percent of the target.
  static const milestones = [25, 50, 75, 100];

  final NotificationService _notifications;
  final LocalStorage _storage;
  final AppLocalizations _strings;

  /// Notifies if [goal] reached a milestone not shown yet. Call after a
  /// contribution. When several are reached at once, only the highest is
  /// shown; all are recorded.
  Future<void> check(SavingsGoal goal) async {
    if (!_storage.isNotificationsEnabled || goal.targetAmountMinor <= 0) {
      return;
    }
    final fresh = [
      for (final milestone in milestones)
        if (goal.currentAmountMinor * 100 >=
                goal.targetAmountMinor * milestone &&
            !_storage.wasNotified(_key(goal.id, milestone)))
          milestone,
    ];
    if (fresh.isEmpty) return;

    for (final milestone in fresh) {
      await _storage.markNotified(_key(goal.id, milestone));
    }

    final highest = fresh.last;
    await _notifications.showSavingsMilestone(
      id: goal.id.hashCode.abs() % 999,
      title: highest >= 100
          ? _strings.notifSavingsGoalReachedTitle(goal.name)
          : _strings.notifSavingsMilestoneTitle(goal.name),
      body: highest >= 100
          ? _strings.notifSavingsGoalReachedBody(goal.name)
          : _strings.notifSavingsMilestoneBody(goal.name, highest),
    );
  }

  static String _key(String goalId, int milestone) =>
      'savings_${goalId}_$milestone';
}
