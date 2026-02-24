import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budgets_state.freezed.dart';

/// Represents the state of budget operations.
@freezed
sealed class BudgetsState with _$BudgetsState {
  /// Initial state before any budget operation.
  const factory BudgetsState.initial() = BudgetsInitial;

  /// Loading state during budget operations.
  const factory BudgetsState.loading() = BudgetsLoading;

  /// A budget operation succeeded (create, delete, etc.).
  const factory BudgetsState.success({String? message}) = BudgetsSuccess;

  /// A budget was loaded successfully.
  const factory BudgetsState.loaded(Budget budget) = BudgetsLoaded;

  /// An error occurred during a budget operation.
  const factory BudgetsState.error(String message) = BudgetsError;
}
