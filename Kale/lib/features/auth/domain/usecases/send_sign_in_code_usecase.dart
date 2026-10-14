import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Sends a sign-in code to an existing account's email.
class SendSignInCodeUseCase extends UseCase<void, String> {
  /// Creates a [SendSignInCodeUseCase].
  const SendSignInCodeUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.sendSignInCode(params);
}
