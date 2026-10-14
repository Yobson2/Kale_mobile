import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Confirms the code sent by `StartEmailLinkUseCase` and sets the
/// account's password: the guest becomes a permanent user.
class ConfirmEmailLinkUseCase extends UseCase<User, ConfirmEmailLinkParams> {
  /// Creates a [ConfirmEmailLinkUseCase].
  const ConfirmEmailLinkUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(ConfirmEmailLinkParams params) =>
      _repository.confirmEmailLink(
        email: params.email,
        code: params.code,
        password: params.password,
      );
}

/// Parameters for [ConfirmEmailLinkUseCase].
class ConfirmEmailLinkParams {
  /// Creates [ConfirmEmailLinkParams].
  const ConfirmEmailLinkParams({
    required this.email,
    required this.code,
    required this.password,
  });

  /// The email being linked.
  final String email;

  /// The code sent to it.
  final String code;

  /// The password the account will have.
  final String password;
}
