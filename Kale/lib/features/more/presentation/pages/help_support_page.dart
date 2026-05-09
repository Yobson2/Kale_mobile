import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/router/route_names.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/data_display/geometric_k_watermark.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// Help & Support page with FAQ and contact options.
class HelpSupportPage extends StatelessWidget {
  /// Creates a [HelpSupportPage].
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: context.l10n.moreHelpSupport),
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
                  // FAQ section
                  Text(
                    context.l10n.helpFaqTitle,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalMd,

                  _FaqTile(
                    question: context.l10n.helpFaq1Question,
                    answer: context.l10n.helpFaq1Answer,
                  ),
                  _FaqTile(
                    question: context.l10n.helpFaq2Question,
                    answer: context.l10n.helpFaq2Answer,
                  ),
                  _FaqTile(
                    question: context.l10n.helpFaq3Question,
                    answer: context.l10n.helpFaq3Answer,
                  ),
                  _FaqTile(
                    question: context.l10n.helpFaq4Question,
                    answer: context.l10n.helpFaq4Answer,
                  ),
                  AppSpacing.verticalXl,

                  // Contact section
                  Text(
                    context.l10n.helpContactTitle,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalMd,

                  _ContactCard(
                    icon: Icons.email_outlined,
                    title: context.l10n.helpContactEmail,
                    subtitle: 'support@kale-app.com',
                  ),
                  AppSpacing.verticalSm,
                  _ContactCard(
                    icon: Icons.chat_outlined,
                    title: context.l10n.helpContactChat,
                    subtitle: context.l10n.helpContactChatSubtitle,
                  ),
                  AppSpacing.verticalXl,

                  // Legal section
                  Text(
                    context.l10n.helpLegalTitle,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalMd,

                  _ContactCard(
                    icon: Icons.description_outlined,
                    title: context.l10n.settingsTerms,
                    trailing: Icon(
                      Icons.open_in_new,
                      size: 20,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => context.push(RouteNames.termsOfService),
                  ),
                  AppSpacing.verticalSm,
                  _ContactCard(
                    icon: Icons.shield_outlined,
                    title: context.l10n.settingsPrivacy,
                    trailing: Icon(
                      Icons.open_in_new,
                      size: 20,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => context.push(RouteNames.privacyPolicy),
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

/// Expandable FAQ tile.
class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: context.colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
        title: Text(
          question,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Text(
              answer,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contact card with icon, title, and optional trailing.
class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainerLow,
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: context.colorScheme.primary,
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
