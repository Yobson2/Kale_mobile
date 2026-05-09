import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_colors.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// Tontine Groups page — community savings groups.
class TontineGroupsPage extends StatelessWidget {
  /// Creates a [TontineGroupsPage].
  const TontineGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(title: context.l10n.moreTontineGroups),
      body: Stack(
        children: [
          const GeometricKWatermark(
            opacity: 0.03,
            fontSize: 180,
            alignment: Alignment.bottomCenter,
            offset: Offset(0, 20),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero card
                  ClipRRect(
                    borderRadius: AppRadius.borderRadiusLg,
                    child: Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingXl,
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? AppColors.primaryGradientDark
                            : AppColors.primaryGradientLight,
                        borderRadius: AppRadius.borderRadiusLg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.group_outlined,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          AppSpacing.verticalMd,
                          Text(
                            context.l10n.tontineGroupsTitle,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          AppSpacing.verticalSm,
                          Text(
                            context.l10n.tontineGroupsDescription,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.verticalXl,

                  // How it works section
                  Text(
                    context.l10n.tontineGroupsHowItWorks,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalMd,

                  _StepCard(
                    step: '1',
                    title: context.l10n.tontineGroupsStep1Title,
                    description: context.l10n.tontineGroupsStep1Desc,
                    icon: Icons.group_add_outlined,
                  ),
                  AppSpacing.verticalSm,
                  _StepCard(
                    step: '2',
                    title: context.l10n.tontineGroupsStep2Title,
                    description: context.l10n.tontineGroupsStep2Desc,
                    icon: Icons.savings_outlined,
                  ),
                  AppSpacing.verticalSm,
                  _StepCard(
                    step: '3',
                    title: context.l10n.tontineGroupsStep3Title,
                    description: context.l10n.tontineGroupsStep3Desc,
                    icon: Icons.celebration_outlined,
                  ),
                  AppSpacing.verticalXxl,

                  // Empty state CTA
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 64,
                          color: context.colorScheme.outline,
                        ),
                        AppSpacing.verticalMd,
                        Text(
                          context.l10n.tontineGroupsEmpty,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.verticalSm,
                        Text(
                          context.l10n.tontineGroupsEmptySubtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.verticalLg,
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: Text(context.l10n.tontineGroupsCreateGroup),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalXxl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Step card for the "How it works" section.
class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String step;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Center(
              child: Text(
                step,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
