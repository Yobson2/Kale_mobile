import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/core/theme/app_radius.dart';
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
                name: user?.name ?? l10n.commonUser,
                radius: 48,
              ),
              AppSpacing.verticalLg,
              // Name
              Text(
                user?.name ?? l10n.commonUser,
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
              // Achievements section
              _AchievementsSection(),
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

/// Displays the user's achievement badges and level.
class _AchievementsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = AchievementService(ref.watch(localStorageProvider));
    final level = service.currentLevel;
    final unlockedCount = service.unlockedCount;
    final total = Achievement.values.length;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.profileAchievements,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: AppRadius.borderRadiusFull,
              ),
              child: Text(
                l10n.profileLevel(_levelLabel(level, l10n)),
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalXs,
        Text(
          l10n.profileBadgesUnlocked(unlockedCount, total),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalLg,
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: Achievement.values
              .map((a) => _BadgeIcon(
                    achievement: a,
                    isUnlocked: service.isUnlocked(a),
                    label: _achievementLabel(a, l10n),
                  ))
              .toList(),
        ),
      ],
    );
  }

  String _levelLabel(UserLevel level, AppLocalizations l10n) {
    return switch (level) {
      UserLevel.beginner => l10n.levelBeginner,
      UserLevel.explorer => l10n.levelExplorer,
      UserLevel.pro => l10n.levelPro,
      UserLevel.master => l10n.levelMaster,
    };
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

/// A single badge icon that is either unlocked (colorful) or locked (greyed).
class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({
    required this.achievement,
    required this.isUnlocked,
    required this.label,
  });

  final Achievement achievement;
  final bool isUnlocked;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement.color.withValues(alpha: 0.15)
                  : context.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked
                    ? achievement.color
                    : context.colorScheme.outlineVariant,
                width: 2,
              ),
            ),
            child: Icon(
              achievement.icon,
              color: isUnlocked
                  ? achievement.color
                  : context.colorScheme.outlineVariant,
              size: 24,
            ),
          ),
          AppSpacing.verticalXs,
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: isUnlocked
                  ? context.colorScheme.onSurface
                  : context.colorScheme.outlineVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
