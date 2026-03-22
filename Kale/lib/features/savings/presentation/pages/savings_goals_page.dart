import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/animations/staggered_list_item.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/core/widgets/states/app_error_state.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/presentation/providers/savings_notifier.dart';
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
        title: context.l10n.savingsGoalsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: context.l10n.savingsAddGoal,
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
            return const _SavingsEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(savingsGoalsStreamProvider);
            },
            child: ListView.separated(
              padding: AppSpacing.paddingLg,
              itemCount: goals.length,
              separatorBuilder: (_, __) => AppSpacing.verticalMd,
              itemBuilder: (context, index) => StaggeredListItem(
                index: index,
                child: _GoalCard(
                  goal: goals[index],
                  onTap: () => context.pushNamed(
                    RouteNames.savingsGoalDetailName,
                    extra: goals[index].id,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Card displaying a single savings goal with progress and quick-add action.
class _GoalCard extends ConsumerWidget {
  const _GoalCard({
    required this.goal,
    required this.onTap,
  });

  final SavingsGoal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    if (goal.status.isActive) ...[
                      AppSpacing.verticalSm,
                      SizedBox(
                        height: 32,
                        child: FilledButton.tonal(
                          onPressed: () =>
                              _showContributeSheet(context, ref),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            textStyle: theme.textTheme.labelSmall,
                          ),
                          child: Text(context.l10n.savingsAddMoney),
                        ),
                      ),
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

  void _showContributeSheet(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.savingsAddMoneyTo(goal.name),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.verticalLg,
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              decoration: InputDecoration(
                labelText: context.l10n.transactionsAmount,
                prefixText: '${goal.currencyCode} ',
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
              ),
              autofocus: true,
            ),
            AppSpacing.verticalLg,
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0) return;
                ref.read(savingsNotifierProvider.notifier).contribute(
                      goalId: goal.id,
                      amount: amount,
                    );
                Navigator.pop(context);
              },
              child: Text(context.l10n.savingsAddContribution),
            ),
            AppSpacing.verticalMd,
          ],
        ),
      ),
    );
  }
}

/// Custom empty state for the savings goals page with template chips.
class _SavingsEmptyState extends StatelessWidget {
  const _SavingsEmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 80,
              color: colorScheme.outline,
            ),
            AppSpacing.verticalXl,
            Text(
              context.l10n.savingsNoGoals,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.verticalSm,
            Text(
              context.l10n.savingsNoGoalsSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalXl,
            Text(
              context.l10n.savingsEmptyTemplateTitle,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.verticalMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.shield_outlined),
                  label: Text(context.l10n.savingsTemplateEmergency),
                  onPressed: () =>
                      context.pushNamed(RouteNames.addSavingsGoalName),
                  shape: const StadiumBorder(),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                ActionChip(
                  avatar: const Icon(Icons.flight_outlined),
                  label: Text(context.l10n.savingsTemplateVacation),
                  onPressed: () =>
                      context.pushNamed(RouteNames.addSavingsGoalName),
                  shape: const StadiumBorder(),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                ActionChip(
                  avatar: const Icon(Icons.phone_iphone_outlined),
                  label: Text(context.l10n.savingsTemplateNewPhone),
                  onPressed: () =>
                      context.pushNamed(RouteNames.addSavingsGoalName),
                  shape: const StadiumBorder(),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
              ],
            ),
            AppSpacing.verticalLg,
            Text(
              context.l10n.savingsEmptyOrCreate,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalSm,
            FilledButton(
              onPressed: () =>
                  context.pushNamed(RouteNames.addSavingsGoalName),
              child: Text(context.l10n.savingsCreateGoal),
            ),
          ],
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
