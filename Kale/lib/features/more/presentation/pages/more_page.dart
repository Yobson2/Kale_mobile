import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/app_list_tile.dart';
import 'package:kale/core/widgets/feedback/app_bottom_sheet.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';
import 'package:kale/core/widgets/layout/app_section_header.dart';

/// More page with grouped menu sections for navigation.
class MorePage extends StatelessWidget {
  /// Creates a [MorePage].
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: context.l10n.moreTitle,
        showBackButton: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // ── Section 1: Account ──────────────────────────────────
            Padding(
              padding: AppSpacing.paddingHorizontalLg,
              child: AppSectionHeader(
                title: context.l10n.moreAccountSection,
              ),
            ),
            AppListTile(
              leading: const Icon(Icons.person_outline),
              title: context.l10n.moreProfile,
              showDivider: true,
              onTap: () => context.goNamed(RouteNames.profileName),
            ),
            AppListTile(
              leading: const Icon(Icons.settings_outlined),
              title: context.l10n.moreSettings,
              showDivider: true,
              onTap: () => context.goNamed(RouteNames.settingsName),
            ),

            AppSpacing.verticalLg,

            // ── Section 2: Features ─────────────────────────────────
            Padding(
              padding: AppSpacing.paddingHorizontalLg,
              child: AppSectionHeader(
                title: context.l10n.moreFeaturesSection,
              ),
            ),
            AppListTile(
              leading: const Icon(Icons.savings_outlined),
              title: context.l10n.moreSavingsGoals,
              showDivider: true,
              onTap: () => context.goNamed(RouteNames.savingsGoalsName),
            ),
            AppListTile(
              leading: const Icon(Icons.group_outlined),
              title: context.l10n.moreTontineGroups,
              trailing: _ComingSoonBadge(),
              showDivider: true,
              onTap: () =>
                  _showComingSoon(context, context.l10n.moreTontineGroups),
            ),
            AppListTile(
              leading: const Icon(Icons.insights_outlined),
              title: context.l10n.moreInsights,
              trailing: _ComingSoonBadge(),
              showDivider: true,
              onTap: () => _showComingSoon(context, context.l10n.moreInsights),
            ),

            AppSpacing.verticalLg,

            // ── Section 3: Support ──────────────────────────────────
            Padding(
              padding: AppSpacing.paddingHorizontalLg,
              child: AppSectionHeader(
                title: context.l10n.moreSupportSection,
              ),
            ),
            AppListTile(
              leading: const Icon(Icons.help_outline),
              title: context.l10n.moreHelpSupport,
              showDivider: true,
              onTap: () =>
                  _showComingSoon(context, context.l10n.moreHelpSupport),
            ),
            AppListTile(
              leading: const Icon(Icons.star_outline),
              title: context.l10n.moreRateApp,
              showDivider: true,
              onTap: () => _showComingSoon(context, context.l10n.moreRateApp),
            ),
            AppListTile(
              leading: const Icon(Icons.share_outlined),
              title: context.l10n.moreShareApp,
              showDivider: true,
              onTap: () => _showComingSoon(context, context.l10n.moreShareApp),
            ),
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

class _ComingSoonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        context.l10n.moreComingSoon,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
