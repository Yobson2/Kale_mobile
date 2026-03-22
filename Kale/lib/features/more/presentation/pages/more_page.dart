import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/app_avatar.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/feedback/app_bottom_sheet.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';

/// More page with gradient profile card and grouped menu sections.
class MorePage extends ConsumerWidget {
  /// Creates a [MorePage].
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = switch (authState) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingLg,
          children: [
            // Header: hamburger + Kale branding + avatar
            Row(
              children: [
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/logo-dark.svg'
                      : 'assets/images/logo.svg',
                  height: 28,
                ),
                const Spacer(),
                AppAvatar(
                  imageUrl: user?.avatarUrl,
                  name: user?.name ?? context.l10n.commonUser,
                  radius: 18,
                ),
              ],
            ),
            AppSpacing.verticalLg,

            // Gradient profile card
            _ProfileCard(
              name: user?.name ?? context.l10n.commonUser,
              avatarUrl: user?.avatarUrl,
              isDark: isDark,
              onTap: () => context.goNamed(RouteNames.profileName),
            ),
            AppSpacing.verticalXl,

            // ── ACCOUNT section ──
            _SectionLabel(label: context.l10n.moreAccountSection),
            AppSpacing.verticalSm,
            _MenuItem(
              icon: Icons.person_outline,
              title: context.l10n.moreProfile,
              onTap: () => context.goNamed(RouteNames.profileName),
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              title: context.l10n.moreSettings,
              onTap: () => context.goNamed(RouteNames.settingsName),
            ),
            AppSpacing.verticalLg,

            // ── FEATURES section ──
            _SectionLabel(label: context.l10n.moreFeaturesSection),
            AppSpacing.verticalSm,
            _MenuItem(
              icon: Icons.savings_outlined,
              title: context.l10n.moreSavingsGoals,
              onTap: () => context.goNamed(RouteNames.savingsGoalsName),
            ),
            _MenuItem(
              icon: Icons.group_outlined,
              title: context.l10n.moreTontineGroups,
              trailing: _ComingSoonBadge(),
              onTap: () =>
                  _showComingSoon(context, context.l10n.moreTontineGroups),
            ),
            _MenuItem(
              icon: Icons.insights_outlined,
              title: context.l10n.moreInsights,
              onTap: () => context.goNamed(RouteNames.insightsName),
            ),
            AppSpacing.verticalLg,

            // ── SUPPORT section ──
            _SectionLabel(label: context.l10n.moreSupportSection),
            AppSpacing.verticalSm,
            _MenuItem(
              icon: Icons.help_outline,
              title: context.l10n.moreHelpSupport,
              onTap: () =>
                  _showComingSoon(context, context.l10n.moreHelpSupport),
            ),
            _MenuItem(
              icon: Icons.star_outline,
              title: context.l10n.moreRateApp,
              onTap: () =>
                  _showComingSoon(context, context.l10n.moreRateApp),
            ),
            _MenuItem(
              icon: Icons.share_outlined,
              title: context.l10n.moreShareApp,
              onTap: () =>
                  _showComingSoon(context, context.l10n.moreShareApp),
            ),
            AppSpacing.verticalXl,

            // Logout button
            _LogoutButton(
              label: context.l10n.profileLogout,
              onTap: () {
                ref.read(authNotifierProvider.notifier).logout();
              },
            ),
            AppSpacing.verticalLg,
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showAppBottomSheet<void>(
      context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            AppSpacing.verticalLg,
            Text(feature, style: theme.textTheme.titleMedium),
            AppSpacing.verticalSm,
            Text(
              ctx.l10n.moreComingSoonMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalXl,
          ],
        );
      },
    );
  }
}

/// Gradient profile card with K watermark.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.isDark,
    required this.onTap,
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadius.borderRadiusLg,
        child: Container(
          padding: AppSpacing.paddingLg,
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.primaryGradientDark
                : AppColors.primaryGradientLight,
            borderRadius: AppRadius.borderRadiusLg,
          ),
          child: Stack(
            children: [
              const GeometricKWatermark(
                opacity: 0.05,
                fontSize: 120,
                alignment: Alignment.topRight,
                offset: Offset(20, -15),
              ),
              Row(
                children: [
                  AppAvatar(
                    imageUrl: avatarUrl,
                    name: name,
                    radius: 28,
                  ),
                  AppSpacing.horizontalLg,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AppSpacing.verticalXs,
                        Text(
                          'Premium Member',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Uppercase section label.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.65,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Menu item with icon, title, optional trailing, and chevron.
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: colorScheme.surfaceContainerLow,
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
              children: [
                Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
                AppSpacing.horizontalMd,
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                if (trailing != null) ...[
                  trailing!,
                  AppSpacing.horizontalSm,
                ],
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Coming Soon badge using tertiaryContainer.
class _ComingSoonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        context.l10n.moreComingSoon,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
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
