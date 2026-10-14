import 'package:dartz/dartz.dart';
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/repositories/budgets_repository.dart';

/// Gets the budget whose period covers the given day (usually today).
class GetActiveBudgetUseCase extends UseCase<Budget?, CalendarDate> {
  const GetActiveBudgetUseCase(this._repository);

  final BudgetsRepository _repository;

  @override
  Future<Either<Failure, Budget?>> call(CalendarDate params) {
    return _repository.getActiveBudget(today: params);
  }
}
