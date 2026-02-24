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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/transactions');
              },
              child: Text(
                'See all',
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
            itemCount: transactions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: AppSpacing.lg,
              endIndent: AppSpacing.lg,
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) {
              return TransactionTile(
                transaction: transactions[index],
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
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppSpacing.verticalMd,
          Text(
            'No transactions yet',
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            'Tap the + button to add your first transaction',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
