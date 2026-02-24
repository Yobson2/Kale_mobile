import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/mascot/kai_mascot.dart';
import 'package:kale/core/mascot/kai_pose.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/presentation/providers/budgets_notifier.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';

/// Budget overview page showing the active budget with category
/// progress bars, or an empty state prompting the user to create one.
class BudgetPage extends ConsumerWidget {
  /// Creates a [BudgetPage].
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBudgetAsync = ref.watch(activeBudgetProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Budget',
        showBackButton: false,
        actions: [
          activeBudgetAsync.whenOrNull(
                data: (budget) {
                  if (budget == null) return null;
                  return IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () {
                      ref
                          .read(budgetsNotifierProvider.notifier)
                          .refreshFromServer();
                    },
                  );
                },
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: SafeArea(
        child: activeBudgetAsync.when(
          data: (budget) {
            if (budget == null) {
              return _EmptyBudgetState();
            }
            return _BudgetContent(budget: budget);
          },
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, _) => _ErrorState(error: error.toString()),
        ),
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────

class _EmptyBudgetState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KaiMascot(pose: KaiPose.idle, size: 120),
            AppSpacing.verticalXl,
            Text(
              'No Active Budget',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.verticalSm,
            Text(
              'Create a budget to start tracking your spending and stay on '
              'top of your finances.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalXxl,
            FilledButton.icon(
              onPressed: () {
                context.pushNamed(RouteNames.budgetSetupName);
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Budget'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error State ─────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KaiMascot(pose: KaiPose.warning, size: 100),
            AppSpacing.verticalLg,
            Text(
              'Something went wrong',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.verticalSm,
            Text(
              error,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Budget Content ──────────────────────────────────────────────

class _BudgetContent extends ConsumerWidget {
  const _BudgetContent({required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryNames =
        ref.watch(categoryNamesProvider).valueOrNull ?? const {};
    final totalAllocated = budget.categories.fold<double>(
      0,
      (sum, cat) => sum + cat.allocatedAmount,
    );
    final totalSpent = budget.categories.fold<double>(
      0,
      (sum, cat) => sum + cat.spentAmount,
    );
    final spentPercent =
        totalAllocated > 0 ? (totalSpent / totalAllocated).clamp(0.0, 1.5) : 0.0;

    // Group categories by groupName.
    final groups = <String, List<BudgetCategoryAllocation>>{};
    for (final cat in budget.categories) {
      groups.putIfAbsent(cat.groupName, () => []).add(cat);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(activeBudgetProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget header.
            _BudgetHeader(budget: budget),
            AppSpacing.verticalLg,

            // Total progress card.
            _TotalProgressCard(
              totalSpent: totalSpent,
              totalAllocated: totalAllocated,
              spentPercent: spentPercent,
            ),
            AppSpacing.verticalLg,

            // Category groups.
            ...groups.entries.map((entry) {
              return _CategoryGroupSection(
                groupName: entry.key,
                categories: entry.value,
                categoryNames: categoryNames,
              );
            }),

            AppSpacing.verticalLg,

            // Action buttons.
            _ActionButtons(budgetId: budget.id),

            AppSpacing.verticalXl,
          ],
        ),
      ),
    );
  }
}

// ── Budget Header ───────────────────────────────────────────────

class _BudgetHeader extends StatelessWidget {
  const _BudgetHeader({required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: context.colorScheme.primary,
            ),
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.name,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalXs,
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.calendar_today_rounded,
                      label: _periodLabel(budget.period),
                      context: context,
                    ),
                    AppSpacing.horizontalSm,
                    _InfoChip(
                      icon: Icons.auto_awesome_rounded,
                      label: _strategyLabel(budget.strategy),
                      context: context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _periodLabel(BudgetPeriod period) {
    return switch (period) {
      BudgetPeriod.weekly => 'Weekly',
      BudgetPeriod.biWeekly => 'Bi-weekly',
      BudgetPeriod.monthly => 'Monthly',
    };
  }

  String _strategyLabel(BudgetStrategy strategy) {
    return switch (strategy) {
      BudgetStrategy.fiftyThirtyTwenty => '50/30/20',
      BudgetStrategy.eightyTwenty => '80/20',
      BudgetStrategy.envelope => 'Envelope',
      BudgetStrategy.custom => 'Custom',
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.context,
  });

  final IconData icon;
  final String label;
  final BuildContext context;

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: buildContext.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: buildContext.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: buildContext.textTheme.bodySmall?.copyWith(
              color: buildContext.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Total Progress Card ─────────────────────────────────────────

class _TotalProgressCard extends StatelessWidget {
  const _TotalProgressCard({
    required this.totalSpent,
    required this.totalAllocated,
    required this.spentPercent,
  });

  final double totalSpent;
  final double totalAllocated;
  final double spentPercent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverBudget = totalSpent > totalAllocated;
    final progressColor = isOverBudget
        ? (isDark ? AppColors.expenseDark : AppColors.expenseLight)
        : (isDark ? AppColors.primaryDark : AppColors.primaryLight);

    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primaryContainerDark, AppColors.surfaceDark]
              : [AppColors.primaryContainerLight, AppColors.surfaceLight],
        ),
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
                'Total Spent',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(spentPercent * 100).toStringAsFixed(0)}%',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: progressColor,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSm,
          Text(
            CurrencyFormatter.format(totalSpent),
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: progressColor,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            'of ${CurrencyFormatter.format(totalAllocated)} budget',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalMd,
          ClipRRect(
            borderRadius: AppRadius.borderRadiusFull,
            child: LinearProgressIndicator(
              value: spentPercent.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: context.colorScheme.outlineVariant.withValues(
                alpha: 0.3,
              ),
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category Group Section ──────────────────────────────────────

class _CategoryGroupSection extends StatelessWidget {
  const _CategoryGroupSection({
    required this.groupName,
    required this.categories,
    required this.categoryNames,
  });

  final String groupName;
  final List<BudgetCategoryAllocation> categories;
  final Map<String, String> categoryNames;

  @override
  Widget build(BuildContext context) {
    final groupTotal = categories.fold<double>(
      0,
      (sum, cat) => sum + cat.allocatedAmount,
    );
    final groupSpent = categories.fold<double>(
      0,
      (sum, cat) => sum + cat.spentAmount,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
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
            // Group header.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _groupIcon(groupName),
                        size: 18,
                        color: context.colorScheme.primary,
                      ),
                      AppSpacing.horizontalSm,
                      Text(
                        groupName,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${CurrencyFormatter.format(groupSpent, compact: true)}'
                    ' / '
                    '${CurrencyFormatter.format(groupTotal, compact: true)}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Category items.
            ...categories.map(
              (cat) => _CategoryProgressItem(
                category: cat,
                categoryNames: categoryNames,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _groupIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('need')) return Icons.home_rounded;
    if (lower.contains('want')) return Icons.shopping_bag_rounded;
    if (lower.contains('saving')) return Icons.savings_rounded;
    return Icons.category_rounded;
  }
}

class _CategoryProgressItem extends StatelessWidget {
  const _CategoryProgressItem({
    required this.category,
    required this.categoryNames,
  });

  final BudgetCategoryAllocation category;
  final Map<String, String> categoryNames;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allocated = category.allocatedAmount;
    final spent = category.spentAmount;
    final progress = allocated > 0 ? (spent / allocated).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = spent > allocated;
    final progressColor = isOverBudget
        ? (isDark ? AppColors.expenseDark : AppColors.expenseLight)
        : (isDark ? AppColors.primaryDark : AppColors.primaryLight);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  categoryNames[category.categoryId] ??
                      category.categoryId,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${CurrencyFormatter.format(spent, compact: true)}'
                ' / '
                '${CurrencyFormatter.format(allocated, compact: true)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isOverBudget
                      ? (isDark
                          ? AppColors.expenseDark
                          : AppColors.expenseLight)
                      : context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSm,
          ClipRRect(
            borderRadius: AppRadius.borderRadiusFull,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: context.colorScheme.outlineVariant.withValues(
                alpha: 0.2,
              ),
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Buttons ──────────────────────────────────────────────

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.pushNamed(RouteNames.budgetSetupName);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Budget'),
          ),
        ),
        AppSpacing.horizontalMd,
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {
              // TODO(dev): Navigate to edit budget page.
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit Budget'),
          ),
        ),
      ],
    );
  }
}
