import 'package:kale/core/config/env.dart';

/// Environment names accepted in `ENV_NAME`.
const knownEnvNames = {'development', 'staging', 'production'};

/// Returns the configuration problems of [env], or an empty list.
///
/// [appFlavor] is the native build flavor (`staging` or `production`), or
/// null when the app was built without one (tests, desktop). The production
/// flavor must run with the production define file, and only with it, so a
/// staging build can never talk to the production project and vice versa.
List<String> envProblems(Env env, {String? appFlavor}) {
  final problems = <String>[];

  if (!knownEnvNames.contains(env.name)) {
    problems.add(
      'ENV_NAME is "${env.name}"; expected one of ${knownEnvNames.join(', ')}.',
    );
  }
  if (env.baseUrl.isEmpty) {
    problems.add('BASE_URL is empty.');
  }
  if (env.supabaseAnonKey.isEmpty) {
    problems.add('SUPABASE_ANON_KEY is empty.');
  }

  if (appFlavor != null) {
    final isProdFlavor = appFlavor == 'production';
    final isProdConfig = env.name == 'production';
    if (isProdFlavor != isProdConfig) {
      problems.add(
        'The "$appFlavor" flavor cannot run with ENV_NAME "${env.name}": '
        'the production flavor requires config/production.json, and '
        'config/production.json requires the production flavor.',
      );
    }
  }

  return problems;
}

/// Throws a [StateError] listing every problem when [env] is misconfigured.
void ensureValidEnv(Env env, {required String? appFlavor}) {
  final problems = envProblems(env, appFlavor: appFlavor);
  if (problems.isEmpty) return;
  throw StateError(
    'Invalid environment configuration. Run with '
    '--flavor <staging|production> '
    '--dart-define-from-file=config/<environment>.json '
    '(see docs/development.md).\n- ${problems.join('\n- ')}',
  );
}
