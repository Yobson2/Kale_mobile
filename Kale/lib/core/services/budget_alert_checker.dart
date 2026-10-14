import 'package:kale/core/money/currency.dart';
import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/storage/local_storage.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/l10n/app_localizations.dart';

/// Alerts when a budget category reaches 80% and 100% of its allocation
/// (decision Q22): at most once per threshold per budget period.
///
/// Each period is its own budget (renewing creates a new one), so a
/// threshold already alerted for this budget never alerts again, and the
/// next period alerts afresh. Which alerts were shown is kept on the
/// device ([LocalStorage.wasNotified]) and cleared on logout.
class BudgetAlertChecker {
  /// Creates a [BudgetAlertChecker].
  const BudgetAlertChecker({
    required NotificationService notificationService,
    required LocalStorage localStorage,
    required AppLocalizations strings,
  })  : _notifications = notificationService,
        _storage = localStorage,
        _strings = strings;

  /// The fixed thresholds, in percent of the allocation.
  static const thresholds = [80, 100];

  final NotificationService _notifications;
  final LocalStorage _storage;
  final AppLocalizations _strings;

  /// Alerts if [categoryId] in [budget] crossed a threshold not alerted
  /// for yet. Call after a transaction is saved. When several thresholds
  /// are crossed at once, only the highest is shown; all are recorded.
  Future<void> checkAndAlert({
    required Budget budget,
    required String categoryId,
    required Currency currency,
    String? categoryName,
  }) async {
    if (!_storage.isNotificationsEnabled) return;

    final allocation =
        budget.categories.where((c) => c.categoryId == categoryId).firstOrNull;
    if (allocation == null || allocation.allocatedMinor <= 0) return;

    // Integer comparison: spent / allocated >= threshold / 100.
    final crossed = [
      for (final threshold in thresholds)
        if (allocation.spentMinor * 100 >=
            allocation.allocatedMinor * threshold)
          threshold,
    ];
    final fresh = [
      for (final threshold in crossed)
        if (!_storage.wasNotified(_key(budget.id, categoryId, threshold)))
          threshold,
    ];
    if (fresh.isEmpty) return;

    for (final threshold in fresh) {
      await _storage.markNotified(_key(budget.id, categoryId, threshold));
    }

    final highest = fresh.last;
    final name = categoryName ?? categoryId;
    final amount =
        allocation.allocatedIn(currency).format(locale: _strings.localeName);
    AppLogger.info('Budget alert: $name at $highest%', tag: 'BudgetAlert');
    await _notifications.showBudgetAlert(
      id: categoryId.hashCode.abs() % 999,
      title: _strings.notifBudgetAlertTitle(name),
      body: highest >= 100
          ? _strings.notifBudgetAlert100Body(amount, name)
          : _strings.notifBudgetAlert80Body(amount, name),
    );
  }

  static String _key(String budgetId, String categoryId, int threshold) =>
      'budget_${budgetId}_${categoryId}_$threshold';
}
