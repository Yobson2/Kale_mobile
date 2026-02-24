import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/core/widgets/inputs/app_text_field.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/features/savings/presentation/providers/savings_notifier.dart';
import 'package:kale/features/savings/presentation/providers/savings_state.dart';

/// Page for creating a new savings goal.
class AddSavingsGoalPage extends ConsumerStatefulWidget {
  /// Creates an [AddSavingsGoalPage].
  const AddSavingsGoalPage({super.key});

  @override
  ConsumerState<AddSavingsGoalPage> createState() =>
      _AddSavingsGoalPageState();
}

class _AddSavingsGoalPageState extends ConsumerState<AddSavingsGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _deadline;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyCode = ref.watch(userCurrencyCodeProvider);

    ref.listen(savingsNotifierProvider, (_, state) {
      if (state is SavingsSuccess) {
        showAppSnackBar(context, message: state.message ?? 'Goal created');
        context.pop();
      } else if (state is SavingsError) {
        showAppSnackBar(
          context,
          message: state.message,
          variant: SnackBarVariant.error,
        );
      }
    });

    final isLoading = ref.watch(savingsNotifierProvider) is SavingsLoading;

    return AppScaffold(
      appBar: const AppAppBar(title: 'New Savings Goal'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.verticalMd,

                // Goal name
                AppTextField(
                  controller: _nameController,
                  label: 'Goal Name',
                  hint: 'e.g. Emergency Fund, New Laptop',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a goal name';
                    }
                    return null;
                  },
                ),

                AppSpacing.verticalLg,

                // Target amount
                AppTextField(
                  controller: _amountController,
                  label: 'Target Amount ($currencyCode)',
                  hint: '0.00',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a target amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),

                AppSpacing.verticalLg,

                // Description (optional)
                AppTextField(
                  controller: _descriptionController,
                  label: 'Description (optional)',
                  hint: 'What are you saving for?',
                  maxLines: 2,
                ),

                AppSpacing.verticalLg,

                // Deadline picker
                _DeadlinePicker(
                  deadline: _deadline,
                  onPicked: (date) => setState(() => _deadline = date),
                ),

                AppSpacing.verticalXxl,

                // Create button
                AppPrimaryButton(
                  text: 'Create Goal',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final currencyCode = ref.read(userCurrencyCodeProvider);

    ref.read(savingsNotifierProvider.notifier).createGoal(
          name: _nameController.text.trim(),
          targetAmount: double.parse(_amountController.text.trim()),
          currencyCode: currencyCode,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          deadline: _deadline,
        );
  }
}

/// Deadline date picker tile.
class _DeadlinePicker extends StatelessWidget {
  const _DeadlinePicker({
    required this.deadline,
    required this.onPicked,
  });

  final DateTime? deadline;
  final ValueChanged<DateTime?> onPicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate:
              deadline ?? DateTime.now().add(const Duration(days: 90)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: AppRadius.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deadline (optional)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    deadline != null
                        ? '${deadline!.day}/${deadline!.month}/${deadline!.year}'
                        : 'No deadline set',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            if (deadline != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => onPicked(null),
              ),
          ],
        ),
      ),
    );
  }
}
