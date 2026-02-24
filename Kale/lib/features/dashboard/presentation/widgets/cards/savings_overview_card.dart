// ── Savings Overview Card ─────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';

class SavingsOverviewCard extends ConsumerWidget {
  const SavingsOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsStreamProvider);

    return goalsAsync.when(
      data: (goals) {
        final activeGoals = goals.where((g) => g.status.isActive).toList();
        if (activeGoals.isEmpty) return const SizedBox.shrink();

        final totalSaved =
            activeGoals.fold<double>(0, (s, g) => s + g.currentAmount);
        final totalTarget =
            activeGoals.fold<double>(0, (s, g) => s + g.targetAmount);
        final topGoals = activeGoals.take(3).toList();

        return Container(
          padding: AppSpacing.paddingLg,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Savings Goals',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.goNamed(RouteNames.savingsGoalsName),
                    child: Text(
                      'View all',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalSm,
              Text(
                '${CurrencyFormatter.format(totalSaved, compact: true)}'
                ' saved of '
                '${CurrencyFormatter.format(totalTarget, compact: true)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalMd,
              ...topGoals.map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          goal.name,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSpacing.horizontalSm,
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: AppRadius.borderRadiusFull,
                          child: LinearProgressIndicator(
                            value: goal.progress.clamp(0, 1),
                            minHeight: 8,
                            backgroundColor:
                                Colors.green.withValues(alpha: 0.12),
                            valueColor: AlwaysStoppedAnimation(
                              goal.isFullyFunded
                                  ? Colors.green
                                  : context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.horizontalSm,
                      Text(
                        '${(goal.progress * 100).round()}%',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
