import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/savings/presentation/widgets/savings_progress_ring.dart';

class FinancialHealthCard extends ConsumerWidget {
  const FinancialHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: summaryAsync.when(
        loading: () => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (summary) {
          final income = summary.totalIncome;
          final expenses = summary.totalExpenses;
          final score = _calculateScore(income, expenses);
          final progress = score / 100;
          final label = _getLabel(context, score);
          final color = _getColor(score);

          return Column(
            children: [
              Text(
                context.l10n.dashboardFinancialHealth,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.verticalMd,
              SavingsProgressRing(
                progress: progress,
                size: 72,
                progressColor: color,
                child: Text(
                  '$score',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
              AppSpacing.verticalSm,
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _calculateScore(double income, double expenses) {
    if (income <= 0 && expenses <= 0) return 0;

    var score = 0;

    // Has financial activity
    if (income > 0 || expenses > 0) score += 25;

    // Income covers expenses
    if (income >= expenses) score += 50;

    // Spending under 80% of income
    if (income > 0 && expenses < income * 0.8) score += 25;

    return score.clamp(0, 100);
  }

  String _getLabel(BuildContext context, int score) {
    if (score >= 75) return context.l10n.dashboardHealthExcellent;
    if (score >= 50) return context.l10n.dashboardHealthGood;
    if (score >= 25) return context.l10n.dashboardHealthFair;
    return context.l10n.dashboardHealthNeedsWork;
  }

  Color _getColor(int score) {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.blue;
    if (score >= 25) return Colors.orange;
    return Colors.red;
  }
}
