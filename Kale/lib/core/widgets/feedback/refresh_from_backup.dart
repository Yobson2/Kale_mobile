import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/core/sync/sync_puller.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';

/// Pull-to-refresh for the main screens: brings in changes from the
/// backup (never overwriting changes not yet pushed), and tells the user
/// when it couldn't.
Future<void> refreshFromBackup(BuildContext context, WidgetRef ref) async {
  final outcome = await ref.read(syncPullerProvider).pull();
  if (!context.mounted) return;
  switch (outcome) {
    case PullOutcome.done:
      return;
    case PullOutcome.offline:
      showAppSnackBar(
        context,
        message: context.l10n.refreshOffline,
        variant: SnackBarVariant.warning,
      );
    case PullOutcome.failed:
      showAppSnackBar(
        context,
        message: context.l10n.refreshFailed,
        variant: SnackBarVariant.error,
      );
  }
}
