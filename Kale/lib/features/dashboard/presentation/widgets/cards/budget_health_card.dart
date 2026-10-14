// ── Budget Health Card ────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';

class BudgetHealthCard extends ConsumerWidget {
  const BudgetHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(activeBudgetProvider);

    return budgetAsync.when(
      data: (budget) {
        if (budget == null || budget.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        final currency = ref.watch(baseCurrencyProvider);
        final totalAllocated = budget.totalAllocatedIn(currency);
        final totalSpent = budget.totalSpentIn(currency);

        if (totalAllocated.isZero) return const SizedBox.shrink();

        final utilization = totalSpent.minorUnits / totalAllocated.minorUnits;
        final percent = (utilization * 100).round().clamp(0, 999);
        final color = percent < 70
            ? Colors.green
            : percent < 90
                ? Colors.orange
                : Colors.red;

        return Container(
          padding: AppSpacing.paddingLg,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.borderRadiusLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      context.l10n.dashboardBudgetHealth,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/budget'),
                    child: Text(
                      context.l10n.dashboardViewBudget,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalSm,
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          value: utilization.clamp(0, 1),
                          strokeWidth: 6,
                          backgroundColor: color.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.horizontalLg,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          percent < 70
                              ? context.l10n.dashboardOnTrack
                              : percent < 90
                                  ? context.l10n.dashboardGettingClose
                                  : context.l10n.dashboardOverBudget,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${context.formatMoney(totalSpent)}'
                          ' of '
                          '${context.formatMoney(totalAllocated)}'
                          '${context.l10n.dashboardSpent}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
