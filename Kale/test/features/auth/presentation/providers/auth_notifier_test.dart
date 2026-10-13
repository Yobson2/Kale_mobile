import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/login_usecase.dart';
import 'package:kale/features/auth/domain/usecases/register_usecase.dart';
import 'package:kale/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:kale/features/auth/presentation/providers/auth_notifier.dart';
import 'package:kale/features/auth/presentation/providers/auth_providers.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCachedUserUseCase mockGetCachedUserUseCase;
  late MockSignInAnonymouslyUseCase mockSignInAnonymouslyUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCachedUserUseCase = MockGetCachedUserUseCase();
    mockSignInAnonymouslyUseCase = MockSignInAnonymouslyUseCase();
  });

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: '', password: ''),
    );
    registerFallbackValue(
      const RegisterParams(name: '', email: '', password: ''),
    );
    registerFallbackValue(
      const ForgotPasswordParams(email: ''),
    );
    registerFallbackValue(
      const VerifyOtpParams(email: '', code: ''),
    );
    registerFallbackValue(const NoParams());
  });

  const tUser = User(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
        registerUseCaseProvider.overrideWithValue(mockRegisterUseCase),
        forgotPasswordUseCaseProvider
            .overrideWithValue(mockForgotPasswordUseCase),
        verifyOtpUseCaseProvider.overrideWithValue(mockVerifyOtpUseCase),
        logoutUseCaseProvider.overrideWithValue(mockLogoutUseCase),
        getCachedUserUseCaseProvider
            .overrideWithValue(mockGetCachedUserUseCase),
        signInAnonymouslyUseCaseProvider
            .overrideWithValue(mockSignInAnonymouslyUseCase),
      ],
    );
  }

  const tAnonymousUser = User(
    id: 'anon-1',
    email: '',
    name: '',
    isAnonymous: true,
  );

  group('AuthNotifier', () {
    test('initial state should be AuthInitial', () {
      final container = createContainer();

      final state = container.read(authNotifierProvider);

      expect(state, isA<AuthInitial>());
    });

    test('login should update state to AuthAuthenticated on success', () async {
      // Arrange
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      // Act
      await notifier.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthAuthenticated>());
      expect((state as AuthAuthenticated).user, tUser);
    });

    test('login should update state to AuthError on failure', () async {
      // Arrange
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      // Act
      await notifier.login(
        email: 'test@example.com',
        password: 'wrong',
      );

      // Assert
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthError>());
    });

    test('logout should update state to AuthUnauthenticated', () async {
      // Arrange
      when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      final notifier = container.read(authNotifierProvider.notifier);

      // Act
      await notifier.logout();

      // Assert
      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthUnauthenticated>());
    });
  });

  group('AuthNotifier.restoreSession', () {
    test('a fresh install signs in anonymously and is authenticated', () async {
      when(() => mockGetCachedUserUseCase(any())).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'No cached user')),
      );
      when(() => mockSignInAnonymouslyUseCase(any()))
          .thenAnswer((_) async => const Right(tAnonymousUser));
      final container = createContainer();

      await container.read(authNotifierProvider.notifier).restoreSession();

      final state = container.read(authNotifierProvider);
      expect(state, const AuthState.authenticated(tAnonymousUser));
      expect((state as AuthAuthenticated).user.isAnonymous, isTrue);
    });

    test('a returning anonymous user keeps their session', () async {
      when(() => mockGetCachedUserUseCase(any()))
          .thenAnswer((_) async => const Right(tAnonymousUser));
      final container = createContainer();

      await container.read(authNotifierProvider.notifier).restoreSession();

      expect(
        container.read(authNotifierProvider),
        const AuthState.authenticated(tAnonymousUser),
      );
      verifyNever(() => mockSignInAnonymouslyUseCase(any()));
    });

    test('a returning permanent user keeps their session', () async {
      when(() => mockGetCachedUserUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));
      final container = createContainer();

      await container.read(authNotifierProvider.notifier).restoreSession();

      expect(
        container.read(authNotifierProvider),
        const AuthState.authenticated(tUser),
      );
      verifyNever(() => mockSignInAnonymouslyUseCase(any()));
    });

    test('if anonymous sign-in fails, the user is unauthenticated', () async {
      when(() => mockGetCachedUserUseCase(any())).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'No cached user')),
      );
      when(() => mockSignInAnonymouslyUseCase(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      final container = createContainer();

      await container.read(authNotifierProvider.notifier).restoreSession();

      expect(container.read(authNotifierProvider), isA<AuthUnauthenticated>());
    });
  });

  group('AuthNotifier.signInAnonymously', () {
    test('starts an anonymous session', () async {
      when(() => mockSignInAnonymouslyUseCase(any()))
          .thenAnswer((_) async => const Right(tAnonymousUser));
      final container = createContainer();

      final started = await container
          .read(authNotifierProvider.notifier)
          .signInAnonymously();

      expect(started, isTrue);
      expect(
        container.read(authNotifierProvider),
        const AuthState.authenticated(tAnonymousUser),
      );
    });

    test('reports a failure as an error', () async {
      when(() => mockSignInAnonymouslyUseCase(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      final container = createContainer();

      final started = await container
          .read(authNotifierProvider.notifier)
          .signInAnonymously();

      expect(started, isFalse);
      expect(container.read(authNotifierProvider), isA<AuthError>());
    });
  });
}
