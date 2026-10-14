import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/auth/data/repositories/auth_repository_impl.dart'
    show AuthRepositoryImpl;
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/entities/user.dart';

/// Abstract authentication repository defined in the domain layer.
///
/// Implemented by [AuthRepositoryImpl] in the data layer.

abstract class AuthRepository {
  /// Logs in with [email] and [password].
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user via Supabase. Sends a confirmation OTP
  /// automatically. The user is **not** authenticated until OTP is verified.
  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Sends a password reset code to [email].
  Future<Either<Failure, void>> forgotPassword({required String email});

  /// Verifies the OTP [code] sent to [email].
  ///
  /// Set [isRecovery] to `true` for the forgot-password flow.
  /// For the signup flow this completes registration and returns the
  /// authenticated [User]. For forgot-password it returns `null`.
  Future<Either<Failure, User?>> verifyOtp({
    required String email,
    required String code,
    bool isRecovery = false,
  });

  /// Resends the signup confirmation OTP to [email].
  Future<Either<Failure, void>> resendOtp({required String email});

  /// Updates the current user's password (after recovery OTP verification).
  Future<Either<Failure, void>> updatePassword({
    required String newPassword,
  });

  /// Pushes every local change that can be backed up right now, and
  /// returns how many are still not on the server (pending or stuck).
  Future<Either<Failure, int>> backUpPendingChanges();

  /// Logs out the current user and removes everything of theirs from the
  /// phone: tokens, the local database and the sync queue. Changes not
  /// yet backed up are lost; call [backUpPendingChanges] first.
  Future<Either<Failure, void>> logout();

  /// Gets the currently cached user (from local storage / Supabase session).
  Future<Either<Failure, User>> getCachedUser();

  /// Whether a valid session exists.
  Future<bool> get isAuthenticated;

  /// Signs in with Google OAuth via Supabase.
  Future<Either<Failure, User>> signInWithGoogle();

  /// Signs in with Apple OAuth via Supabase.
  Future<Either<Failure, User>> signInWithApple();

  /// Starts an anonymous session. The returned [User] has
  /// [User.isAnonymous] set.
  Future<Either<Failure, User>> signInAnonymously();

  // ── Guest upgrade ─────────────────────────────────────────────────────────

  /// Links a Google (or Apple) identity to the signed-in guest.
  Future<Either<Failure, LinkResult>> linkSocialAccount(
    SocialProvider provider,
  );

  /// Starts linking [email] to the signed-in guest: a code is sent to it,
  /// and the result is null. If [email] belongs to another account,
  /// returns [IdentityInUse] instead and sends nothing.
  Future<Either<Failure, LinkResult?>> startEmailLink(String email);

  /// Confirms the emailed [code] and sets [password]: the guest keeps its
  /// id and becomes a permanent user.
  Future<Either<Failure, User>> confirmEmailLink({
    required String email,
    required String code,
    required String password,
  });

  /// Sends a sign-in code to an existing account's [email].
  Future<Either<Failure, void>> sendSignInCode(String email);

  /// How many of the guest's entries are on this device: live
  /// transactions, budgets and savings goals.
  Future<Either<Failure, int>> countGuestEntries();

  /// Leaves the guest session for the existing account behind
  /// [credential] ([code] for an [EmailCodeCredential]).
  ///
  /// With [keepGuestData], every local entry is added to that account as
  /// new entries; otherwise local data is wiped. Either way the account's
  /// own data is then brought to this device.
  Future<Either<Failure, User>> switchToExistingAccount({
    required AccountCredential credential,
    required bool keepGuestData,
    String? code,
  });
}
