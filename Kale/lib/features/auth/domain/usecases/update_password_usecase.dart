import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Updates the user's password after recovery OTP verification.
class UpdatePasswordUseCase extends UseCase<void, UpdatePasswordParams> {
  /// Creates an [UpdatePasswordUseCase].
  const UpdatePasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(UpdatePasswordParams params) {
    return _repository.updatePassword(newPassword: params.newPassword);
  }
}

/// Parameters for [UpdatePasswordUseCase].
class UpdatePasswordParams {
  /// Creates [UpdatePasswordParams].
  const UpdatePasswordParams({required this.newPassword});

  /// The new password.
  final String newPassword;
}
