/// Abstract environment configuration.
///
/// Holds only client-safe values: everything here is compiled into the app
/// binary and can be extracted from it. Server-only secrets (service-role
/// keys, push server keys, database passwords) must never be added here.
abstract class Env {
  /// Creates an [Env].
  const Env();

  /// Name of the environment: `development`, `staging` or `production`.
  String get name;

  /// Supabase project URL.
  String get baseUrl;

  /// Whether to enable verbose logging.
  bool get enableLogging;

  /// Whether to enable the debug overlay banner.
  bool get showDebugBanner;

  /// Supabase anon (public) key.
  String get supabaseAnonKey;

  /// Sentry DSN (client-safe). Empty when error reporting is not configured.
  String get sentryDsn;

  /// Google OAuth web client ID (the one Supabase verifies ID tokens against).
  String get googleWebClientId;

  /// Google OAuth iOS client ID.
  String get googleIosClientId;

  /// Google OAuth Android client ID.
  String get googleAndroidClientId;

  /// Use the in-memory auth datasource instead of Supabase.
  bool get useMockAuth;

  /// Use the in-memory transactions datasource instead of Supabase.
  bool get useMockTransactions;

  /// Use the in-memory budgets datasource instead of Supabase.
  bool get useMockBudgets;

  /// Use the in-memory savings datasource instead of Supabase.
  bool get useMockSavings;
}
