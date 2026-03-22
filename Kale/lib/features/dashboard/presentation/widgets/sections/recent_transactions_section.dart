// ── Recent Transactions Section ─────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kale/features/dashboard/presentation/widgets/transaction_tile.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';

class RecentTransactionsSection extends ConsumerWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return summaryAsync.when(
      data: (summary) {
        final transactions = summary.recentTransactions;
        if (transactions.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildTransactionsList(
          context,
          transactions,
          summary.categoryNames,
        );
      },
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    List<Transaction> transactions,
    Map<String, String> categoryNames,
  ) {
    final limitedTransactions = transactions.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.dashboardRecentTransactions,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/transactions');
              },
              child: Text(
                context.l10n.commonSeeAll,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalSm,
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: limitedTransactions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: AppSpacing.lg,
              endIndent: AppSpacing.lg,
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              return TransactionTile(
                transaction: limitedTransactions[index],
                categoryNames: categoryNames,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingXl,
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
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.rocket_launch_outlined,
                  size: 40,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.dashboardEmptyTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          Text(
            context.l10n.dashboardEmptySubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalLg,
          _buildChecklistItem(
            context,
            Icons.receipt_long_outlined,
            context.l10n.dashboardEmptyStep1,
          ),
          AppSpacing.verticalSm,
          _buildChecklistItem(
            context,
            Icons.pie_chart_outline,
            context.l10n.dashboardEmptyStep2,
          ),
          AppSpacing.verticalSm,
          _buildChecklistItem(
            context,
            Icons.savings_outlined,
            context.l10n.dashboardEmptyStep3,
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.primaryContainer,
          ),
          child: Icon(
            icon,
            size: 14,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
