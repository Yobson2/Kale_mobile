import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// The budget to offer "Renew for this period" for: the one that ended
/// most recently, when no budget covers the given day (today). Null when a
/// budget is running, or when there has never been one.
class GetBudgetToRenewUseCase extends UseCase<Budget?, CalendarDate> {
  /// Creates a [GetBudgetToRenewUseCase].
  const GetBudgetToRenewUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget?>> call(CalendarDate params) async {
    final today = params;
    final active = await _repository.getActiveBudget(today: today);
    return active.fold(Left.new, (current) async {
      if (current != null) return const Right(null);
      final all = await _repository.getBudgets();
      return all.map((budgets) {
        Budget? latest;
        for (final budget in budgets) {
          if (!budget.endDate.isBefore(today)) continue;
          if (latest == null || budget.endDate.isAfter(latest.endDate)) {
            latest = budget;
          }
        }
        return latest;
      });
    });
  }
}
