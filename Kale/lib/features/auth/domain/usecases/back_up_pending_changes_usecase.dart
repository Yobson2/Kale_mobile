import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Backs up every local change it can, and returns how many changes are
/// still only on this phone. Logout runs it first so it never loses data
/// silently.
class BackUpPendingChangesUseCase extends UseCase<int, NoParams> {
  /// Creates a [BackUpPendingChangesUseCase].
  const BackUpPendingChangesUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.backUpPendingChanges();
  }
}
