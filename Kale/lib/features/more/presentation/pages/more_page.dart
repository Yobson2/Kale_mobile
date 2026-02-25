import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/app_list_tile.dart';
import 'package:kale/core/widgets/feedback/app_bottom_sheet.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';
import 'package:kale/core/widgets/layout/app_scaffold.dart';

/// More page with a list of menu items for navigation.
class MorePage extends StatelessWidget {
  /// Creates a [MorePage].
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppAppBar(
        title: 'More',
        showBackButton: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            AppListTile(
              leading: const Icon(Icons.person_outline),
              title: 'Profile',
              showDivider: true,
              onTap: () => context.goNamed(RouteNames.profileName),
            ),
            AppListTile(
              leading: const Icon(Icons.settings_outlined),
              title: 'Settings',
              showDivider: true,
              onTap: () => context.goNamed(RouteNames.settingsName),
            ),
            AppListTile(
              leading: const Icon(Icons.savings_outlined),
              title: 'Savings Goals',
              showDivider: true,
              onTap: () => context.goNamed(RouteNames.savingsGoalsName),
            ),
            AppListTile(
              leading: const Icon(Icons.group_outlined),
              title: 'Tontine Groups',
              trailing: _ComingSoonBadge(),
              showDivider: true,
              onTap: () => _showComingSoon(context, 'Tontine Groups'),
            ),
            AppListTile(
              leading: const Icon(Icons.insights_outlined),
              title: 'Insights',
              trailing: _ComingSoonBadge(),
              showDivider: true,
              onTap: () => _showComingSoon(context, 'Insights'),
            ),
            AppListTile(
              leading: const Icon(Icons.help_outline),
              title: 'Help & Support',
              showDivider: true,
              onTap: () => _showComingSoon(context, 'Help & Support'),
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
              'Coming soon! Stay tuned.',
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
        'Coming Soon',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
