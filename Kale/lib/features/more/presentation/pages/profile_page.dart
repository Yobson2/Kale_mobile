import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/theme/theme_provider.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';
import 'package:kale/core/widgets/data_display/app_avatar.dart';
import 'package:kale/core/widgets/data_display/app_list_tile.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

/// Profile page displaying user info, theme toggle, and logout.
class ProfilePage extends ConsumerWidget {
  /// Creates a [ProfilePage].
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final l10n = context.l10n;

    final user = switch (authState) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };

    return Scaffold(
      appBar: AppAppBar(title: l10n.profileTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            children: [
              AppSpacing.verticalXl,
              // Avatar
              AppAvatar(
                imageUrl: user?.avatarUrl,
                name: user?.name ?? 'User',
                radius: 48,
              ),
              AppSpacing.verticalLg,
              // Name
              Text(
                user?.name ?? 'User',
                style: context.textTheme.headlineSmall,
              ),
              AppSpacing.verticalXs,
              // Email
              Text(
                user?.email ?? '',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalXxl,
              // Theme toggle
              AppListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                title: l10n.settingsTheme,
                subtitle: _themeLabel(themeMode, l10n),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (_) {
                    ref.read(themeModeNotifierProvider.notifier).toggle();
                  },
                ),
              ),
              AppSpacing.verticalMd,
              // Edit profile
              AppListTile(
                leading: const Icon(Icons.edit_outlined),
                title: l10n.profileEditProfile,
                trailing: const Icon(Icons.chevron_right),
              ),
              AppSpacing.verticalMd,
              // Change password
              AppListTile(
                leading: const Icon(Icons.lock_outline),
                title: l10n.profileChangePassword,
                trailing: const Icon(Icons.chevron_right),
              ),
              AppSpacing.verticalXxl,
              // Logout button
              AppPrimaryButton(
                text: l10n.profileLogout,
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
      ThemeMode.system => l10n.settingsThemeSystem,
    };
  }
}
