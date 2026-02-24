import 'package:flutter/material.dart';
import 'package:kale/core/extensions/context_extensions.dart';
import 'package:kale/core/widgets/layout/legal_page.dart';

/// Displays the Kalé Terms of Service.
class TermsOfServicePage extends StatelessWidget {
  /// Creates a [TermsOfServicePage].
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LegalPage(
      title: l10n.legalTosTitle,
      lastUpdated: l10n.legalLastUpdated,
      footer: l10n.legalContactFooter,
      sections: [
        LegalSection(
          heading: l10n.legalTosIntroHeading,
          body: l10n.legalTosIntroBody,
        ),
        LegalSection(
          heading: l10n.legalTosAccountHeading,
          body: l10n.legalTosAccountBody,
        ),
        LegalSection(
          heading: l10n.legalTosServicesHeading,
          body: l10n.legalTosServicesBody,
        ),
        LegalSection(
          heading: l10n.legalTosResponsibilitiesHeading,
          body: l10n.legalTosResponsibilitiesBody,
        ),
        LegalSection(
          heading: l10n.legalTosFinancialDataHeading,
          body: l10n.legalTosFinancialDataBody,
        ),
        LegalSection(
          heading: l10n.legalTosIpHeading,
          body: l10n.legalTosIpBody,
        ),
        LegalSection(
          heading: l10n.legalTosLiabilityHeading,
          body: l10n.legalTosLiabilityBody,
        ),
        LegalSection(
          heading: l10n.legalTosTerminationHeading,
          body: l10n.legalTosTerminationBody,
        ),
        LegalSection(
          heading: l10n.legalTosChangesHeading,
          body: l10n.legalTosChangesBody,
        ),
        LegalSection(
          heading: l10n.legalTosContactHeading,
          body: l10n.legalTosContactBody,
        ),
      ],
    );
  }
}
