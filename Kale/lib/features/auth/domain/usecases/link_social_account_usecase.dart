import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Links a Google or Apple identity to the signed-in guest, keeping its
/// user id and every local entry.
class LinkSocialAccountUseCase extends UseCase<LinkResult, SocialProvider> {
  /// Creates a [LinkSocialAccountUseCase].
  const LinkSocialAccountUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, LinkResult>> call(SocialProvider params) =>
      _repository.linkSocialAccount(params);
}
