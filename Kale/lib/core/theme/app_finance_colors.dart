import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_colors.dart';

/// Extension on [ColorScheme] providing finance-specific semantic colors
/// that automatically resolve for light/dark themes.
extension AppFinanceColors on ColorScheme {
  /// Income color (green).
  Color get income =>
      brightness == Brightness.dark ? AppColors.incomeDark : AppColors.incomeLight;

  /// Expense color (red).
  Color get expense =>
      brightness == Brightness.dark ? AppColors.expenseDark : AppColors.expenseLight;

  /// Budget color (amber).
  Color get budget =>
      brightness == Brightness.dark ? AppColors.budgetDark : AppColors.budgetLight;

  /// Savings color (blue).
  Color get savings =>
      brightness == Brightness.dark ? AppColors.savingsDark : AppColors.savingsLight;
}
