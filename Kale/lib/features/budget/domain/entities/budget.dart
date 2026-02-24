import 'package:flutter/foundation.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';

/// Domain entity representing a user's budget.
///
/// A budget defines a spending plan for a specific period
/// using a chosen strategy (e.g., 50/30/20, envelope) with
/// category allocations that track spending progress.
@immutable
class Budget {
  const Budget({
    required this.id,
    required this.name,
    required this.strategy,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
    this.totalIncome,
    this.isPercentageBased = true,
    this.isSynced = true,
  });

  /// Client-generated UUID.
  final String id;

  /// Budget name (e.g., "February 2026 Budget").
  final String name;

  /// Strategy used for this budget.
  final BudgetStrategy strategy;

  /// Period type for this budget.
  final BudgetPeriod period;

  /// Start date of the budget period.
  final DateTime startDate;

  /// End date of the budget period.
  final DateTime endDate;

  /// Total expected income for this period (optional).
  final double? totalIncome;

  /// Whether allocations are percentage-based (for irregular income).
  final bool isPercentageBased;

  /// Category allocations within this budget.
  final List<BudgetCategoryAllocation> categories;

  /// When the budget was created.
  final DateTime createdAt;

  /// When the budget was last updated.
  final DateTime updatedAt;

  /// Whether this record has been synced to the server.
  final bool isSynced;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Budget &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
