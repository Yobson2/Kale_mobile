import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/date_time_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/data_display/app_chip.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/core/widgets/states/app_empty_state.dart';
import 'package:kale/core/widgets/states/app_error_state.dart';
import 'package:kale/features/transactions/domain/entities/category.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';

/// Page that lists all transactions with type filter chips.
class TransactionsPage extends ConsumerStatefulWidget {
  /// Creates a [TransactionsPage].
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  /// Currently selected filter. Null means "All".
  TransactionType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        title: 'Transactions',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add transaction',
            onPressed: () => context.pushNamed(RouteNames.addTransactionName),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips row
          _FilterChipsRow(
            selectedType: _selectedType,
            onTypeSelected: (type) => setState(() => _selectedType = type),
          ),

          // Transaction list
          Expanded(
            child: transactionsAsync.when(
              loading: () => const AppShimmerList(),
              error: (error, _) => AppErrorState(
                message: error.toString(),
              ),
              data: (transactions) {
                // Apply local type filter.
                final filtered = _selectedType == null
                    ? transactions
                    : transactions
                        .where((t) => t.type == _selectedType)
                        .toList();

                if (filtered.isEmpty) {
                  return AppEmptyState(
                    title: 'No transactions yet',
                    subtitle: 'Tap + to add your first transaction',
                    actionText: 'Add Transaction',
                    onAction: () =>
                        context.pushNamed(RouteNames.addTransactionName),
                  );
                }

                // Build a category lookup map.
                final categories = categoriesAsync.valueOrNull ?? [];
                final categoryMap = {
                  for (final cat in categories) cat.id: cat,
                };

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(transactionsStreamProvider);
                  },
                  child: ListView.separated(
                    padding: AppSpacing.paddingLg,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final transaction = filtered[index];
                      final category = categoryMap[transaction.categoryId];

                      return _TransactionTile(
                        transaction: transaction,
                        category: category,
                        isDark: isDark,
                        onTap: () => context.pushNamed(
                          RouteNames.transactionDetailName,
                          extra: transaction.id,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of filter chips: All, Income, Expense.
class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.selectedType,
    required this.onTypeSelected,
  });

  final TransactionType? selectedType;
  final ValueChanged<TransactionType?> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          AppChip(
            label: 'All',
            isSelected: selectedType == null,
            onTap: () => onTypeSelected(null),
          ),
          AppSpacing.horizontalSm,
          AppChip(
            label: 'Income',
            isSelected: selectedType == TransactionType.income,
            onTap: () => onTypeSelected(TransactionType.income),
          ),
          AppSpacing.horizontalSm,
          AppChip(
            label: 'Expense',
            isSelected: selectedType == TransactionType.expense,
            onTap: () => onTypeSelected(TransactionType.expense),
          ),
        ],
      ),
    );
  }
}

/// A single transaction list tile.
class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.category,
    required this.isDark,
    required this.onTap,
  });

  final Transaction transaction;
  final Category? category;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type.isIncome;

    final amountColor = isIncome
        ? (isDark ? AppColors.incomeDark : AppColors.incomeLight)
        : (isDark ? AppColors.expenseDark : AppColors.expenseLight);

    final amountPrefix = isIncome ? '+' : '-';
    final formattedAmount = CurrencyFormatter.format(
      transaction.amount,
      currencyCode: transaction.currencyCode,
    );

    final categoryIcon = _resolveIcon(category?.icon);
    final categoryColor = _resolveColor(category?.color);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.12),
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Icon(
          categoryIcon,
          color: categoryColor,
          size: 22,
        ),
      ),
      title: Text(
        category?.name ?? 'Uncategorized',
        style: theme.textTheme.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        transaction.description ?? transaction.date.formatted,
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$amountPrefix$formattedAmount',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            transaction.date.timeAgo,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  /// Resolves a Material icon name string to an [IconData].
  IconData _resolveIcon(String? iconName) {
    if (iconName == null) return Icons.category_outlined;
    return iconMap[iconName] ?? Icons.category_outlined;
  }

  /// Resolves a hex color string to a [Color].
  Color _resolveColor(String? hexColor) {
    if (hexColor == null || hexColor.length < 6) return Colors.grey;
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}

/// Maps Material icon name strings (as stored in categories) to [IconData].
///
/// Shared across pages that display transaction category icons.
const Map<String, IconData> iconMap = {
  // Expense categories
  'restaurant': Icons.restaurant,
  'directions_bus': Icons.directions_bus,
  'phone_android': Icons.phone_android,
  'home': Icons.home,
  'electrical_services': Icons.electrical_services,
  'account_balance_wallet': Icons.account_balance_wallet,
  'business_center': Icons.business_center,
  'school': Icons.school,
  'local_hospital': Icons.local_hospital,
  'checkroom': Icons.checkroom,
  'movie': Icons.movie,
  'family_restroom': Icons.family_restroom,
  'volunteer_activism': Icons.volunteer_activism,
  'savings': Icons.savings,
  'money_off': Icons.money_off,
  'spa': Icons.spa,
  'weekend': Icons.weekend,
  'security': Icons.security,
  'more_horiz': Icons.more_horiz,
  // Income categories
  'payments': Icons.payments,
  'storefront': Icons.storefront,
  'laptop': Icons.laptop,
  'trending_up': Icons.trending_up,
  'phone_iphone': Icons.phone_iphone,
  'people': Icons.people,
  'apartment': Icons.apartment,
  'show_chart': Icons.show_chart,
  'account_balance': Icons.account_balance,
  // Fallback
  'category': Icons.category_outlined,
};
