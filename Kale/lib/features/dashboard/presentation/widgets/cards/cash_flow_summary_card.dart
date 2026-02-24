import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/dashboard/presentation/widgets/items/summary_item.dart';

class CashFlowSummaryCard extends ConsumerWidget {
  const CashFlowSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return summaryAsync.when(
      data: (summary) => _buildCard(context, summary),
      loading: () => _buildLoadingCard(context),
      error: (error, _) => _buildErrorCard(context, error.toString()),
    );
  }

  Widget _buildCard(BuildContext context, DashboardSummary summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final incomeColor = isDark ? AppColors.incomeDark : AppColors.incomeLight;
    final expenseColor =
        isDark ? AppColors.expenseDark : AppColors.expenseLight;
    final netValue = summary.netCashFlow;
    final netColor = netValue >= 0 ? incomeColor : expenseColor;

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primaryContainerDark,
                  AppColors.surfaceDark,
                ]
              : [
                  AppColors.primaryContainerLight,
                  AppColors.surfaceLight,
                ],
        ),
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cash Flow',
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            CurrencyFormatter.format(netValue),
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: netColor,
            ),
          ),
          AppSpacing.verticalLg,
          Row(
            children: [
              Expanded(
                child: SummaryItem(
                  label: 'Income',
                  amount: summary.totalIncome,
                  color: incomeColor,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.3,
                ),
              ),
              Expanded(
                child: SummaryItem(
                  label: 'Expenses',
                  amount: summary.totalExpenses,
                  color: expenseColor,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      height: 180,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colorScheme.error),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              'Could not load summary',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
