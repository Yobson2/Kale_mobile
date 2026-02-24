import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Registers a new user account via Supabase.
///
/// Creates the account and sends a confirmation OTP.
/// The user is **not** authenticated until the OTP is verified.
class RegisterUseCase extends UseCase<void, RegisterParams> {
  /// Creates a [RegisterUseCase].
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for [RegisterUseCase].
class RegisterParams {
  /// Creates [RegisterParams].
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  /// User display name.
  final String name;

  /// User email.
  final String email;

  /// User password.
  final String password;
}
