import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_state.freezed.dart';

/// Represents the state of savings goal operations.
@freezed
sealed class SavingsState with _$SavingsState {
  /// Initial state before any operation.
  const factory SavingsState.initial() = SavingsInitial;

  /// Loading state during an operation.
  const factory SavingsState.loading() = SavingsLoading;

  /// An operation completed successfully.
  const factory SavingsState.success({String? message}) = SavingsSuccess;

  /// An error occurred during an operation.
  const factory SavingsState.error(String message) = SavingsError;
}
