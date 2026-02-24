import 'package:flutter/foundation.dart';

/// Domain entity representing a budget category allocation.
///
/// Each allocation ties a spending category to a budget with
/// a fixed amount and/or percentage, and tracks how much has
/// been spent against it.
@immutable
class BudgetCategoryAllocation {
  const BudgetCategoryAllocation({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.groupName,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.createdAt,
    this.allocatedPercentage,
  });

  /// Unique identifier.
  final String id;

  /// FK to the parent budget.
  final String budgetId;

  /// FK to the transaction category.
  final String categoryId;

  /// Group name (e.g., "Needs", "Wants", "Savings").
  final String groupName;

  /// Fixed amount allocated to this category.
  final double allocatedAmount;

  /// Percentage of income allocated (nullable, used when percentage-based).
  final double? allocatedPercentage;

  /// Amount already spent in this category (computed from transactions).
  final double spentAmount;

  /// When this allocation was created.
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetCategoryAllocation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
