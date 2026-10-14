import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/widgets/feedback/app_dialog.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/features/profile/domain/usecases/change_base_currency_usecase.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';

/// Every selectable base currency, with its flag and name, as a list.
class BaseCurrencyList extends StatelessWidget {
  const BaseCurrencyList({
    required this.selected,
    required this.onSelected,
    this.controller,
    this.shrinkWrap = false,
    super.key,
  });

  final Currency? selected;
  final ValueChanged<Currency> onSelected;
  final ScrollController? controller;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: Currencies.all.length,
      itemBuilder: (context, index) {
        final currency = Currencies.all[index];
        return ListTile(
          leading: Text(currency.flag, style: const TextStyle(fontSize: 24)),
          title: Text('${currency.code} · ${currency.symbol}'),
          subtitle: Text(currency.name),
          selected: currency == selected,
          trailing: currency == selected
              ? Icon(Icons.check_circle, color: context.colorScheme.primary)
              : null,
          onTap: () => onSelected(currency),
        );
      },
    );
  }
}

/// Changes the base currency following the rules in
/// [ChangeBaseCurrencyUseCase]: silently while there are no transactions,
/// otherwise only after the user confirms that nothing is converted.
///
/// Returns true if the base currency changed.
Future<bool> requestBaseCurrencyChange(
  BuildContext context,
  WidgetRef ref,
  Currency currency,
) async {
  final controller = ref.read(baseCurrencyControllerProvider.notifier);
  var change = await controller.change(currency);

  if (change == BaseCurrencyChange.needsRelabelConfirmation) {
    if (!context.mounted) return false;
    final l10n = context.l10n;
    final confirmed = await showAppDialog(
      context,
      title: l10n.baseCurrencyRelabelTitle,
      message: l10n.baseCurrencyRelabelMessage(currency.code),
      confirmText: l10n.baseCurrencyRelabelConfirm,
      cancelText: l10n.commonCancel,
      isDestructive: true,
    );
    if (confirmed != true) return false;
    change = await controller.change(currency, relabelConfirmed: true);
  }

  if (change == null && context.mounted) {
    showAppSnackBar(
      context,
      message: context.l10n.baseCurrencyChangeFailed,
      variant: SnackBarVariant.error,
    );
  }
  return change == BaseCurrencyChange.changed;
}
