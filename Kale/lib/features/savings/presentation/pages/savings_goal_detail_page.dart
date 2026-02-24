import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/extensions/date_time_extensions.dart';
import 'package:kale/core/mascot/mascot_celebration_overlay.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/core/widgets/states/app_error_state.dart';
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_goal.dart';
import 'package:kale/features/savings/presentation/providers/savings_notifier.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';
import 'package:kale/features/savings/presentation/providers/savings_state.dart';
import 'package:kale/features/savings/presentation/widgets/savings_progress_ring.dart';

/// Detail page for a single savings goal.
class SavingsGoalDetailPage extends ConsumerWidget {
  /// Creates a [SavingsGoalDetailPage].
  const SavingsGoalDetailPage({required this.goalId, super.key});

  /// The ID of the savings goal to display.
  final String? goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (goalId == null) {
      return const AppScaffold(
        appBar: AppAppBar(title: 'Goal Details'),
        body: Center(child: Text('Goal not found')),
      );
    }

    final goalsAsync = ref.watch(savingsGoalsStreamProvider);

    return goalsAsync.when(
      loading: () => const AppScaffold(
        appBar: AppAppBar(title: 'Goal Details'),
        body: AppShimmerList(),
      ),
      error: (error, _) => AppScaffold(
        appBar: const AppAppBar(title: 'Goal Details'),
        body: AppErrorState(message: error.toString()),
      ),
      data: (goals) {
        final goal = goals.where((g) => g.id == goalId).firstOrNull;
        if (goal == null) {
          return const AppScaffold(
            appBar: AppAppBar(title: 'Goal Details'),
            body: Center(child: Text('Goal not found')),
          );
        }
        return _GoalDetailContent(goal: goal);
      },
    );
  }
}

class _GoalDetailContent extends ConsumerWidget {
  const _GoalDetailContent({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final contributionsAsync =
        ref.watch(savingsContributionsStreamProvider(goal.id));

    ref.listen(savingsNotifierProvider, (_, state) {
      if (state is SavingsSuccess) {
        showAppSnackBar(context, message: state.message ?? 'Done');
        // Celebrate when a savings goal is fully funded.
        if (goal.isFullyFunded) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              MascotCelebrationOverlay.show(
                context,
                title: 'Goal Achieved!',
                subtitle: 'You fully funded "${goal.name}"!',
              );
            }
          });
        }
      } else if (state is SavingsError) {
        showAppSnackBar(
          context,
          message: state.message,
          variant: SnackBarVariant.error,
        );
      }
    });

    return AppScaffold(
      appBar: AppAppBar(
        title: goal.name,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Goal'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: goal.status.isActive
          ? FloatingActionButton.extended(
              heroTag: 'savings_detail_fab',
              onPressed: () => _showContributeSheet(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Money'),
            )
          : null,
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          children: [
            AppSpacing.verticalLg,

            // Progress ring
            SavingsProgressRing(
              progress: goal.progress,
              size: 160,
              strokeWidth: 12,
              progressColor:
                  goal.isFullyFunded ? Colors.green : theme.colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(goal.progress * 100).round()}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'saved',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.verticalXl,

            // Amounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AmountColumn(
                  label: 'Saved',
                  amount: CurrencyFormatter.format(
                    goal.currentAmount,
                    currencyCode: goal.currencyCode,
                  ),
                  color: Colors.green,
                ),
                _AmountColumn(
                  label: 'Remaining',
                  amount: CurrencyFormatter.format(
                    goal.remaining,
                    currencyCode: goal.currencyCode,
                  ),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                _AmountColumn(
                  label: 'Target',
                  amount: CurrencyFormatter.format(
                    goal.targetAmount,
                    currencyCode: goal.currencyCode,
                  ),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),

            if (goal.deadline != null) ...[
              AppSpacing.verticalLg,
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Deadline'),
                  subtitle: Text(goal.deadline!.formatted),
                  trailing: Text(
                    '${goal.deadline!.difference(DateTime.now()).inDays}d left',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ],

            if (goal.description != null && goal.description!.isNotEmpty) ...[
              AppSpacing.verticalMd,
              Card(
                child: ListTile(
                  leading: const Icon(Icons.notes_outlined),
                  title: Text(goal.description!),
                ),
              ),
            ],

            AppSpacing.verticalXl,

            // Contribution history
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contribution History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppSpacing.verticalMd,

            contributionsAsync.when(
              loading: () => const AppShimmerList(itemCount: 3),
              error: (error, _) => AppErrorState(message: error.toString()),
              data: (contributions) {
                if (contributions.isEmpty) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Text(
                      'No contributions yet. Tap "Add Money" to start!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contributions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) =>
                      _ContributionTile(contribution: contributions[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContributeSheet(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

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
              'Add Money to "${goal.name}"',
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
                labelText: 'Amount',
                prefixText: '${goal.currencyCode} ',
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
              ),
              autofocus: true,
            ),
            AppSpacing.verticalMd,
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
              ),
            ),
            AppSpacing.verticalLg,
            AppPrimaryButton(
              text: 'Add Contribution',
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0) return;

                ref.read(savingsNotifierProvider.notifier).contribute(
                      goalId: goal.id,
                      amount: amount,
                      note: noteController.text.trim().isNotEmpty
                          ? noteController.text.trim()
                          : null,
                    );
                Navigator.pop(context);
              },
            ),
            AppSpacing.verticalMd,
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Delete "${goal.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(savingsNotifierProvider.notifier).deleteGoal(goal.id);
              Navigator.pop(context); // Dismiss dialog.
              context.pop(); // Go back.
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ContributionTile extends StatelessWidget {
  const _ContributionTile({required this.contribution});

  final SavingsContribution contribution;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.12),
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
      ),
      title: Text(
        '+${CurrencyFormatter.format(contribution.amount)}',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
      subtitle: Text(
        contribution.note ?? contribution.date.formatted,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Text(
        contribution.date.timeAgo,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}
