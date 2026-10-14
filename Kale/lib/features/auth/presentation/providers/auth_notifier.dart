import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/login_usecase.dart';
import 'package:kale/features/auth/domain/usecases/register_usecase.dart';
import 'package:kale/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:kale/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:kale/features/auth/presentation/providers/auth_providers.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/logout_outcome.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
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
        (user) {
          _syncFromServer();
          return AuthState.authenticated(user);
        },
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
  /// Set [isRecovery] to `true` for the forgot-password flow.
  /// For the signup flow, sets state to [AuthAuthenticated].
  /// For the forgot-password flow, returns `true` without authenticating.
  Future<bool> verifyOtp({
    required String email,
    required String code,
    bool isRecovery = false,
  }) async {
    state = const AuthState.loading();
    try {
      final result = await ref.read(verifyOtpUseCaseProvider).call(
            VerifyOtpParams(
              email: email,
              code: code,
              isRecovery: isRecovery,
            ),
          );
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (user) {
          if (user != null) {
            _syncFromServer();
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

  /// Resends the signup confirmation OTP to [email].
  Future<bool> resendOtp({required String email}) async {
    try {
      final result = await ref.read(resendOtpUseCaseProvider).call(
            ResendOtpParams(email: email),
          );
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (_) => true,
      );
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Updates the user's password after recovery OTP verification.
  Future<bool> updatePassword({required String newPassword}) async {
    state = const AuthState.loading();
    try {
      final result = await ref.read(updatePasswordUseCaseProvider).call(
            UpdatePasswordParams(newPassword: newPassword),
          );
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (_) {
          // Password updated — user is now fully authenticated.
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
        (user) {
          _syncFromServer();
          return AuthState.authenticated(user);
        },
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
        (user) {
          _syncFromServer();
          return AuthState.authenticated(user);
        },
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------------

  /// Logs the user out, without ever losing data silently.
  ///
  /// Backs up pending changes first. If every change reached the server,
  /// logs out and wipes the phone ([LogoutOutcome.loggedOut]). Otherwise
  /// nothing happens and the user stays logged in
  /// ([LogoutOutcome.blocked], with the number of changes that would be
  /// lost); only [discardChangesAndLogout] logs out from there.
  Future<LogoutOutcome> logout() async {
    final LogoutOutcome? stop;
    try {
      final backup = await ref
          .read(backUpPendingChangesUseCaseProvider)
          .call(const NoParams());
      stop = backup.fold(
        (failure) => LogoutOutcome.failed(failure.message),
        (unsaved) =>
            unsaved > 0 ? LogoutOutcome.blocked(unsavedChanges: unsaved) : null,
      );
    } catch (e) {
      return LogoutOutcome.failed(e.toString());
    }
    if (stop != null) return stop;

    await _logOutAndWipe();
    return const LogoutOutcome.loggedOut();
  }

  /// Logs out even though some changes are not backed up: the user
  /// explicitly confirmed losing them. Wipes the local data and the sync
  /// queue.
  Future<void> discardChangesAndLogout() => _logOutAndWipe();

  Future<void> _logOutAndWipe() async {
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

  /// Restores the session on app launch, or starts an anonymous one.
  ///
  /// A returning user (anonymous or not) keeps their cached session. With
  /// no session, the app signs in anonymously so every user has a real
  /// account whose data syncs. If that fails (e.g. offline on first
  /// launch), the user is unauthenticated and can retry from the login
  /// page.
  Future<void> restoreSession() async {
    state = const AuthState.loading();
    try {
      final cached =
          await ref.read(getCachedUserUseCaseProvider).call(const NoParams());
      final cachedUser = cached.fold((_) => null, (user) => user);
      if (cachedUser != null) {
        state = AuthState.authenticated(cachedUser);
        return;
      }

      final result = await ref
          .read(signInAnonymouslyUseCaseProvider)
          .call(const NoParams());
      state = result.fold(
        (_) => const AuthState.unauthenticated(),
        AuthState.authenticated,
      );
    } catch (_) {
      // Never leave launch stuck on the splash.
      state = const AuthState.unauthenticated();
    }
  }

  /// Starts an anonymous session ("Try Kalé first").
  ///
  /// Returns `true` once the user is authenticated anonymously.
  Future<bool> signInAnonymously() async {
    state = const AuthState.loading();
    try {
      final result = await ref
          .read(signInAnonymouslyUseCaseProvider)
          .call(const NoParams());
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (user) {
          state = AuthState.authenticated(user);
          return true;
        },
      );
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Syncs local data from the server after a successful login or signup.
  ///
  /// Runs in the background so it doesn't block the auth flow.
  void _syncFromServer() {
    Future(() async {
      try {
        await Future.wait([
          ref.read(budgetsRepositoryProvider).refreshFromServer(),
          ref.read(transactionsRepositoryProvider).refreshFromServer(),
          ref.read(savingsRepositoryProvider).refreshFromServer(),
          ref.read(profileRepositoryProvider).refreshFromServer(),
        ]);
      } catch (_) {
        // Sync failures are non-critical — data will refresh on next pull.
      }
    });
  }
}
