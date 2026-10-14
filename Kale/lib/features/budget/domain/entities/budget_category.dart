import 'package:flutter/foundation.dart';
import 'package:kale/core/money/money.dart';

/// Domain entity representing a budget category allocation.
///
/// Each allocation ties a spending category to a budget with a fixed amount
/// and/or percentage, and tracks how much has been spent against it.
/// Amounts are integer minor units of the account's base currency.
@immutable
class BudgetCategoryAllocation {
  const BudgetCategoryAllocation({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.groupName,
    required this.allocatedMinor,
    required this.spentMinor,
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

  /// Amount allocated to this category, in minor units.
  final int allocatedMinor;

  /// Percentage of income allocated (nullable, used when percentage-based).
  final double? allocatedPercentage;

  /// Amount spent in this category during the budget's period, in minor
  /// units (computed from transactions).
  final int spentMinor;

  /// When this allocation was created.
  final DateTime createdAt;

  /// What is left to spend, in minor units; negative when overspent.
  int get remainingMinor => allocatedMinor - spentMinor;

  /// [allocatedMinor] as [Money] in the account's base [currency].
  Money allocatedIn(Currency currency) =>
      Money.fromMinorUnits(allocatedMinor, currency);

  /// [spentMinor] as [Money] in the account's base [currency].
  Money spentIn(Currency currency) =>
      Money.fromMinorUnits(spentMinor, currency);

  /// [remainingMinor] as [Money] in the account's base [currency].
  Money remainingIn(Currency currency) =>
      Money.fromMinorUnits(remainingMinor, currency);

  /// The share of the allocation already spent (1.0 = all of it); 0 when
  /// nothing is allocated. For display and thresholds only, never stored.
  double get utilization =>
      allocatedMinor <= 0 ? 0 : spentMinor / allocatedMinor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetCategoryAllocation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
