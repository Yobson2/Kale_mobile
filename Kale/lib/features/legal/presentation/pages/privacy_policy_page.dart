import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/widgets/layout/legal_page.dart';

/// Displays the Kalé Privacy Policy.
class PrivacyPolicyPage extends StatelessWidget {
  /// Creates a [PrivacyPolicyPage].
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LegalPage(
      title: l10n.legalPrivacyTitle,
      lastUpdated: l10n.legalLastUpdated,
      footer: l10n.legalContactFooter,
      sections: [
        LegalSection(
          heading: l10n.legalPrivacyIntroHeading,
          body: l10n.legalPrivacyIntroBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyCollectionHeading,
          body: l10n.legalPrivacyCollectionBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyUsageHeading,
          body: l10n.legalPrivacyUsageBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyStorageHeading,
          body: l10n.legalPrivacyStorageBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyThirdPartyHeading,
          body: l10n.legalPrivacyThirdPartyBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyRightsHeading,
          body: l10n.legalPrivacyRightsBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyRetentionHeading,
          body: l10n.legalPrivacyRetentionBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyChildrenHeading,
          body: l10n.legalPrivacyChildrenBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyChangesHeading,
          body: l10n.legalPrivacyChangesBody,
        ),
        LegalSection(
          heading: l10n.legalPrivacyContactHeading,
          body: l10n.legalPrivacyContactBody,
        ),
      ],
    );
  }
}
