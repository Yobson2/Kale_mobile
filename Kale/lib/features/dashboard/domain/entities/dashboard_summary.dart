import 'package:flutter/foundation.dart';
import 'package:kale/core/money/money.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';

/// Domain entity representing a dashboard summary for a given period.
///
/// Every amount is exact [Money] in the account's base [currency].
@immutable
class DashboardSummary {
  const DashboardSummary({
    required this.currency,
    required this.totalIncome,
    required this.totalExpenses,
    required this.recentTransactions,
    this.topExpenseCategories = const {},
    this.categoryNames = const {},
    this.categoryColors = const {},
  });

  /// The account's base currency, which every amount here is in.
  final Currency currency;

  /// Total income for the selected period.
  final Money totalIncome;

  /// Total expenses for the selected period.
  final Money totalExpenses;

  /// Most recent transactions (limited to 5).
  final List<Transaction> recentTransactions;

  /// Expense totals per category, keyed by category ID.
  final Map<String, Money> topExpenseCategories;

  /// Category ID to display name lookup map.
  final Map<String, String> categoryNames;

  /// Category ID to hex color string lookup map.
  final Map<String, String> categoryColors;

  /// Net cash flow (income minus expenses).
  Money get netCashFlow => totalIncome - totalExpenses;
}
