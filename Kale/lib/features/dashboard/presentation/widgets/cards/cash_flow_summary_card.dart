import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';


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

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusLg,
      child: Container(
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.primaryGradientDark
              : AppColors.primaryGradientLight,
          borderRadius: AppRadius.borderRadiusLg,
        ),
        child: Stack(
          children: [
            // K watermark at 5% opacity
            const GeometricKWatermark(
              opacity: 0.05,
              fontSize: 160,
              alignment: Alignment.topRight,
              offset: Offset(30, -20),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashboardCashFlow,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1.65,
                  ),
                ),
                AppSpacing.verticalSm,
                Text(
                  CurrencyFormatter.format(netValue),
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                AppSpacing.verticalLg,
                Row(
                  children: [
                    Expanded(
                      child: _CashFlowItem(
                        label: context.l10n.dashboardIncome,
                        amount: summary.totalIncome,
                        color: incomeColor,
                        icon: Icons.arrow_downward_rounded,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: _CashFlowItem(
                        label: context.l10n.dashboardExpenses,
                        amount: summary.totalExpenses,
                        color: expenseColor,
                        icon: Icons.arrow_upward_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
              context.l10n.dashboardCouldNotLoad,
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

/// Cash flow item for income/expense within the gradient card.
/// Uses white text instead of theme colors since it sits on a gradient.
class _CashFlowItem extends StatelessWidget {
  const _CashFlowItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          AppSpacing.horizontalSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  CurrencyFormatter.format(amount, compact: true),
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
