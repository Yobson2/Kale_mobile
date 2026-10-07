import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kale/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/data_display/app_chip.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/core/widgets/inputs/app_dropdown.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/features/transactions/domain/entities/category.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/presentation/pages/transactions_page.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_notifier.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_state.dart';

/// Page for creating or editing a transaction.
///
/// Pass an optional [transactionId] via `extra` to edit an existing one.
class AddTransactionPage extends ConsumerStatefulWidget {
  /// Creates an [AddTransactionPage].
  const AddTransactionPage({this.transactionId, super.key});

  /// If non-null, we are editing an existing transaction.
  final String? transactionId;

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.mobileMoney;
  MobileMoneyProvider? _selectedMomoProvider;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isEditing = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final notifierState = ref.watch(transactionsNotifierProvider);

    _isEditing = widget.transactionId != null;

    // Load existing transaction data for editing.
    if (_isEditing && !_isInitialized) {
      _loadExistingTransaction();
    }

    final l10n = context.l10n;

    // Listen for success/error states.
    ref.listen<TransactionsState>(transactionsNotifierProvider, (_, next) {
      switch (next) {
        case TransactionsSuccess(:final message):
          showAppSnackBar(
            context,
            message: message ?? l10n.transactionsSaved,
            variant: SnackBarVariant.success,
          );
          context.pop();
        case TransactionsError(:final message):
          showAppSnackBar(
            context,
            message: message,
            variant: SnackBarVariant.error,
          );
        case _:
          break;
      }
    });

    final isLoading = notifierState is TransactionsLoading;

    return AppScaffold(
      appBar: AppAppBar(
        title: _isEditing
            ? l10n.transactionsEditTransaction
            : l10n.transactionsAddTransaction,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingLg,
          children: [
            // Transaction type toggle
            _TypeToggle(
              selectedType: _selectedType,
              isDark: isDark,
              onTypeChanged: (type) => setState(() {
                _selectedType = type;
                // Reset category when type changes.
                _selectedCategoryId = null;
              }),
            ),
            AppSpacing.verticalXl,

            // Amount input
            _AmountInput(
              controller: _amountController,
              theme: theme,
              currencyCode: ref.watch(userCurrencyCodeProvider),
              l10n: l10n,
            ),
            AppSpacing.verticalXl,

            // Category picker
            categoriesAsync.when(
              loading: () => const AppShimmerList(itemCount: 2),
              error: (error, _) => Text('Error loading categories: $error'),
              data: (categories) {
                // Filter categories by selected type.
                final filtered = categories.where((cat) {
                  if (cat.type == CategoryType.both) return true;
                  if (_selectedType == TransactionType.income) {
                    return cat.type == CategoryType.income;
                  }
                  return cat.type == CategoryType.expense;
                }).toList();

                return _CategoryPicker(
                  categories: filtered,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: (id) =>
                      setState(() => _selectedCategoryId = id),
                );
              },
            ),
            AppSpacing.verticalXl,

            // Date picker
            _DatePickerField(
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
            AppSpacing.verticalXl,

            // Payment method selector
            _PaymentMethodSelector(
              selectedMethod: _selectedPaymentMethod,
              onMethodSelected: (method) => setState(() {
                _selectedPaymentMethod = method;
                if (method != PaymentMethod.mobileMoney) {
                  _selectedMomoProvider = null;
                }
              }),
            ),
            AppSpacing.verticalLg,

            // Mobile money provider dropdown
            if (_selectedPaymentMethod == PaymentMethod.mobileMoney) ...[
              AppDropdown<MobileMoneyProvider>(
                label: l10n.transactionsMobileMoneyProvider,
                hint: l10n.transactionsSelectProvider,
                value: _selectedMomoProvider,
                items: MobileMoneyProvider.values
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (provider) =>
                    setState(() => _selectedMomoProvider = provider),
                validator: (value) {
                  if (_selectedPaymentMethod == PaymentMethod.mobileMoney &&
                      value == null) {
                    return l10n.transactionsSelectProviderRequired;
                  }
                  return null;
                },
              ),
              AppSpacing.verticalXl,
            ],

            // Description field
            AppTextField(
              controller: _descriptionController,
              label: l10n.transactionsDescription,
              hint: l10n.transactionsDescriptionHint,
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
            AppSpacing.verticalXxl,

            // Save button
            AppPrimaryButton(
              text: _isEditing
                  ? l10n.transactionsUpdateTransaction
                  : l10n.transactionsSaveTransaction,
              isLoading: isLoading,
              onPressed: isLoading ? null : _onSave,
            ),
            AppSpacing.verticalXxxl,
          ],
        ),
      ),
    );
  }

  /// Loads existing transaction data when editing.
  void _loadExistingTransaction() {
    _isInitialized = true;
    final notifier = ref.read(transactionsNotifierProvider.notifier);
    notifier.loadTransaction(widget.transactionId!);

    // Listen once for the loaded state to populate fields.
    ref.listenManual<TransactionsState>(
      transactionsNotifierProvider,
      (_, next) {
        if (next is TransactionsLoaded) {
          final t = next.transaction;
          setState(() {
            _amountController.text = t.amount.toString();
            _descriptionController.text = t.description ?? '';
            _selectedType = t.type;
            _selectedPaymentMethod = t.paymentMethod;
            _selectedCategoryId = t.categoryId;
            _selectedDate = t.date;
            if (t.mobileMoneyProvider != null) {
              _selectedMomoProvider = MobileMoneyProvider.values.firstWhere(
                (p) => p.name == t.mobileMoneyProvider,
                orElse: () => MobileMoneyProvider.other,
              );
            }
          });
        }
      },
    );
  }

  /// Validates and saves the transaction.
  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      showAppSnackBar(
        context,
        message: context.l10n.transactionsValidAmountRequired,
        variant: SnackBarVariant.error,
      );
      return;
    }

    if (_selectedCategoryId == null) {
      showAppSnackBar(
        context,
        message: context.l10n.transactionsCategoryRequired,
        variant: SnackBarVariant.error,
      );
      return;
    }

    final notifier = ref.read(transactionsNotifierProvider.notifier);
    final currencyCode = ref.read(userCurrencyCodeProvider);

    if (_isEditing) {
      notifier.updateTransaction(
        id: widget.transactionId!,
        amount: amount,
        type: _selectedType,
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        paymentMethod: _selectedPaymentMethod,
        currencyCode: currencyCode,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        mobileMoneyProvider: _selectedMomoProvider?.name,
      );
    } else {
      notifier.createTransaction(
        amount: amount,
        type: _selectedType,
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        paymentMethod: _selectedPaymentMethod,
        currencyCode: currencyCode,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        mobileMoneyProvider: _selectedMomoProvider?.name,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

/// Toggle between Income and Expense types.
class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.selectedType,
    required this.isDark,
    required this.onTypeChanged,
  });

  final TransactionType selectedType;
  final bool isDark;
  final ValueChanged<TransactionType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeChip(
            label: context.l10n.transactionsExpense,
            icon: Icons.arrow_downward,
            isSelected: selectedType == TransactionType.expense,
            selectedColor:
                isDark ? AppColors.expenseDark : AppColors.expenseLight,
            onTap: () => onTypeChanged(TransactionType.expense),
          ),
        ),
        AppSpacing.horizontalMd,
        Expanded(
          child: _TypeChip(
            label: context.l10n.transactionsIncome,
            icon: Icons.arrow_upward,
            isSelected: selectedType == TransactionType.income,
            selectedColor:
                isDark ? AppColors.incomeDark : AppColors.incomeLight,
            onTap: () => onTypeChanged(TransactionType.income),
          ),
        ),
      ],
    );
  }
}

/// A single type toggle chip.
class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected
          ? selectedColor.withValues(alpha: 0.12)
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: AppRadius.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? selectedColor : theme.colorScheme.outline,
              ),
              AppSpacing.horizontalSm,
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? selectedColor
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Centered large amount input field.
class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.controller,
    required this.theme,
    required this.currencyCode,
    required this.l10n,
  });

  final TextEditingController controller;
  final ThemeData theme;
  final String currencyCode;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          l10n.transactionsAmount,
          style: theme.textTheme.labelLarge,
        ),
        AppSpacing.verticalSm,
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: l10n.transactionsAmountHint,
            hintStyle: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
            prefixText: '$currencyCode ',
            prefixStyle: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.transactionsAmountRequired;
            }
            final amount = double.tryParse(value.trim());
            if (amount == null || amount <= 0) {
              return l10n.transactionsAmountInvalid;
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Grid of category icons for selection.
class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.transactionsCategory, style: theme.textTheme.labelLarge),
        AppSpacing.verticalSm,
        if (categories.isEmpty)
          Text(context.l10n.transactionsNoCategoriesAvailable)
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat.id == selectedCategoryId;
              final color = _resolveColor(cat.color);
              final iconData = iconMap[cat.icon] ?? Icons.category_outlined;

              return GestureDetector(
                onTap: () => onCategorySelected(cat.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                    borderRadius: AppRadius.borderRadiusMd,
                    border:
                        isSelected ? Border.all(color: color, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        color: isSelected
                            ? color
                            : theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      AppSpacing.verticalXs,
                      Text(
                        cat.name,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? color
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Color _resolveColor(String? hexColor) {
    if (hexColor == null || hexColor.length < 6) return Colors.grey;
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}

/// Tappable date picker field.
class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.transactionsDate, style: theme.textTheme.labelLarge),
        AppSpacing.verticalSm,
        InkWell(
          onTap: () => _showPicker(context),
          borderRadius: AppRadius.borderRadiusMd,
          child: InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

/// Payment method selector with chips.
class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodSelected;

  static Map<PaymentMethod, String> _getLabels(BuildContext context) {
    final l10n = context.l10n;
    return {
      PaymentMethod.cash: l10n.transactionsPaymentCash,
      PaymentMethod.mobileMoney: l10n.transactionsPaymentMobileMoney,
      PaymentMethod.bank: l10n.transactionsPaymentBank,
      PaymentMethod.card: l10n.transactionsPaymentCard,
    };
  }

  static const _icons = {
    PaymentMethod.cash: Icons.money,
    PaymentMethod.mobileMoney: Icons.phone_android,
    PaymentMethod.bank: Icons.account_balance,
    PaymentMethod.card: Icons.credit_card,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labels = _getLabels(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.transactionsPaymentMethod,
          style: theme.textTheme.labelLarge,
        ),
        AppSpacing.verticalSm,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: PaymentMethod.values.map((method) {
            return AppChip(
              label: labels[method] ?? method.name,
              avatar: Icon(_icons[method], size: 16),
              isSelected: selectedMethod == method,
              onTap: () => onMethodSelected(method),
            );
          }).toList(),
        ),
      ],
    );
  }
}
