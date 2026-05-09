import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// Notifications page showing budget alerts, savings milestones,
/// and daily reminders.
class NotificationsPage extends StatelessWidget {
  /// Creates a [NotificationsPage].
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: context.l10n.notificationsTitle),
      body: Stack(
        children: [
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 180,
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 20),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary
                            .withValues(alpha: 0.12),
                        borderRadius: AppRadius.borderRadiusXl,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 40,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    AppSpacing.verticalLg,
                    Text(
                      context.l10n.notificationsEmpty,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.verticalSm,
                    Text(
                      context.l10n.notificationsEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
