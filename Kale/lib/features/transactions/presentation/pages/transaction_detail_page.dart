import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/date_time_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/feedback/app_dialog.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/core/widgets/states/app_error_state.dart';
import 'package:kale/features/transactions/domain/entities/category.dart';
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/presentation/pages/transactions_page.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_notifier.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_state.dart';

/// Transaction detail page showing a single transaction with all details.
class TransactionDetailPage extends ConsumerStatefulWidget {
  /// Creates a [TransactionDetailPage].
  const TransactionDetailPage({this.transactionId, super.key});

  /// The ID of the transaction to display.
  final String? transactionId;

  @override
  ConsumerState<TransactionDetailPage> createState() =>
      _TransactionDetailPageState();
}

class _TransactionDetailPageState
    extends ConsumerState<TransactionDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load the transaction on first build.
    if (widget.transactionId != null) {
      Future.microtask(
        () => ref
            .read(transactionsNotifierProvider.notifier)
            .loadTransaction(widget.transactionId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifierState = ref.watch(transactionsNotifierProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen for delete success.
    ref.listen<TransactionsState>(transactionsNotifierProvider, (_, next) {
      if (next is TransactionsSuccess) {
        showAppSnackBar(
          context,
          message: next.message ?? 'Done',
          variant: SnackBarVariant.success,
        );
        context.pop();
      } else if (next is TransactionsError) {
        showAppSnackBar(
          context,
          message: next.message,
          variant: SnackBarVariant.error,
        );
      }
    });

    return AppScaffold(
      appBar: AppAppBar(
        title: 'Transaction Detail',
        actions: [
          if (notifierState is TransactionsLoaded) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: () => context.pushNamed(
                RouteNames.addTransactionName,
                extra: widget.transactionId,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ],
      ),
      body: _buildBody(
        notifierState: notifierState,
        categoriesAsync: categoriesAsync,
        theme: theme,
        isDark: isDark,
      ),
    );
  }

  Widget _buildBody({
    required TransactionsState notifierState,
    required AsyncValue<List<Category>> categoriesAsync,
    required ThemeData theme,
    required bool isDark,
  }) {
    return switch (notifierState) {
      TransactionsInitial() => const SizedBox.shrink(),
      TransactionsLoading() => const AppShimmerList(itemCount: 6),
      TransactionsError(:final message) => AppErrorState(
          message: message,
          onRetry: widget.transactionId != null
              ? () => ref
                  .read(transactionsNotifierProvider.notifier)
                  .loadTransaction(widget.transactionId!)
              : null,
        ),
      TransactionsSuccess() => const SizedBox.shrink(),
      TransactionsLoaded(:final transaction) => () {
          // Resolve category.
          final categories = categoriesAsync.valueOrNull ?? [];
          final category = categories
              .cast<Category?>()
              .firstWhere(
                (c) => c!.id == transaction.categoryId,
                orElse: () => null,
              );

          return _TransactionDetailContent(
            transaction: transaction,
            category: category,
            isDark: isDark,
            theme: theme,
          );
        }(),
    };
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showAppDialog(
      context,
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete this transaction? '
          'This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      ref
          .read(transactionsNotifierProvider.notifier)
          .deleteTransaction(widget.transactionId!);
    }
  }
}

/// The detail content body.
class _TransactionDetailContent extends StatelessWidget {
  const _TransactionDetailContent({
    required this.transaction,
    required this.category,
    required this.isDark,
    required this.theme,
  });

  final Transaction transaction;
  final Category? category;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type.isIncome;
    final amountColor = isIncome
        ? (isDark ? AppColors.incomeDark : AppColors.incomeLight)
        : (isDark ? AppColors.expenseDark : AppColors.expenseLight);

    final amountPrefix = isIncome ? '+' : '-';
    final formattedAmount = CurrencyFormatter.format(
      transaction.amount,
      currencyCode: transaction.currencyCode,
    );

    final categoryIcon = iconMap[category?.icon] ?? Icons.category_outlined;
    final categoryColor = _resolveColor(category?.color);

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          AppSpacing.verticalXl,

          // Amount section
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingXl,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.08),
              borderRadius: AppRadius.borderRadiusLg,
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 28,
                  ),
                ),
                AppSpacing.verticalLg,
                Text(
                  '$amountPrefix$formattedAmount',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.verticalSm,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: amountColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusFull,
                  ),
                  child: Text(
                    isIncome ? 'Income' : 'Expense',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalXl,

          // Details card
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingLg,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: AppRadius.borderRadiusLg,
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: category?.name ?? 'Uncategorized',
                  theme: theme,
                ),
                _divider(theme),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: transaction.date.formattedLong,
                  theme: theme,
                ),
                _divider(theme),
                _DetailRow(
                  icon: Icons.payment,
                  label: 'Payment Method',
                  value: _formatPaymentMethod(transaction.paymentMethod),
                  theme: theme,
                ),
                if (transaction.paymentMethod == PaymentMethod.mobileMoney &&
                    transaction.mobileMoneyProvider != null) ...[
                  _divider(theme),
                  _DetailRow(
                    icon: Icons.phone_android,
                    label: 'Provider',
                    value: _formatMomoProvider(
                      transaction.mobileMoneyProvider!,
                    ),
                    theme: theme,
                  ),
                ],
                if (transaction.mobileMoneyRef != null) ...[
                  _divider(theme),
                  _DetailRow(
                    icon: Icons.receipt_long,
                    label: 'Reference',
                    value: transaction.mobileMoneyRef!,
                    theme: theme,
                  ),
                ],
                if (transaction.description != null &&
                    transaction.description!.isNotEmpty) ...[
                  _divider(theme),
                  _DetailRow(
                    icon: Icons.notes,
                    label: 'Description',
                    value: transaction.description!,
                    theme: theme,
                  ),
                ],
                _divider(theme),
                _DetailRow(
                  icon: Icons.access_time,
                  label: 'Created',
                  value: transaction.createdAt.formattedDateTime,
                  theme: theme,
                ),
                if (!transaction.isSynced) ...[
                  _divider(theme),
                  _DetailRow(
                    icon: Icons.cloud_off,
                    label: 'Sync Status',
                    value: 'Pending sync',
                    theme: theme,
                    valueColor: isDark
                        ? AppColors.warningDark
                        : AppColors.warningLight,
                  ),
                ],
              ],
            ),
          ),
          // Budget impact section
          if (!isIncome) ...[
            AppSpacing.verticalXl,
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderRadiusLg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.history,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.horizontalMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HISTORY',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.65,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            text:
                                'This transaction matches your recurring '
                                "spending pattern for '",
                            children: [
                              TextSpan(
                                text: category?.name ?? 'General',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: "'. Budget impact: "),
                              TextSpan(
                                text: '12%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const TextSpan(text: ' of monthly limit.'),
                            ],
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.5,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          AppSpacing.verticalXl,

          // Generate Receipt CTA
          AppPrimaryButton(
            text: 'Generate Receipt',
            icon: Icons.receipt_long,
            onPressed: () {},
          ),
          AppSpacing.verticalXxxl,
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) => SizedBox(
        height: AppSpacing.xl,
        child: Center(
          child: Container(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
      );

  Color _resolveColor(String? hexColor) {
    if (hexColor == null || hexColor.length < 6) return Colors.grey;
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  String _formatPaymentMethod(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'Cash',
      PaymentMethod.mobileMoney => 'Mobile Money',
      PaymentMethod.bank => 'Bank Transfer',
      PaymentMethod.card => 'Card',
    };
  }

  String _formatMomoProvider(String providerName) {
    final provider = MobileMoneyProvider.values.firstWhere(
      (p) => p.name == providerName,
      orElse: () => MobileMoneyProvider.other,
    );
    return provider.displayName;
  }
}

/// A single detail row with icon, label, and value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.outline,
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
