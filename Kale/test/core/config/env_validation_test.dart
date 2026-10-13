import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/config/env.dart';
import 'package:kale/core/config/env_validation.dart';

class _FakeEnv extends Env {
  const _FakeEnv({
    this.name = 'staging',
    this.baseUrl = 'https://staging-ref.supabase.co',
    this.supabaseAnonKey = 'anon-key',
  });

  @override
  final String name;
  @override
  final String baseUrl;
  @override
  final String supabaseAnonKey;
  @override
  bool get enableLogging => true;
  @override
  bool get showDebugBanner => true;
  @override
  String get sentryDsn => '';
  @override
  String get googleWebClientId => '';
  @override
  String get googleIosClientId => '';
  @override
  String get googleAndroidClientId => '';
  @override
  bool get useMockAuth => false;
  @override
  bool get useMockTransactions => false;
  @override
  bool get useMockBudgets => false;
  @override
  bool get useMockSavings => false;
}

void main() {
  group('envProblems', () {
    test('accepts a complete staging config on the staging flavor', () {
      expect(envProblems(const _FakeEnv(), appFlavor: 'staging'), isEmpty);
    });

    test('accepts a config when no flavor is set (tests, desktop)', () {
      expect(envProblems(const _FakeEnv()), isEmpty);
    });

    test('reports a missing Supabase URL and anon key', () {
      final problems = envProblems(
        const _FakeEnv(baseUrl: '', supabaseAnonKey: ''),
        appFlavor: 'staging',
      );

      expect(problems, hasLength(2));
      expect(problems.join(), contains('BASE_URL'));
      expect(problems.join(), contains('SUPABASE_ANON_KEY'));
    });

    test('rejects an unknown environment name', () {
      final problems = envProblems(const _FakeEnv(name: 'prod'));

      expect(problems.single, contains('ENV_NAME'));
    });

    test('rejects a non-production config on the production flavor', () {
      final problems = envProblems(
        const _FakeEnv(),
        appFlavor: 'production',
      );

      expect(problems.single, contains('production'));
    });

    test('rejects the production config on the staging flavor', () {
      final problems = envProblems(
        const _FakeEnv(name: 'production'),
        appFlavor: 'staging',
      );

      expect(problems.single, contains('production'));
    });

    test('ensureValidEnv throws with every problem listed', () {
      expect(
        () => ensureValidEnv(
          const _FakeEnv(baseUrl: ''),
          appFlavor: 'production',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(contains('BASE_URL'), contains('production')),
          ),
        ),
      );
    });

    test('accepts a development config on the staging flavor', () {
      expect(
        envProblems(const _FakeEnv(name: 'development'), appFlavor: 'staging'),
        isEmpty,
      );
    });
  });
}
