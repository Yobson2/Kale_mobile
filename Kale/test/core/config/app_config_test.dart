import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/config/app_config.dart';

void main() {
  // Tests run without --dart-define-from-file, so these are the defaults a
  // build gets for every key its define file omits.
  group('AppConfig defaults', () {
    const config = AppConfig();

    test('every mock datasource is off', () {
      expect(config.useMockAuth, isFalse);
      expect(config.useMockTransactions, isFalse);
      expect(config.useMockBudgets, isFalse);
      expect(config.useMockSavings, isFalse);
    });

    test('no backend is configured', () {
      expect(config.baseUrl, isEmpty);
      expect(config.supabaseAnonKey, isEmpty);
      expect(config.name, 'development');
    });
  });
}
