import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/login_usecase.dart';
import 'package:kale/features/auth/domain/usecases/register_usecase.dart';
import 'package:kale/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:kale/features/auth/presentation/providers/auth_providers.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

/// Manages authentication state and actions.
///
/// Uses [Notifier] pattern (Riverpod 2.0+) for synchronous state
/// with async side effects.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  // ---------------------------------------------------------------------------
  // Email / Password
  // ---------------------------------------------------------------------------

  /// Attempts to log in with [email] and [password].
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await ref.read(loginUseCaseProvider).call(
            LoginParams(email: email, password: password),
          );
      state = result.fold(
        (failure) => AuthState.error(failure.message),
        AuthState.authenticated,
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Registers a new account via Supabase.
  ///
  /// On success, Supabase sends a confirmation OTP to [email].
  /// The user is **not** authenticated until [verifyOtp] is called.
  /// Returns `true` when the OTP was sent successfully.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await ref.read(registerUseCaseProvider).call(
            RegisterParams(name: name, email: email, password: password),
          );
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (_) {
          state = const AuthState.unauthenticated();
          return true;
        },
      );
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Verifies the OTP [code] sent to [email].
  ///
  /// For the signup flow, sets state to [AuthAuthenticated].
  /// For the forgot-password flow, returns `true` without authenticating.
  Future<bool> verifyOtp({
    required String email,
    required String code,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await ref.read(verifyOtpUseCaseProvider).call(
            VerifyOtpParams(email: email, code: code),
          );
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (user) {
          if (user != null) {
            state = AuthState.authenticated(user);
          } else {
            state = const AuthState.unauthenticated();
          }
          return true;
        },
      );
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Sends a password reset email.
  Future<bool> forgotPassword({required String email}) async {
    state = const AuthState.loading();
    final result = await ref.read(forgotPasswordUseCaseProvider).call(
          ForgotPasswordParams(email: email),
        );
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated();
        return true;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Social Login
  // ---------------------------------------------------------------------------

  /// Signs in with Google OAuth.
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final result = await ref
          .read(signInWithGoogleUseCaseProvider)
          .call(const NoParams());
      state = result.fold(
        (failure) => AuthState.error(failure.message),
        AuthState.authenticated,
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Signs in with Apple OAuth.
  Future<void> signInWithApple() async {
    state = const AuthState.loading();
    try {
      final result =
          await ref.read(signInWithAppleUseCaseProvider).call(const NoParams());
      state = result.fold(
        (failure) => AuthState.error(failure.message),
        AuthState.authenticated,
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------------

  /// Logs the user out.
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      final result =
          await ref.read(logoutUseCaseProvider).call(const NoParams());
      result.fold(
        (failure) => state = AuthState.error(failure.message),
        (_) => state = const AuthState.unauthenticated(),
      );
    } catch (_) {
      // Even on error, force unauthenticated to clear local state.
      state = const AuthState.unauthenticated();
    }
  }

  /// Checks for a cached user session on app launch.
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    final result =
        await ref.read(getCachedUserUseCaseProvider).call(const NoParams());
    state = result.fold(
      (_) => const AuthState.unauthenticated(),
      AuthState.authenticated,
    );
  }

  /// Enters guest mode for "try before register" flow.
  void enterGuestMode() {
    state = const AuthState.guest();
  }
}
