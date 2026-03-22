import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/animations/staggered_list_item.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.savingsGoalsTitle,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: context.l10n.savingsAddGoal,
            onPressed: () =>
                context.pushNamed(RouteNames.addSavingsGoalName),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
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

          final totalSaved = goals.fold<double>(
            0,
            (sum, g) => sum + g.currentAmount,
          );

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(savingsGoalsStreamProvider);
            },
            child: ListView(
              padding: AppSpacing.paddingLg,
              children: [
                // Gradient total saved card
                _TotalSavedCard(
                  totalSaved: totalSaved,
                  isDark: isDark,
                  currencyCode: goals.first.currencyCode,
                ),
                AppSpacing.verticalLg,

                // Active goals section
                Text(
                  'ACTIVE GOALS',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.65,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalMd,

                ...List.generate(goals.length, (index) {
                  return StaggeredListItem(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _GoalCard(
                        goal: goals[index],
                        onTap: () => context.pushNamed(
                          RouteNames.savingsGoalDetailName,
                          extra: goals[index].id,
                        ),
                      ),
                    ),
                  );
                }),

                AppSpacing.verticalLg,

                // Quick Start grid
                Text(
                  'QUICK START',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.65,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalMd,
                _QuickStartGrid(),
                AppSpacing.verticalLg,
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Gradient card showing total saved across all goals.
class _TotalSavedCard extends StatelessWidget {
  const _TotalSavedCard({
    required this.totalSaved,
    required this.isDark,
    required this.currencyCode,
  });

  final double totalSaved;
  final bool isDark;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
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
            const GeometricKWatermark(
              opacity: 0.05,
              fontSize: 140,
              alignment: Alignment.topRight,
              offset: Offset(30, -20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL SAVED',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1.65,
                  ),
                ),
                AppSpacing.verticalSm,
                Text(
                  CurrencyFormatter.format(
                    totalSaved,
                    currencyCode: currencyCode,
                  ),
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
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
    final progressPercent = (goal.progress * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusLg,
      ),
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
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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

/// Quick Start 2x2 grid for common savings goal templates.
class _QuickStartGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final templates = [
      _QuickTemplate(Icons.shield_outlined, 'Emergency', Colors.blue, context),
      _QuickTemplate(Icons.flight_outlined, 'Vacation', Colors.orange, context),
      _QuickTemplate(
          Icons.directions_car_outlined, 'Car Fund', Colors.green, context),
      _QuickTemplate(Icons.school_outlined, 'Education', Colors.purple, context),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: templates.map((t) {
        return GestureDetector(
          onTap: () => context.pushNamed(RouteNames.addSavingsGoalName),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(t.icon, color: t.color, size: 28),
                AppSpacing.verticalSm,
                Text(
                  t.label.toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickTemplate {
  _QuickTemplate(this.icon, this.label, this.color, this.context);
  final IconData icon;
  final String label;
  final Color color;
  final BuildContext context;
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
                  side: BorderSide.none,
                ),
                ActionChip(
                  avatar: const Icon(Icons.flight_outlined),
                  label: Text(context.l10n.savingsTemplateVacation),
                  onPressed: () =>
                      context.pushNamed(RouteNames.addSavingsGoalName),
                  shape: const StadiumBorder(),
                  side: BorderSide.none,
                ),
                ActionChip(
                  avatar: const Icon(Icons.phone_iphone_outlined),
                  label: Text(context.l10n.savingsTemplateNewPhone),
                  onPressed: () =>
                      context.pushNamed(RouteNames.addSavingsGoalName),
                  shape: const StadiumBorder(),
                  side: BorderSide.none,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chipColor = isOverdue
        ? (isDark ? AppColors.expenseDark : AppColors.expenseLight)
        : theme.colorScheme.tertiaryContainer;
    final textColor = isOverdue
        ? Colors.white
        : theme.colorScheme.onTertiaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOverdue ? chipColor : chipColor,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning_amber : Icons.schedule,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            isOverdue ? '${-daysLeft}d overdue' : '${daysLeft}d left',
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
