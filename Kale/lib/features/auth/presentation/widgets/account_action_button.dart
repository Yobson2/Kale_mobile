import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/feedback/app_dialog.dart';
import 'package:kale/core/widgets/feedback/app_snackbar.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/logout_outcome.dart';

/// The account's main action: "Log out" for a permanent user, "Create an
/// account to save your data" for an anonymous one.
///
/// Anonymous users are never offered logout: with no email or social
/// identity linked, they could never sign back in, and their data would be
/// lost.
///
/// Logout backs up pending changes first. If some cannot be backed up,
/// the user must confirm losing them before logout goes ahead.
class AccountActionButton extends ConsumerStatefulWidget {
  /// Creates an [AccountActionButton].
  const AccountActionButton({super.key});

  @override
  ConsumerState<AccountActionButton> createState() =>
      _AccountActionButtonState();
}

class _AccountActionButtonState extends ConsumerState<AccountActionButton> {
  bool _loggingOut = false;

  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    final notifier = ref.read(authNotifierProvider.notifier);
    final LogoutOutcome outcome;
    try {
      // Backs up first, which can take a moment: show progress meanwhile.
      outcome = await notifier.logout();
    } finally {
      if (mounted) setState(() => _loggingOut = false);
    }
    if (!mounted) return;
    switch (outcome) {
      case LoggedOut():
        break;
      case LogoutBlocked(:final unsavedChanges):
        final l10n = context.l10n;
        final confirmed = await showAppDialog(
          context,
          title: l10n.logoutUnsavedTitle,
          message: l10n.logoutUnsavedMessage(unsavedChanges),
          confirmText: l10n.logoutUnsavedConfirm,
          cancelText: l10n.logoutUnsavedCancel,
          isDestructive: true,
        );
        if (confirmed ?? false) await notifier.discardChangesAndLogout();
      case LogoutFailed():
        showAppSnackBar(
          context,
          message: context.l10n.logoutFailed,
          variant: SnackBarVariant.error,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isAnonymous =
        authState is AuthAuthenticated && authState.user.isAnonymous;
    final colorScheme = context.colorScheme;

    if (isAnonymous) {
      return _ActionButton(
        icon: Icons.person_add_alt_outlined,
        label: context.l10n.anonymousSaveDataCta,
        background: colorScheme.primaryContainer,
        foreground: colorScheme.onPrimaryContainer,
        onTap: () => context.push(RouteNames.register),
      );
    }

    return _ActionButton(
      icon: Icons.logout_rounded,
      label: context.l10n.profileLogout,
      background: colorScheme.errorContainer,
      foreground: colorScheme.onErrorContainer,
      onTap: _loggingOut ? null : _logout,
      busy: _loggingOut,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  /// Shows a progress indicator in place of the icon.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: AppRadius.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              else
                Icon(icon, size: 20, color: foreground),
              AppSpacing.horizontalSm,
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
