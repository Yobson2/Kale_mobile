import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Verifies an OTP code sent to the user's email.
///
/// For the signup flow, this completes registration and returns the
/// authenticated [User]. For forgot-password flow, returns `null`.
class VerifyOtpUseCase extends UseCase<User?, VerifyOtpParams> {
  /// Creates a [VerifyOtpUseCase].
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User?>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(email: params.email, code: params.code);
  }
}

/// Parameters for [VerifyOtpUseCase].
class VerifyOtpParams {
  /// Creates [VerifyOtpParams].
  const VerifyOtpParams({required this.email, required this.code});

  /// User email.
  final String email;

  /// OTP code.
  final String code;
}
