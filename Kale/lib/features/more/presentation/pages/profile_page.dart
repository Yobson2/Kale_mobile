import 'package:flutter/material.dart';
import 'package:kale/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/theme/theme_provider.dart';
import 'package:kale/core/widgets/data_display/app_avatar.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

/// Profile page displaying user info, achievements bento grid, and logout.
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

    final service = AchievementService(ref.watch(localStorageProvider));
    final level = service.currentLevel;

    return Scaffold(
      appBar: AppAppBar(title: l10n.profileTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            children: [
              AppSpacing.verticalXl,
              // Avatar with border
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: AppAvatar(
                  imageUrl: user?.avatarUrl,
                  name: user?.name ?? l10n.commonUser,
                  radius: 48,
                ),
              ),
              AppSpacing.verticalMd,
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: AppRadius.borderRadiusFull,
                ),
                child: Text(
                  _levelLabel(level, l10n).toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onPrimary,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              AppSpacing.verticalMd,
              // Name (editorial)
              Text(
                user?.name ?? l10n.commonUser,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.verticalXs,
              // Email / member since
              Text(
                user?.email ?? '',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalXxl,

              // Achievements bento grid
              _AchievementsBento(service: service, l10n: l10n),
              AppSpacing.verticalXxl,

              // Appearance toggle
              _SettingsTile(
                icon: themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                title: l10n.settingsTheme,
                subtitle: _themeLabel(themeMode, l10n),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (_) {
                    ref.read(themeModeNotifierProvider.notifier).toggle();
                  },
                ),
              ),
              AppSpacing.verticalSm,

              // Account details
              _SettingsTile(
                icon: Icons.edit_outlined,
                title: l10n.profileEditProfile,
                trailing: Icon(
                  Icons.chevron_right,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalSm,
              _SettingsTile(
                icon: Icons.lock_outline,
                title: l10n.profileChangePassword,
                trailing: Icon(
                  Icons.chevron_right,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalXxl,

              // Logout button
              _LogoutButton(
                label: l10n.profileLogout,
                onTap: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ),
              AppSpacing.verticalXl,
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

  String _levelLabel(UserLevel level, AppLocalizations l10n) {
    return switch (level) {
      UserLevel.beginner => l10n.levelBeginner,
      UserLevel.explorer => l10n.levelExplorer,
      UserLevel.pro => l10n.levelPro,
      UserLevel.master => l10n.levelMaster,
    };
  }
}

/// Achievements displayed in a 2-column bento grid layout.
class _AchievementsBento extends StatelessWidget {
  const _AchievementsBento({
    required this.service,
    required this.l10n,
  });

  final AchievementService service;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final unlockedCount = service.unlockedCount;
    final total = Achievement.values.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.profileAchievements.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.65,
              ),
            ),
            const Spacer(),
            Text(
              '$unlockedCount / $total',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalMd,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.4,
          children: [
            ...Achievement.values.map((a) {
              final isUnlocked = service.isUnlocked(a);
              return _AchievementCell(
                achievement: a,
                isUnlocked: isUnlocked,
                label: _achievementLabel(a, l10n),
              );
            }),
            // "More soon" cell
            _MoreSoonCell(),
          ],
        ),
      ],
    );
  }

  String _achievementLabel(Achievement a, AppLocalizations l10n) {
    return switch (a) {
      Achievement.firstTransaction => l10n.achievementFirstTransaction,
      Achievement.streak7 => l10n.achievementStreak7,
      Achievement.streak30 => l10n.achievementStreak30,
      Achievement.firstBudget => l10n.achievementFirstBudget,
      Achievement.underBudget => l10n.achievementUnderBudget,
      Achievement.firstGoalCompleted => l10n.achievementFirstGoalCompleted,
      Achievement.transactions100 => l10n.achievementTransactions100,
    };
  }
}

/// A single achievement cell in the bento grid.
class _AchievementCell extends StatelessWidget {
  const _AchievementCell({
    required this.achievement,
    required this.isUnlocked,
    required this.label,
  });

  final Achievement achievement;
  final bool isUnlocked;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUnlocked
            ? achievement.color.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement.icon,
            color: isUnlocked
                ? achievement.color
                : colorScheme.outlineVariant,
            size: 28,
          ),
          AppSpacing.verticalSm,
          Text(
            label.toUpperCase(),
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: isUnlocked
                  ? colorScheme.onSurface
                  : colorScheme.outlineVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isUnlocked)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Locked',
                style: context.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outlineVariant,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Dashed-border "More Soon" placeholder cell.
class _MoreSoonCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.more_horiz,
            color: colorScheme.outlineVariant,
            size: 28,
          ),
          AppSpacing.verticalSm,
          Text(
            'MORE SOON',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings tile with surfaceContainerLow background.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: context.colorScheme.onSurfaceVariant),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.bodyLarge),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Logout button with error container styling.
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.errorContainer,
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
              Icon(
                Icons.logout_rounded,
                size: 20,
                color: colorScheme.onErrorContainer,
              ),
              AppSpacing.horizontalSm,
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
