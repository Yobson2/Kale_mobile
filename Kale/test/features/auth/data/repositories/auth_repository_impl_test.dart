import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/sync/backup_status.dart';
import 'package:kale/features/auth/data/models/tokens_model.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:kale/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  late MockAppDatabase mockAppDatabase;
  late MockSyncEngine mockSyncEngine;

  setUpAll(() {
    registerFallbackValue(
      const UserModel(id: '', email: '', name: ''),
    );
    registerFallbackValue(
      const TokensModel(accessToken: '', refreshToken: ''),
    );
  });

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockAppDatabase = MockAppDatabase();
    mockSyncEngine = MockSyncEngine();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
      appDatabase: mockAppDatabase,
      syncEngine: mockSyncEngine,
      syncPuller: MockSyncPuller(),
    );
  });

  const tUserModel = UserModel(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  const tTokensModel = TokensModel(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
  );

  const tUser = User(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  group('login', () {
    test('should check if device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => (user: tUserModel, tokens: tTokensModel));
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
      when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});

      // Act
      await repository.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return User when remote call succeeds', () async {
        // Arrange
        when(
          () => mockRemote.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => (user: tUserModel, tokens: tTokensModel),
        );
        when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
        when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result, const Right<Failure, User>(tUser));
      });

      test('should return ServerFailure when remote call fails', () async {
        // Arrange
        when(
          () => mockRemote.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const ServerException(message: 'Invalid credentials'));

        // Act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return NetworkFailure', () async {
        // Act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        verifyZeroInteractions(mockRemote);
      });
    });
  });

  group('getCachedUser', () {
    test('should return cached user when available', () async {
      // Arrange
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, const Right<Failure, User>(tUser));
    });

    test('should return CacheFailure when no cached user', () async {
      // Arrange
      when(() => mockLocal.getCachedUser())
          .thenThrow(const CacheException(message: 'No cached user'));

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, isA<Left<Failure, User>>());
    });
  });

  group('signInAnonymously', () {
    const anonymousModel = UserModel(
      id: 'anon-1',
      email: '',
      name: '',
      isAnonymous: true,
    );

    test('returns an anonymous user and caches the session', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.signInAnonymously()).thenAnswer(
        (_) async => (user: anonymousModel, tokens: tTokensModel),
      );
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});
      when(() => mockLocal.cacheTokens(any())).thenAnswer((_) async {});

      final result = await repository.signInAnonymously();

      expect(
        result,
        const Right<Failure, User>(
          User(id: 'anon-1', email: '', name: '', isAnonymous: true),
        ),
      );
      verify(() => mockLocal.cacheUser(anonymousModel));
      verify(() => mockLocal.cacheTokens(tTokensModel));
    });

    test('maps a server error to ServerFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.signInAnonymously()).thenThrow(
        const ServerException(message: 'Too many requests', statusCode: 429),
      );

      final result = await repository.signInAnonymously();

      expect(
        result,
        const Left<Failure, User>(
          ServerFailure(message: 'Too many requests', statusCode: 429),
        ),
      );
    });

    test('returns NetworkFailure when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.signInAnonymously();

      expect(result, const Left<Failure, User>(NetworkFailure()));
      verifyNever(() => mockRemote.signInAnonymously());
    });
  });

  group('backUpPendingChanges', () {
    test('returns how many changes are still pending or stuck', () async {
      when(() => mockSyncEngine.backUpNow()).thenAnswer(
        (_) async => const BackupStatus(pendingCount: 2, stuckCount: 1),
      );

      final result = await repository.backUpPendingChanges();

      expect(result, const Right<Failure, int>(3));
    });

    test('maps an engine error to SyncFailure', () async {
      when(() => mockSyncEngine.backUpNow()).thenThrow(Exception('db closed'));

      final result = await repository.backUpPendingChanges();

      expect(result.isLeft(), isTrue);
      result.leftMap((f) => expect(f, isA<SyncFailure>()));
    });
  });

  group('logout', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocal.clearAll()).thenAnswer((_) async {});
      when(() => mockAppDatabase.clearAllData()).thenAnswer((_) async {});
      when(() => mockSyncEngine.onLocalDataCleared()).thenAnswer((_) async {});
    });

    test('wipes the phone even when the server sign-out fails', () async {
      when(() => mockRemote.logout())
          .thenThrow(const ServerException(message: 'Timeout'));

      final result = await repository.logout();

      expect(result, const Right<Failure, void>(null));
      verify(() => mockLocal.clearAll());
      verify(() => mockAppDatabase.clearAllData());
      verify(() => mockSyncEngine.onLocalDataCleared());
    });

    test('maps a failed wipe to CacheFailure', () async {
      when(() => mockRemote.logout()).thenAnswer((_) async {});
      when(() => mockAppDatabase.clearAllData())
          .thenThrow(Exception('disk full'));

      final result = await repository.logout();

      expect(result.isLeft(), isTrue);
      result.leftMap((f) => expect(f, isA<CacheFailure>()));
    });
  });
}
