import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

/// The account's main action: "Log out" for a permanent user, "Create an
/// account to save your data" for an anonymous one.
///
/// Anonymous users are never offered logout: with no email or social
/// identity linked, they could never sign back in, and their data would be
/// lost.
class AccountActionButton extends ConsumerWidget {
  /// Creates an [AccountActionButton].
  const AccountActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onTap: () => ref.read(authNotifierProvider.notifier).logout(),
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
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

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
