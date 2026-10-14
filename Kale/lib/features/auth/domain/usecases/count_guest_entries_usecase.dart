import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Counts the guest's entries on this device (live transactions, budgets
/// and savings goals), as shown before choosing what to do with them.
class CountGuestEntriesUseCase extends UseCase<int, NoParams> {
  /// Creates a [CountGuestEntriesUseCase].
  const CountGuestEntriesUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) =>
      _repository.countGuestEntries();
}
