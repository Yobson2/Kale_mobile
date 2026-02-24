import 'package:kale/core/services/notification_service.dart';
import 'package:kale/core/storage/local_storage.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';

/// Checks budget utilization after a transaction and fires alerts.
class BudgetAlertChecker {
  const BudgetAlertChecker({
    required NotificationService notificationService,
    required LocalStorage localStorage,
  })  : _notifications = notificationService,
        _storage = localStorage;

  final NotificationService _notifications;
  final LocalStorage _storage;

  /// Checks if [categoryId] in the given [budget] has exceeded the alert
  /// threshold. Should be called after creating or updating a transaction.
  Future<void> checkAndAlert({
    required Budget budget,
    required String categoryId,
    String? categoryName,
  }) async {
    if (!_storage.isNotificationsEnabled) return;

    final threshold = _storage.budgetAlertThreshold;
    final allocation = budget.categories
        .where((c) => c.categoryId == categoryId)
        .firstOrNull;

    if (allocation == null || allocation.allocatedAmount <= 0) return;

    final utilization = allocation.spentAmount / allocation.allocatedAmount;
    if (utilization < threshold) return;

    final percentUsed = (utilization * 100).round();
    final displayName = categoryName ?? allocation.categoryId;
    final budgetAmount = CurrencyFormatter.format(allocation.allocatedAmount);

    AppLogger.info(
      'Budget alert: $displayName at $percentUsed% (threshold: '
      '${(threshold * 100).round()}%)',
      tag: 'BudgetAlert',
    );

    await _notifications.showBudgetAlert(
      categoryName: displayName,
      percentUsed: percentUsed,
      budgetAmount: budgetAmount,
    );
  }
}
