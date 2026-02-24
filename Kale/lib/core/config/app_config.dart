import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kale/core/config/env.dart';

/// Development environment configuration.
class AppConfig extends Env {
  /// Creates a [AppConfig].
  const AppConfig();

  @override
  String get name => dotenv.get('ENV_NAME', fallback: 'development');

  @override
  String get baseUrl => dotenv.get('BASE_URL');

  @override
  bool get enableLogging =>
      dotenv.get('ENABLE_LOGGING', fallback: 'true') == 'true';

  @override
  bool get showDebugBanner =>
      dotenv.get('SHOW_DEBUG_BANNER', fallback: 'true') == 'true';

  @override
  String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY');

  @override
  String get sentryDsn => dotenv.get('SENTRY_DSN', fallback: '');

  @override
  String get fcmServerKey => dotenv.get('FCM_SERVER_KEY', fallback: '');

  @override
  String get googleWebClientId =>
      dotenv.get('GOOGLE_WEB_CLIENT_ID', fallback: '');

  @override
  String get googleIosClientId =>
      dotenv.get('GOOGLE_IOS_CLIENT_ID', fallback: '');

  @override
  String get googleAndroidClientId =>
      dotenv.get('GOOGLE_ANDROID_CLIENT_ID', fallback: '');
}
