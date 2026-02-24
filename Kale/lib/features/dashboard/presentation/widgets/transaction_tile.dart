import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.categoryNames,
    super.key,
  });

  final Transaction transaction;
  final Map<String, String> categoryNames;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome
        ? (isDark ? AppColors.incomeDark : AppColors.incomeLight)
        : (isDark ? AppColors.expenseDark : AppColors.expenseLight);
    final sign = isIncome ? '+' : '-';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: amountColor.withValues(alpha: 0.12),
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Icon(
          isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: amountColor,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description ??
            categoryNames[transaction.categoryId] ??
            transaction.categoryId,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatDate(transaction.date),
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        '$sign${CurrencyFormatter.format(
          transaction.amount,
          currencyCode: transaction.currencyCode,
          compact: true,
        )}',
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: amountColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) return 'Today';
    if (transactionDate == yesterday) return 'Yesterday';

    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.day}';
  }
}
