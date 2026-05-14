import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
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

  /// Logs out the current user and clears tokens.
  Future<Either<Failure, void>> logout();

  /// Gets the currently cached user (from local storage / Supabase session).
  Future<Either<Failure, User>> getCachedUser();

  /// Whether a valid session exists.
  Future<bool> get isAuthenticated;

  /// Signs in with Google OAuth via Supabase.
  Future<Either<Failure, User>> signInWithGoogle();

  /// Signs in with Apple OAuth via Supabase.
  Future<Either<Failure, User>> signInWithApple();
}
