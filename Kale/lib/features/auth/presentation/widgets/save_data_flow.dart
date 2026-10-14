import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/save_data_outcome.dart';
import 'package:kale/features/auth/presentation/widgets/guest_data_choice_dialog.dart';

/// A guest's pending switch to an existing email account: waiting for the
/// sign-in code sent to the credential's email.
typedef PendingEmailSwitch = ({
  EmailCodeCredential credential,
  bool keepGuestData,
});

/// The steps a guest goes through to save their data to a real account,
/// shared by the save-data page and the login page.
mixin SaveDataFlow<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Whether a step is running.
  bool busy = false;

  /// Called when an email code was sent; [pending] is set when the code
  /// will sign in to an existing account (rather than link the email).
  void onCodeSent({PendingEmailSwitch? pending});

  /// Runs [step] with [busy] set, then handles its outcome.
  Future<void> runSaveDataStep(Future<SaveDataOutcome> Function() step) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await handleSaveDataOutcome(await step());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  /// Acts on [outcome]: done goes home, an identity in use asks what to do
  /// with the guest's entries, a failure shows why.
  Future<void> handleSaveDataOutcome(SaveDataOutcome outcome) async {
    if (!mounted) return;
    final notifier = ref.read(authNotifierProvider.notifier);
    switch (outcome) {
      case SaveDataDone():
        showAppSnackBar(
          context,
          message: context.l10n.saveDataDone,
          variant: SnackBarVariant.success,
        );
        context.go(RouteNames.dashboard);
      case SaveDataCodeSent():
        onCodeSent();
      case SaveDataFailed(:final message):
        showAppSnackBar(
          context,
          message: message,
          variant: SnackBarVariant.error,
        );
      case SaveDataIdentityInUse(:final credential, :final entryCount):
        // With nothing to keep there is nothing to choose.
        final choice = entryCount == 0
            ? GuestDataChoice.discard
            : await showGuestDataChoiceDialog(
                context,
                entryCount: entryCount,
              );
        if (choice == null || !mounted) return;
        final keep = choice == GuestDataChoice.add;
        if (credential is EmailCodeCredential) {
          final sent = await notifier.sendSignInCode(credential.email);
          if (!mounted) return;
          if (sent is SaveDataCodeSent) {
            onCodeSent(pending: (credential: credential, keepGuestData: keep));
          } else {
            await handleSaveDataOutcome(sent);
          }
          return;
        }
        await handleSaveDataOutcome(
          await notifier.switchToExistingAccount(
            credential,
            keepGuestData: keep,
          ),
        );
    }
  }
}
