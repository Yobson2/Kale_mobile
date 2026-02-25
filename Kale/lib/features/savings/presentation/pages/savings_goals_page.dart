import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/core/widgets/states/app_empty_state.dart';
import 'package:kale/core/widgets/states/app_error_state.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';
import 'package:kale/features/savings/presentation/widgets/savings_progress_ring.dart';

/// Page listing all savings goals with progress rings.
class SavingsGoalsPage extends ConsumerWidget {
  /// Creates a [SavingsGoalsPage].
  const SavingsGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsStreamProvider);

    return AppScaffold(
      appBar: AppAppBar(
        title: 'Savings Goals',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add goal',
            onPressed: () =>
                context.pushNamed(RouteNames.addSavingsGoalName),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const AppShimmerList(),
        error: (error, _) => AppErrorState(message: error.toString()),
        data: (goals) {
          if (goals.isEmpty) {
            return AppEmptyState(
              title: 'No savings goals yet',
              subtitle: 'What are you saving for? Set a goal to start tracking.',
              actionText: 'Create Goal',
              onAction: () =>
                  context.pushNamed(RouteNames.addSavingsGoalName),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(savingsGoalsStreamProvider);
            },
            child: ListView.separated(
              padding: AppSpacing.paddingLg,
              itemCount: goals.length,
              separatorBuilder: (_, __) => AppSpacing.verticalMd,
              itemBuilder: (context, index) => _GoalCard(
                goal: goals[index],
                onTap: () => context.pushNamed(
                  RouteNames.savingsGoalDetailName,
                  extra: goals[index].id,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Card displaying a single savings goal with progress.
class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.onTap,
  });

  final SavingsGoal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progressPercent = (goal.progress * 100).round();

    final progressColor = goal.isFullyFunded
        ? Colors.green
        : goal.progress > 0.5
            ? theme.colorScheme.primary
            : Colors.orange;

    return Card(
      elevation: isDark ? 0 : 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              SavingsProgressRing(
                progress: goal.progress,
                size: 64,
                progressColor: progressColor,
                child: Text(
                  '$progressPercent%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppSpacing.horizontalLg,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.verticalXs,
                    Text(
                      '${CurrencyFormatter.format(goal.currentAmount, currencyCode: goal.currencyCode)}'
                      ' / ${CurrencyFormatter.format(goal.targetAmount, currencyCode: goal.currencyCode)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (goal.deadline != null) ...[
                      AppSpacing.verticalXs,
                      _DeadlineChip(deadline: goal.deadline!),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small chip showing days remaining to deadline.
class _DeadlineChip extends StatelessWidget {
  const _DeadlineChip({required this.deadline});

  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOverdue ? Icons.warning_amber : Icons.schedule,
          size: 14,
          color: isOverdue ? Colors.red : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          isOverdue ? '${-daysLeft}d overdue' : '${daysLeft}d left',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isOverdue ? Colors.red : Colors.grey,
              ),
        ),
      ],
    );
  }
}
