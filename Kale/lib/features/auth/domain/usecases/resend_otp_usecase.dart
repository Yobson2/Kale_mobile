import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Resends the signup confirmation OTP to the user's email.
class ResendOtpUseCase extends UseCase<void, ResendOtpParams> {
  /// Creates a [ResendOtpUseCase].
  const ResendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(ResendOtpParams params) {
    return _repository.resendOtp(email: params.email);
  }
}

/// Parameters for [ResendOtpUseCase].
class ResendOtpParams {
  /// Creates [ResendOtpParams].
  const ResendOtpParams({required this.email});

  /// User email.
  final String email;
}
