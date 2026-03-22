import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/extensions/date_time_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
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

/// Detail page for a single savings goal — enhanced with milestones,
/// financial forecast card, and contribution labels.
class SavingsGoalDetailPage extends ConsumerWidget {
  /// Creates a [SavingsGoalDetailPage].
  const SavingsGoalDetailPage({required this.goalId, super.key});

  /// The ID of the savings goal to display.
  final String? goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (goalId == null) {
      return AppScaffold(
        appBar: AppAppBar(title: context.l10n.savingsGoalDetails),
        body: Center(child: Text(context.l10n.savingsGoalNotFound)),
      );
    }

    final goalsAsync = ref.watch(savingsGoalsStreamProvider);

    return goalsAsync.when(
      loading: () => AppScaffold(
        appBar: AppAppBar(title: context.l10n.savingsGoalDetails),
        body: const AppShimmerList(),
      ),
      error: (error, _) => AppScaffold(
        appBar: AppAppBar(title: context.l10n.savingsGoalDetails),
        body: AppErrorState(message: error.toString()),
      ),
      data: (goals) {
        final goal = goals.where((g) => g.id == goalId).firstOrNull;
        if (goal == null) {
          return AppScaffold(
            appBar: AppAppBar(title: context.l10n.savingsGoalDetails),
            body: Center(child: Text(context.l10n.savingsGoalNotFound)),
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
    final isDark = context.isDark;
    final contributionsAsync =
        ref.watch(savingsContributionsStreamProvider(goal.id));

    ref.listen(savingsNotifierProvider, (_, state) {
      if (state is SavingsSuccess) {
        showAppSnackBar(context, message: state.message ?? 'Done');
      } else if (state is SavingsError) {
        showAppSnackBar(
          context,
          message: state.message,
          variant: SnackBarVariant.error,
        );
      }
    });

    final progressPercent = (goal.progress * 100).round();
    final nextMilestone = _getNextMilestone(progressPercent);
    final milestoneAchieved = progressPercent >= 75;
    final incomeColor =
        isDark ? AppColors.incomeDark : AppColors.incomeLight;

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
              PopupMenuItem(
                value: 'delete',
                child: Text(context.l10n.savingsDeleteGoal),
              ),
            ],
          ),
        ],
      ),
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
                    '$progressPercent%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'SAVED',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.65,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.verticalLg,

            // Milestone badge
            if (milestoneAchieved)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderRadiusFull,
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'MILESTONE ACHIEVED',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

            if (nextMilestone != null) ...[
              AppSpacing.verticalSm,
              Text(
                'Next milestone: ${CurrencyFormatter.format(
                  goal.targetAmount * nextMilestone / 100,
                  currencyCode: goal.currencyCode,
                )} ($nextMilestone%)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            AppSpacing.verticalXl,

            // Stats row in cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'SAVED',
                    value: CurrencyFormatter.format(
                      goal.currentAmount,
                      currencyCode: goal.currencyCode,
                    ),
                    color: incomeColor,
                  ),
                ),
                AppSpacing.horizontalSm,
                Expanded(
                  child: _StatCard(
                    label: 'REMAINING',
                    value: CurrencyFormatter.format(
                      goal.remaining,
                      currencyCode: goal.currencyCode,
                    ),
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.horizontalSm,
                Expanded(
                  child: _StatCard(
                    label: 'TARGET',
                    value: CurrencyFormatter.format(
                      goal.targetAmount,
                      currencyCode: goal.currencyCode,
                    ),
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            AppSpacing.verticalXl,

            // Financial Forecast card
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      AppSpacing.horizontalSm,
                      Text(
                        'Financial Forecast',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalMd,
                  _buildForecastText(context, theme),
                ],
              ),
            ),

            AppSpacing.verticalXl,

            // History header with Add Money button
            Row(
              children: [
                Text(
                  'History',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (goal.status.isActive)
                  SizedBox(
                    height: 36,
                    child: AppPrimaryButton(
                      text: 'ADD MONEY',
                      icon: Icons.add,
                      isExpanded: false,
                      height: 36,
                      onPressed: () => _showContributeSheet(context, ref),
                    ),
                  ),
                AppSpacing.horizontalMd,
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'VIEW ALL',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
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
                      context.l10n.savingsNoContributions,
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
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) => _ContributionTile(
                    contribution: contributions[index],
                    labelType: _getLabelType(index),
                    isDark: isDark,
                  ),
                );
              },
            ),
            AppSpacing.verticalXxxl,
          ],
        ),
      ),
    );
  }

  Widget _buildForecastText(BuildContext context, ThemeData theme) {
    final daysSinceCreation =
        DateTime.now().difference(goal.createdAt).inDays.clamp(1, 365);
    final monthsSinceCreation = (daysSinceCreation / 30).clamp(1.0, 12.0);
    final monthlyRate = goal.currentAmount / monthsSinceCreation;

    return Text.rich(
      TextSpan(
        text: 'At your current contribution rate of ',
        children: [
          TextSpan(
            text: '${CurrencyFormatter.format(
              monthlyRate,
              currencyCode: goal.currencyCode,
              compact: true,
            )}/month',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const TextSpan(text: ', you are on track to reach your goal'),
          if (goal.deadline != null) ...[
            const TextSpan(text: ' by '),
            TextSpan(
              text: goal.deadline!.formatted,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
          const TextSpan(text: '!'),
        ],
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  int? _getNextMilestone(int currentPercent) {
    const milestones = [25, 50, 75, 80, 90, 100];
    for (final m in milestones) {
      if (currentPercent < m) return m;
    }
    return null;
  }

  _ContributionLabel _getLabelType(int index) {
    if (index == 0) return _ContributionLabel.up;
    if (index == 1) return _ContributionLabel.milestone;
    return _ContributionLabel.consistent;
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
            AppSpacing.verticalMd,
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: context.l10n.savingsNoteOptional,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
              ),
            ),
            AppSpacing.verticalLg,
            AppPrimaryButton(
              text: context.l10n.savingsAddContribution,
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
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.savingsDeleteGoal),
        content: Text(l10n.savingsDeleteGoalConfirm(goal.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
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
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
  }
}

/// Stat card for the 3-column SAVED / REMAINING / TARGET row.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ContributionLabel { up, milestone, consistent }

/// Contribution tile with colored label badge.
class _ContributionTile extends StatelessWidget {
  const _ContributionTile({
    required this.contribution,
    required this.labelType,
    required this.isDark,
  });

  final SavingsContribution contribution;
  final _ContributionLabel labelType;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final incomeColor =
        isDark ? AppColors.incomeDark : AppColors.incomeLight;

    final labelText = switch (labelType) {
      _ContributionLabel.up => 'UP 2%',
      _ContributionLabel.milestone => 'MILESTONE',
      _ContributionLabel.consistent => 'CONSISTENT',
    };

    final labelColor = switch (labelType) {
      _ContributionLabel.up => incomeColor,
      _ContributionLabel.milestone =>
        isDark ? AppColors.tertiaryDark : AppColors.tertiaryLight,
      _ContributionLabel.consistent => theme.colorScheme.primary,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          // Green circle icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: incomeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: incomeColor,
              size: 20,
            ),
          ),
          AppSpacing.horizontalMd,

          // Title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contribution.note ?? 'Monthly Auto-save',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contribution.date.formatted,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Amount + label
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${CurrencyFormatter.format(contribution.amount)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: incomeColor,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    switch (labelType) {
                      _ContributionLabel.up => Icons.trending_up,
                      _ContributionLabel.milestone => Icons.flag,
                      _ContributionLabel.consistent => Icons.check_circle,
                    },
                    size: 12,
                    color: labelColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    labelText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
