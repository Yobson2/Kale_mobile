import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Gets the currently cached user from local storage.
class GetCachedUserUseCase extends UseCase<User, NoParams> {
  /// Creates a [GetCachedUserUseCase].
  const GetCachedUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return _repository.getCachedUser();
  }
}
