import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Starts an anonymous session, so someone trying the app has a real
/// account whose data syncs like everyone else's.
class SignInAnonymouslyUseCase extends UseCase<User, NoParams> {
  /// Creates a [SignInAnonymouslyUseCase].
  const SignInAnonymouslyUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return _repository.signInAnonymously();
  }
}
