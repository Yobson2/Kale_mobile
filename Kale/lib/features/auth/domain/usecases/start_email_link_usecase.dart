import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Starts linking an email to the signed-in guest: sends a code to it
/// (null result), or reports that the email belongs to another account.
class StartEmailLinkUseCase extends UseCase<LinkResult?, String> {
  /// Creates a [StartEmailLinkUseCase].
  const StartEmailLinkUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, LinkResult?>> call(String params) =>
      _repository.startEmailLink(params.trim());
}
