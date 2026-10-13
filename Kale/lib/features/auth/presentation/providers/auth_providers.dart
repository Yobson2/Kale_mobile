import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/config/env_provider.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/core/providers/network_providers.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/providers/supabase_provider.dart';
import 'package:kale/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kale/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kale/features/auth/data/datasources/mock_auth_remote_datasource.dart';
import 'package:kale/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';
import 'package:kale/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:kale/features/auth/domain/usecases/login_usecase.dart';
import 'package:kale/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kale/features/auth/domain/usecases/register_usecase.dart';
import 'package:kale/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:kale/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:kale/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:kale/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Provides the [AuthRemoteDataSource].
///
/// Uses the in-memory mock when the `USE_MOCK_AUTH` define is true.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final env = ref.watch(envProvider);
  if (env.useMockAuth) return MockAuthRemoteDataSource();

  return SupabaseAuthRemoteDataSource(
    supabaseClient: ref.watch(supabaseClientProvider),
    googleWebClientId: env.googleWebClientId,
    googleIosClientId: env.googleIosClientId,
  );
}

/// Provides the [AuthLocalDataSource].
@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
    localStorage: ref.watch(localStorageProvider),
  );
}

/// Provides the [AuthRepository].
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    appDatabase: ref.watch(appDatabaseProvider),
  );
}

/// Provides the [LoginUseCase].
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [RegisterUseCase].
@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [ForgotPasswordUseCase].
@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [VerifyOtpUseCase].
@riverpod
VerifyOtpUseCase verifyOtpUseCase(Ref ref) {
  return VerifyOtpUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [ResendOtpUseCase].
@riverpod
ResendOtpUseCase resendOtpUseCase(Ref ref) {
  return ResendOtpUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [LogoutUseCase].
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [GetCachedUserUseCase].
@riverpod
GetCachedUserUseCase getCachedUserUseCase(Ref ref) {
  return GetCachedUserUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [UpdatePasswordUseCase].
@riverpod
UpdatePasswordUseCase updatePasswordUseCase(Ref ref) {
  return UpdatePasswordUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [SignInWithGoogleUseCase].
@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) {
  return SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [SignInWithAppleUseCase].
@riverpod
SignInWithAppleUseCase signInWithAppleUseCase(Ref ref) {
  return SignInWithAppleUseCase(ref.watch(authRepositoryProvider));
}
