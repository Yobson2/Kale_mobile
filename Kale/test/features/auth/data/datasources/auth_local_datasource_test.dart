import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/storage/local_storage.dart';
import 'package:kale/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late AuthLocalDataSourceImpl local;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    local = AuthLocalDataSourceImpl(
      secureStorage: MockSecureStorage(),
      localStorage: LocalStorage(await SharedPreferences.getInstance()),
    );
  });

  test('a cached anonymous user is still anonymous on the next launch',
      () async {
    const anonymous = UserModel(
      id: 'anon-1',
      email: '',
      name: '',
      isAnonymous: true,
    );

    await local.cacheUser(anonymous);

    expect(await local.getCachedUser(), anonymous);
  });

  test('a user cached before the anonymous flag existed is permanent',
      () async {
    SharedPreferences.setMockInitialValues({
      'cached_user': '{"id":"u-1","email":"a@b.co","name":"Ama"}',
    });
    local = AuthLocalDataSourceImpl(
      secureStorage: MockSecureStorage(),
      localStorage: LocalStorage(await SharedPreferences.getInstance()),
    );

    final user = await local.getCachedUser();

    expect(user.isAnonymous, isFalse);
  });

  test(
      "clearing forgets the user's session and progress, not the device's "
      'settings', () async {
    SharedPreferences.setMockInitialValues({
      'cached_user': '{"id":"u-1","email":"a@b.co","name":"Ama"}',
      'streak_count': '12',
      'streak_last_date': '2026-10-13',
      'achievement_firstTransaction': true,
      'theme_mode': 'dark',
      'onboarding_complete': true,
    });
    final secureStorage = MockSecureStorage();
    when(secureStorage.clearTokens).thenAnswer((_) async {});
    final prefs = await SharedPreferences.getInstance();
    local = AuthLocalDataSourceImpl(
      secureStorage: secureStorage,
      localStorage: LocalStorage(prefs),
    );

    await local.clearAll();

    expect(prefs.getKeys(), {'theme_mode', 'onboarding_complete'});
    await expectLater(local.getCachedUser(), throwsA(isA<CacheException>()));
  });
}
