import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Leaves the guest session for an existing account, adding the guest's
/// entries to it or discarding them.
class SwitchToExistingAccountUseCase
    extends UseCase<User, SwitchToExistingAccountParams> {
  /// Creates a [SwitchToExistingAccountUseCase].
  const SwitchToExistingAccountUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SwitchToExistingAccountParams params) =>
      _repository.switchToExistingAccount(
        credential: params.credential,
        keepGuestData: params.keepGuestData,
        code: params.code,
      );
}

/// Parameters for [SwitchToExistingAccountUseCase].
class SwitchToExistingAccountParams {
  /// Creates [SwitchToExistingAccountParams].
  const SwitchToExistingAccountParams({
    required this.credential,
    required this.keepGuestData,
    this.code,
  });

  /// How to sign in to the existing account.
  final AccountCredential credential;

  /// Whether the guest's entries are added to the account (true) or
  /// discarded (false).
  final bool keepGuestData;

  /// The emailed code, for an [EmailCodeCredential].
  final String? code;
}
