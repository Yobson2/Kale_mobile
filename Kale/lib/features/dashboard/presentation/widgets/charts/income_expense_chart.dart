// ── Income vs Expense Bar Chart ─────────────────────────────────

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';

class IncomeExpenseChart extends ConsumerWidget {
  const IncomeExpenseChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return summaryAsync.when(
      data: (summary) => _buildChart(context, summary),
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildChart(BuildContext context, DashboardSummary summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final incomeColor = isDark ? AppColors.incomeDark : AppColors.incomeLight;
    final expenseColor =
        isDark ? AppColors.expenseDark : AppColors.expenseLight;
    final income = summary.totalIncome;
    final expenses = summary.totalExpenses;
    final maxY = (income > expenses ? income : expenses) * 1.2;

    if (income == 0 && expenses == 0) {
      return _buildEmptyChartState(context);
    }

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Income vs Expenses',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalLg,
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY == 0 ? 100 : maxY,
                alignment: BarChartAlignment.spaceEvenly,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = groupIndex == 0 ? 'Income' : 'Expenses';
                      return BarTooltipItem(
                        '$label\n',
                        context.textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: CurrencyFormatter.format(
                              rod.toY,
                              compact: true,
                            ),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            CurrencyFormatter.format(
                              value,
                              compact: true,
                              showSymbol: false,
                            ),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final label =
                            value.toInt() == 0 ? 'Income' : 'Expenses';
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            label,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY == 0 ? 25 : maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.colorScheme.outlineVariant.withValues(
                      alpha: 0.3,
                    ),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: income,
                        color: incomeColor,
                        width: 40,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.sm),
                          topRight: Radius.circular(AppRadius.sm),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: expenses,
                        color: expenseColor,
                        width: 40,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.sm),
                          topRight: Radius.circular(AppRadius.sm),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChartState(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingXl,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Column(
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 48,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppSpacing.verticalSm,
          Text(
            'No transaction data yet',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            'Add your first transaction to see the chart',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
