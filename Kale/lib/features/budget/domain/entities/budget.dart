import 'package:flutter/foundation.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';

/// Domain entity representing a user's budget.
///
/// A budget defines a spending plan for a period of calendar days using a
/// chosen strategy (e.g., 50/30/20, envelope) with category allocations
/// that track spending progress. Amounts are integer minor units of the
/// account's base currency.
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
    this.periodStartDay = BudgetPeriodRange.defaultStartDay,
    this.totalIncomeMinor,
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

  /// First day of the budget period (included).
  final CalendarDate startDate;

  /// Last day of the budget period (included).
  final CalendarDate endDate;

  /// The day periods start on (see [BudgetPeriodRange.containing]).
  final int periodStartDay;

  /// Total expected income for this period, in minor units (optional).
  final int? totalIncomeMinor;

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

  /// The days this budget covers.
  BudgetPeriodRange get range => BudgetPeriodRange(startDate, endDate);

  /// Sum of every allocation, in minor units.
  int get totalAllocatedMinor =>
      categories.fold(0, (sum, c) => sum + c.allocatedMinor);

  /// Sum spent across every allocation, in minor units.
  int get totalSpentMinor => categories.fold(0, (sum, c) => sum + c.spentMinor);

  /// What is left to spend, in minor units; negative when overspent.
  int get remainingMinor => totalAllocatedMinor - totalSpentMinor;

  /// [totalIncomeMinor] as [Money] in the base [currency], or null.
  Money? totalIncomeIn(Currency currency) => totalIncomeMinor == null
      ? null
      : Money.fromMinorUnits(totalIncomeMinor!, currency);

  /// [totalAllocatedMinor] as [Money] in the base [currency].
  Money totalAllocatedIn(Currency currency) =>
      Money.fromMinorUnits(totalAllocatedMinor, currency);

  /// [totalSpentMinor] as [Money] in the base [currency].
  Money totalSpentIn(Currency currency) =>
      Money.fromMinorUnits(totalSpentMinor, currency);

  /// [remainingMinor] as [Money] in the base [currency].
  Money remainingIn(Currency currency) =>
      Money.fromMinorUnits(remainingMinor, currency);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Budget && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
