import 'package:kale/core/config/env.dart';

/// [Env] backed by compile-time defines.
///
/// Values come from `--dart-define-from-file=config/<environment>.json`
/// (see `docs/development.md`). Every value is compiled into the binary, so
/// define files must only contain client-safe values.
class AppConfig extends Env {
  /// Creates an [AppConfig].
  const AppConfig();

  static const _name = String.fromEnvironment(
    'ENV_NAME',
    defaultValue: 'development',
  );
  static const _baseUrl = String.fromEnvironment('BASE_URL');
  static const _enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  static const _showDebugBanner = bool.fromEnvironment(
    'SHOW_DEBUG_BANNER',
    defaultValue: true,
  );
  static const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const _sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const _googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  static const _googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );
  static const _googleAndroidClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_CLIENT_ID',
  );
  static const _useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH');
  static const _useMockTransactions = bool.fromEnvironment(
    'USE_MOCK_TRANSACTIONS',
  );
  static const _useMockBudgets = bool.fromEnvironment('USE_MOCK_BUDGETS');
  static const _useMockSavings = bool.fromEnvironment('USE_MOCK_SAVINGS');

  @override
  String get name => _name;

  @override
  String get baseUrl => _baseUrl;

  @override
  bool get enableLogging => _enableLogging;

  @override
  bool get showDebugBanner => _showDebugBanner;

  @override
  String get supabaseAnonKey => _supabaseAnonKey;

  @override
  String get sentryDsn => _sentryDsn;

  @override
  String get googleWebClientId => _googleWebClientId;

  @override
  String get googleIosClientId => _googleIosClientId;

  @override
  String get googleAndroidClientId => _googleAndroidClientId;

  @override
  bool get useMockAuth => _useMockAuth;

  @override
  bool get useMockTransactions => _useMockTransactions;

  @override
  bool get useMockBudgets => _useMockBudgets;

  @override
  bool get useMockSavings => _useMockSavings;
}
