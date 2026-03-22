import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/extensions/date_time_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/animations/staggered_list_item.dart';
import 'package:kale/core/widgets/data_display/app_chip.dart';
import 'package:kale/core/widgets/inputs/app_search_field.dart';
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

  /// Current search query for filtering transactions.
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.transactionsTitle,
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
            tooltip: context.l10n.transactionsAddTransaction,
            onPressed: () => context.pushNamed(RouteNames.addTransactionName),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: AppSearchField(
              hint: context.l10n.transactionsSearchHint,
              onChanged: (query) => setState(() => _searchQuery = query),
            ),
          ),

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
                // Build a category lookup map.
                final categories = categoriesAsync.valueOrNull ?? [];
                final categoryMap = {
                  for (final cat in categories) cat.id: cat,
                };

                // Apply local type filter.
                var filtered = _selectedType == null
                    ? transactions
                    : transactions
                        .where((t) => t.type == _selectedType)
                        .toList();

                // Apply search filter.
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  filtered = filtered.where((t) {
                    final descriptionMatch = t.description
                            ?.toLowerCase()
                            .contains(query) ??
                        false;
                    final category = categoryMap[t.categoryId];
                    final categoryMatch =
                        category?.name.toLowerCase().contains(query) ?? false;
                    return descriptionMatch || categoryMatch;
                  }).toList();
                }

                if (filtered.isEmpty) {
                  return AppEmptyState(
                    title: context.l10n.transactionsNoTransactions,
                    subtitle:
                        '${context.l10n.transactionsNoTransactionsSubtitle}\n${context.l10n.transactionsEmptyQuickTip}',
                    actionText: context.l10n.transactionsAddTransaction,
                    onAction: () =>
                        context.pushNamed(RouteNames.addTransactionName),
                  );
                }

                // Group transactions by date.
                final groups = _groupTransactionsByDate(context, filtered);

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(transactionsStreamProvider);
                  },
                  child: CustomScrollView(
                    slivers: [
                      for (final group in groups) ...[
                        // Sticky section header
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyHeaderDelegate(
                            label: group.label,
                          ),
                        ),
                        // Transaction items for this group
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final transaction = group.transactions[index];
                              final category =
                                  categoryMap[transaction.categoryId];

                              return StaggeredListItem(
                                index: index,
                                child: Dismissible(
                                key: ValueKey(transaction.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(
                                    right: AppSpacing.lg,
                                  ),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (_) =>
                                    _confirmDelete(context),
                                onDismissed: (_) =>
                                    _deleteTransaction(transaction.id),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                  ),
                                  child: _TransactionTile(
                                    transaction: transaction,
                                    category: category,
                                    isDark: isDark,
                                    onTap: () => context.pushNamed(
                                      RouteNames.transactionDetailName,
                                      extra: transaction.id,
                                    ),
                                  ),
                                ),
                              ),
                              );
                            },
                            childCount: group.transactions.length,
                          ),
                        ),
                      ],
                      // End-of-list message
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xl,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 16,
                                  color:
                                      context.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'End of recent history',
                                  style: context.textTheme.labelSmall
                                      ?.copyWith(
                                    color: context
                                        .colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Bottom padding
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: AppSpacing.lg),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Groups transactions into Today, Yesterday, This Week, and Earlier.
  List<_TransactionGroup> _groupTransactionsByDate(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    final today = <Transaction>[];
    final yesterday = <Transaction>[];
    final thisWeek = <Transaction>[];
    final earlier = <Transaction>[];

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    for (final t in transactions) {
      if (t.date.isToday) {
        today.add(t);
      } else if (t.date.isYesterday) {
        yesterday.add(t);
      } else if (t.date.toLocal().isAfter(sevenDaysAgo)) {
        thisWeek.add(t);
      } else {
        earlier.add(t);
      }
    }

    return [
      if (today.isNotEmpty)
        _TransactionGroup(
          label: context.l10n.transactionsToday,
          transactions: today,
        ),
      if (yesterday.isNotEmpty)
        _TransactionGroup(
          label: context.l10n.transactionsYesterday,
          transactions: yesterday,
        ),
      if (thisWeek.isNotEmpty)
        _TransactionGroup(
          label: context.l10n.transactionsThisWeek,
          transactions: thisWeek,
        ),
      if (earlier.isNotEmpty)
        _TransactionGroup(
          label: context.l10n.transactionsEarlier,
          transactions: earlier,
        ),
    ];
  }

  /// Shows a confirmation dialog before deleting a transaction.
  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.transactionsDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Deletes a transaction and shows a snackbar.
  Future<void> _deleteTransaction(String id) async {
    final deleteUseCase = ref.read(deleteTransactionUseCaseProvider);
    final result = await deleteUseCase(id);

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.transactionsDeleted)),
        );
      },
    );
  }
}

/// A group of transactions under a date-based section header.
class _TransactionGroup {
  const _TransactionGroup({
    required this.label,
    required this.transactions,
  });

  final String label;
  final List<Transaction> transactions;
}

/// Delegate for sticky section headers with uppercase label style.
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({required this.label});

  final String label;

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      color: theme.scaffoldBackgroundColor,
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.65,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.label != label;
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
            label: context.l10n.transactionsAll,
            isSelected: selectedType == null,
            onTap: () => onTypeSelected(null),
          ),
          AppSpacing.horizontalSm,
          AppChip(
            label: context.l10n.transactionsIncome,
            isSelected: selectedType == TransactionType.income,
            onTap: () => onTypeSelected(TransactionType.income),
          ),
          AppSpacing.horizontalSm,
          AppChip(
            label: context.l10n.transactionsExpense,
            isSelected: selectedType == TransactionType.expense,
            onTap: () => onTypeSelected(TransactionType.expense),
          ),
        ],
      ),
    );
  }
}

/// A single transaction tile with left accent border and circle category icon.
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

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderRadiusMd,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    category?.name ??
                        context.l10n.transactionsUncategorized,
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
                ),
              ),
            ],
          ),
        ),
      ),
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
