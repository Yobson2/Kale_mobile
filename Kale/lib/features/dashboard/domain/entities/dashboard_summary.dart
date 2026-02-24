import 'package:flutter/foundation.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';

/// Domain entity representing a dashboard summary for a given period.
@immutable
class DashboardSummary {
  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.recentTransactions,
    this.topExpenseCategories = const {},
    this.categoryNames = const {},
    this.categoryColors = const {},
  });

  /// Total income for the selected period.
  final double totalIncome;

  /// Total expenses for the selected period.
  final double totalExpenses;

  /// Most recent transactions (limited to 5).
  final List<Transaction> recentTransactions;

  /// Top expense categories mapped as categoryId -> total amount.
  final Map<String, double> topExpenseCategories;

  /// Category ID to display name lookup map.
  final Map<String, String> categoryNames;

  /// Category ID to hex color string lookup map.
  final Map<String, String> categoryColors;

  /// Net cash flow (income minus expenses).
  double get netCashFlow => totalIncome - totalExpenses;
}
