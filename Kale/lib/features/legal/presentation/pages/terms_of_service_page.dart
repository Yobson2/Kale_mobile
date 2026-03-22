import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/theme/app_radius.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/buttons/app_primary_button.dart';

/// Displays the Kalé Terms of Service with numbered badges,
/// quote blocks, and accept CTA per the Digital Loom design.
class TermsOfServicePage extends StatelessWidget {
  /// Creates a [TermsOfServicePage].
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        title: SvgPicture.asset(
          isDark ? 'assets/images/logo-dark.svg' : 'assets/images/logo.svg',
          height: 28,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editorial title
                  Text(
                    l10n.legalTosTitle,
                    style: context.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalSm,
                  Text(
                    '— ${l10n.legalLastUpdated.toUpperCase()} —',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.65,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.verticalXl,

                  // 01 — Introduction
                  _NumberedSection(
                    number: '01',
                    title: l10n.legalTosIntroHeading,
                    body: l10n.legalTosIntroBody,
                  ),

                  // 02 — Account Registration
                  _NumberedSection(
                    number: '02',
                    title: l10n.legalTosAccountHeading,
                    body: l10n.legalTosAccountBody,
                    quoteText:
                        '"Users are responsible for safeguarding their '
                        'passwords and for any activities or actions under '
                        'their account."',
                  ),

                  // 03 — Privacy
                  _NumberedSection(
                    number: '03',
                    title: l10n.legalTosServicesHeading,
                    body: l10n.legalTosServicesBody,
                    features: const [
                      'Biometric authentication support',
                      'End-to-end data encryption at rest',
                    ],
                  ),

                  // 04 — Data Usage
                  _NumberedSection(
                    number: '04',
                    title: l10n.legalTosFinancialDataHeading,
                    body: l10n.legalTosFinancialDataBody,
                    complianceNotice: 'Kalé complies with global data '
                        'protection standards, ensuring your information is '
                        'treated with the highest level of regulatory care.',
                  ),

                  AppSpacing.verticalXl,
                ],
              ),
            ),
          ),

          // Bottom CTA section
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              children: [
                AppPrimaryButton(
                  text: 'I Accept the Terms',
                  onPressed: () => Navigator.pop(context),
                ),
                AppSpacing.verticalMd,
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Download PDF',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                AppSpacing.verticalSm,
                Text(
                  l10n.legalContactFooter,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A numbered section with green badge, title, body, and optional
/// quote block, feature bullets, or compliance notice.
class _NumberedSection extends StatelessWidget {
  const _NumberedSection({
    required this.number,
    required this.title,
    required this.body,
    this.quoteText,
    this.features,
    this.complianceNotice,
  });

  final String number;
  final String title;
  final String body;
  final String? quoteText;
  final List<String>? features;
  final String? complianceNotice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppSpacing.verticalMd,

          // Section title
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSm,

          // Body text
          Text(
            body,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),

          // Quote block
          if (quoteText != null) ...[
            AppSpacing.verticalLg,
            Container(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
                right: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: context.colorScheme.primary,
                    width: 3,
                  ),
                ),
                color: context.colorScheme.surfaceContainerLow,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                quoteText!,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          ],

          // Feature bullets
          if (features != null) ...[
            AppSpacing.verticalLg,
            for (final feature in features!)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: context.colorScheme.primary,
                    ),
                    AppSpacing.horizontalMd,
                    Expanded(
                      child: Text(
                        feature,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
          ],

          // Compliance notice
          if (complianceNotice != null) ...[
            AppSpacing.verticalLg,
            Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerLow,
                borderRadius: AppRadius.borderRadiusMd,
                border: Border.all(
                  color:
                      context.colorScheme.outlineVariant.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOTICE OF COMPLIANCE',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.65,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  AppSpacing.verticalSm,
                  Text(
                    complianceNotice!,
                    style: context.textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
