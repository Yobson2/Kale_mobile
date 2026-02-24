import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/usecases/create_budget_usecase.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/budget/presentation/providers/budgets_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgets_notifier.g.dart';

/// Manages budget operations and state.
///
/// Follows the same Notifier pattern as [AuthNotifier].
@Riverpod(keepAlive: true)
class BudgetsNotifier extends _$BudgetsNotifier {
  @override
  BudgetsState build() {
    return const BudgetsState.initial();
  }

  /// Creates a new budget with the given parameters.
  Future<bool> createBudget({
    required String name,
    required BudgetStrategy strategy,
    required BudgetPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    required List<BudgetCategoryAllocation> categories,
    double? totalIncome,
    bool isPercentageBased = true,
  }) async {
    state = const BudgetsState.loading();
    try {
      final result = await ref.read(createBudgetUseCaseProvider).call(
            CreateBudgetParams(
              name: name,
              strategy: strategy,
              period: period,
              startDate: startDate,
              endDate: endDate,
              categories: categories,
              totalIncome: totalIncome,
              isPercentageBased: isPercentageBased,
            ),
          );

      return result.fold(
        (failure) {
          state = BudgetsState.error(failure.message);
          return false;
        },
        (budget) {
          state = const BudgetsState.success(
            message: 'Budget created successfully',
          );
          // Invalidate active budget so it reloads.
          ref.invalidate(activeBudgetProvider);
          return true;
        },
      );
    } catch (e) {
      state = BudgetsState.error(e.toString());
      return false;
    }
  }

  /// Deletes a budget by its ID.
  Future<bool> deleteBudget(String id) async {
    state = const BudgetsState.loading();
    try {
      final result = await ref.read(deleteBudgetUseCaseProvider).call(id);

      return result.fold(
        (failure) {
          state = BudgetsState.error(failure.message);
          return false;
        },
        (_) {
          state = const BudgetsState.success(
            message: 'Budget deleted successfully',
          );
          ref.invalidate(activeBudgetProvider);
          return true;
        },
      );
    } catch (e) {
      state = BudgetsState.error(e.toString());
      return false;
    }
  }

  /// Loads the currently active budget.
  Future<void> loadActiveBudget() async {
    state = const BudgetsState.loading();
    try {
      final result =
          await ref.read(getActiveBudgetUseCaseProvider).call(const NoParams());

      result.fold(
        (failure) => state = BudgetsState.error(failure.message),
        (budget) {
          if (budget != null) {
            state = BudgetsState.loaded(budget);
          } else {
            state = const BudgetsState.initial();
          }
        },
      );
    } catch (e) {
      state = BudgetsState.error(e.toString());
    }
  }

  /// Triggers a full refresh from the server.
  Future<void> refreshFromServer() async {
    state = const BudgetsState.loading();
    try {
      final repository = ref.read(budgetsRepositoryProvider);
      final result = await repository.refreshFromServer();

      result.fold(
        (failure) => state = BudgetsState.error(failure.message),
        (_) {
          state = const BudgetsState.success(
            message: 'Budgets refreshed successfully',
          );
          ref.invalidate(activeBudgetProvider);
        },
      );
    } catch (e) {
      state = BudgetsState.error(e.toString());
    }
  }
}
