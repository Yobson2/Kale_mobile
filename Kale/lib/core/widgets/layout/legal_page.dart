import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_spacing.dart';
import 'package:kale/core/widgets/layout/app_app_bar.dart';

/// A section within a legal document (heading + body text).
class LegalSection {
  /// Creates a [LegalSection].
  const LegalSection({required this.heading, required this.body});

  /// Section heading displayed in primary-colored titleSmall style.
  final String heading;

  /// Section body displayed in bodyMedium style.
  final String body;
}

/// Reusable scaffold for legal document pages (Terms of Service, Privacy
/// Policy, etc.).
///
/// Renders a scrollable page with an [AppAppBar], a last-updated date,
/// and a list of [LegalSection]s.
class LegalPage extends StatelessWidget {
  /// Creates a [LegalPage].
  const LegalPage({
    required this.title,
    required this.lastUpdated,
    required this.sections,
    this.footer,
    super.key,
  });

  /// Page title shown in the app bar.
  final String title;

  /// "Last updated" date string shown at the top.
  final String lastUpdated;

  /// Ordered list of content sections.
  final List<LegalSection> sections;

  /// Optional footer text (e.g. contact information).
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppAppBar(title: title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lastUpdated,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalXl,
              for (final section in sections) ...[
                Text(
                  section.heading,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSpacing.verticalSm,
                Text(
                  section.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
                AppSpacing.verticalXl,
              ],
              if (footer != null) ...[
                const SizedBox(height: 16),
                AppSpacing.verticalLg,
                Text(
                  footer!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                AppSpacing.verticalXl,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
