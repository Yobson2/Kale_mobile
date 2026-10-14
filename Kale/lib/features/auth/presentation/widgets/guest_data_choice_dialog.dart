import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_spacing.dart';

/// What a guest chose to do with their entries when signing in to an
/// account that already exists.
enum GuestDataChoice {
  /// Add them to that account (the default).
  add,

  /// Discard them and get that account's data instead.
  discard,
}

/// Asks what to do with the guest's [entryCount] entries. "Add" is the
/// default and first action. Returns null if the user cancels.
Future<GuestDataChoice?> showGuestDataChoiceDialog(
  BuildContext context, {
  required int entryCount,
}) {
  final l10n = context.l10n;
  return showDialog<GuestDataChoice>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.guestDataChoiceTitle),
      content: Text(l10n.guestDataChoiceMessage(entryCount)),
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              autofocus: true,
              onPressed: () => Navigator.of(context).pop(GuestDataChoice.add),
              child: Text(l10n.guestDataChoiceAdd(entryCount)),
            ),
            AppSpacing.verticalSm,
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorScheme.error,
              ),
              onPressed: () =>
                  Navigator.of(context).pop(GuestDataChoice.discard),
              child: Text(l10n.guestDataChoiceDiscard),
            ),
            AppSpacing.verticalSm,
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.guestDataChoiceCancel),
            ),
          ],
        ),
      ],
    ),
  );
}
