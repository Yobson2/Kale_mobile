import 'dart:async';

import 'package:kale/core/sync/sync_providers.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/core/utils/logger.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/usecases/confirm_email_link_usecase.dart';
import 'package:kale/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/login_usecase.dart';
import 'package:kale/features/auth/domain/usecases/register_usecase.dart';
import 'package:kale/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:kale/features/auth/domain/usecases/switch_to_existing_account_usecase.dart';
import 'package:kale/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:kale/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:kale/features/auth/presentation/providers/auth_providers.dart';
import 'package:kale/features/auth/presentation/providers/auth_state.dart';
import 'package:kale/features/auth/presentation/providers/logout_outcome.dart';
import 'package:kale/features/auth/presentation/providers/save_data_outcome.dart';
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
          _restoreIfNeeded();
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
            _restoreIfNeeded();
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
          _restoreIfNeeded();
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
          _restoreIfNeeded();
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
        _restoreIfNeeded();
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

  // ── Guest upgrade ─────────────────────────────────────────────────────────
  //
  // These steps leave the auth state alone until the guest actually becomes
  // a permanent user, so a failure or a cancelled choice changes nothing.

  /// Links a Google or Apple identity to the guest.
  Future<SaveDataOutcome> linkSocialAccount(SocialProvider provider) async {
    final result =
        await ref.read(linkSocialAccountUseCaseProvider).call(provider);
    return result.fold(
      (failure) => SaveDataFailed(failure.message),
      _onLinkResult,
    );
  }

  /// Starts linking [email] to the guest: a code is sent to it.
  Future<SaveDataOutcome> startEmailLink(String email) async {
    final result = await ref.read(startEmailLinkUseCaseProvider).call(email);
    return result.fold(
      (failure) => SaveDataFailed(failure.message),
      (link) async =>
          link == null ? const SaveDataCodeSent() : _onLinkResult(link),
    );
  }

  /// Confirms the emailed [code]: the guest becomes a permanent user with
  /// [password], keeping every entry.
  Future<SaveDataOutcome> confirmEmailLink({
    required String email,
    required String code,
    required String password,
  }) async {
    final result = await ref.read(confirmEmailLinkUseCaseProvider).call(
          ConfirmEmailLinkParams(email: email, code: code, password: password),
        );
    return result.fold(
      (failure) => SaveDataFailed(failure.message),
      (user) {
        state = AuthState.authenticated(user);
        return const SaveDataDone();
      },
    );
  }

  /// Sends a sign-in code to an existing account's [email].
  Future<SaveDataOutcome> sendSignInCode(String email) async {
    final result = await ref.read(sendSignInCodeUseCaseProvider).call(email);
    return result.fold(
      (failure) => SaveDataFailed(failure.message),
      (_) => const SaveDataCodeSent(),
    );
  }

  /// How many of the guest's entries are on this device.
  Future<int> countGuestEntries() async {
    final result =
        await ref.read(countGuestEntriesUseCaseProvider).call(const NoParams());
    return result.getOrElse(() => 0);
  }

  /// Leaves the guest session for the existing account behind
  /// [credential], adding the guest's entries to it ([keepGuestData]) or
  /// discarding them. [code] is the emailed code for an email account.
  Future<SaveDataOutcome> switchToExistingAccount(
    AccountCredential credential, {
    required bool keepGuestData,
    String? code,
  }) async {
    final result = await ref.read(switchToExistingAccountUseCaseProvider).call(
          SwitchToExistingAccountParams(
            credential: credential,
            keepGuestData: keepGuestData,
            code: code,
          ),
        );
    return result.fold(
      (failure) => SaveDataFailed(failure.message),
      (user) {
        state = AuthState.authenticated(user);
        return const SaveDataDone();
      },
    );
  }

  Future<SaveDataOutcome> _onLinkResult(LinkResult link) async {
    switch (link) {
      case AccountLinked(:final user):
        state = AuthState.authenticated(user);
        return const SaveDataDone();
      case IdentityInUse(:final credential):
        return SaveDataIdentityInUse(
          credential: credential,
          entryCount: await countGuestEntries(),
        );
    }
  }

  /// Restores the account on this device if it needs it (an empty device,
  /// or a restore that did not finish; see `SyncPuller.restoreIfNeeded`).
  ///
  /// Runs in the background so it doesn't block the auth flow; the restore
  /// banner shows its progress.
  /// Never fails the sign-in: a restore that can't run now is retried at
  /// the next launch.
  void _restoreIfNeeded() {
    unawaited(
      Future(() async {
        try {
          await ref.read(syncPullerProvider).restoreIfNeeded();
        } catch (e) {
          AppLogger.error('Restore failed', tag: 'AuthNotifier', error: e);
        }
      }),
    );
  }
}
