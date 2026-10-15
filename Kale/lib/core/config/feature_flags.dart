import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flags.g.dart';

/// Which features this build shows (decisions Q5, Q16, Q20).
///
/// v1 only shows what works: unfinished features stay in the code behind a
/// flag that is off. The paywall-ready flags gate features that may become
/// paid later; a feature that is free for everyone simply has its flag on.
///
/// Defaults are compiled in and can be changed per build with
/// `--dart-define=FEATURE_<NAME>=true|false`. Every flag is read through
/// [featureFlagsProvider], so tests can override them.
@immutable
class FeatureFlags {
  /// Creates [FeatureFlags]. The defaults are this build's: v1's, unless a
  /// define overrides one.
  const FeatureFlags({
    this.tontineEnabled = const bool.fromEnvironment('FEATURE_TONTINE'),
    this.gamificationEnabled = const bool.fromEnvironment(
      'FEATURE_GAMIFICATION',
    ),
    this.csvExportEnabled = const bool.fromEnvironment(
      'FEATURE_CSV_EXPORT',
      defaultValue: true,
    ),
    this.pdfStatementsEnabled = const bool.fromEnvironment(
      'FEATURE_PDF_STATEMENTS',
    ),
    this.insightsExportEnabled = const bool.fromEnvironment(
      'FEATURE_INSIGHTS_EXPORT',
    ),
  });

  /// Tontine groups (Q5, Q24: out of v1). Off: the More entry says "Coming
  /// soon" and the tontine page can't be opened.
  final bool tontineEnabled;

  /// Streaks, achievements and levels (Q5; owner's decision on #52: flagged
  /// off for v1). Off: none of it is shown, and nothing records it.
  final bool gamificationEnabled;

  /// CSV export of transactions (Q20: free for everyone in v1).
  final bool csvExportEnabled;

  /// PDF statements (Q16: paywall-ready; not built yet).
  final bool pdfStatementsEnabled;

  /// Insights export (Q16: paywall-ready; not built yet).
  final bool insightsExportEnabled;

  @override
  bool operator ==(Object other) =>
      other is FeatureFlags &&
      other.tontineEnabled == tontineEnabled &&
      other.gamificationEnabled == gamificationEnabled &&
      other.csvExportEnabled == csvExportEnabled &&
      other.pdfStatementsEnabled == pdfStatementsEnabled &&
      other.insightsExportEnabled == insightsExportEnabled;

  @override
  int get hashCode => Object.hash(
        tontineEnabled,
        gamificationEnabled,
        csvExportEnabled,
        pdfStatementsEnabled,
        insightsExportEnabled,
      );
}

/// The feature flags of this build. Override in tests.
@Riverpod(keepAlive: true)
FeatureFlags featureFlags(Ref ref) => const FeatureFlags();
