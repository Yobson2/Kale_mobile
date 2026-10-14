import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/domain/usecases/contribute_to_goal_usecase.dart';
import 'package:kale/features/savings/domain/usecases/create_savings_goal_usecase.dart';
import 'package:kale/features/savings/domain/usecases/update_savings_goal_usecase.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';
import 'package:kale/features/savings/presentation/providers/savings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'savings_notifier.g.dart';

/// Manages savings goal mutation state and actions.
///
/// Amounts are integer minor units of the account's base currency.
@riverpod
class SavingsNotifier extends _$SavingsNotifier {
  @override
  SavingsState build() => const SavingsState.initial();

  /// Creates a new savings goal.
  Future<void> createGoal({
    required String name,
    required int targetAmountMinor,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    state = const SavingsState.loading();
    try {
      final result = await ref.read(createSavingsGoalUseCaseProvider).call(
            CreateSavingsGoalParams(
              name: name,
              targetAmountMinor: targetAmountMinor,
              description: description,
              deadline: deadline,
              iconName: iconName,
              colorHex: colorHex,
            ),
          );
      state = result.fold(
        (failure) => SavingsState.error(failure.message),
        (_) => const SavingsState.success(message: 'Goal created'),
      );
    } catch (e) {
      state = SavingsState.error(e.toString());
    }
  }

  /// Updates an existing savings goal.
  Future<void> updateGoal({
    required String id,
    required String name,
    required int targetAmountMinor,
    required SavingsGoalStatus status,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    state = const SavingsState.loading();
    try {
      final result = await ref.read(updateSavingsGoalUseCaseProvider).call(
            UpdateSavingsGoalParams(
              id: id,
              name: name,
              targetAmountMinor: targetAmountMinor,
              status: status,
              description: description,
              deadline: deadline,
              iconName: iconName,
              colorHex: colorHex,
            ),
          );
      state = result.fold(
        (failure) => SavingsState.error(failure.message),
        (_) => const SavingsState.success(message: 'Goal updated'),
      );
    } catch (e) {
      state = SavingsState.error(e.toString());
    }
  }

  /// Deletes a savings goal.
  Future<void> deleteGoal(String id) async {
    state = const SavingsState.loading();
    try {
      final result = await ref.read(deleteSavingsGoalUseCaseProvider).call(id);
      state = result.fold(
        (failure) => SavingsState.error(failure.message),
        (_) => const SavingsState.success(message: 'Goal deleted'),
      );
    } catch (e) {
      state = SavingsState.error(e.toString());
    }
  }

  /// Contributes [amountMinor] to a savings goal.
  Future<void> contribute({
    required String goalId,
    required int amountMinor,
    ContributionSource source = ContributionSource.manual,
    String? note,
  }) async {
    state = const SavingsState.loading();
    try {
      final result = await ref.read(contributeToGoalUseCaseProvider).call(
            ContributeToGoalParams(
              goalId: goalId,
              amountMinor: amountMinor,
              source: source,
              note: note,
            ),
          );
      state = result.fold(
        (failure) => SavingsState.error(failure.message),
        (contribution) {
          _checkSavingsMilestone(goalId);
          return const SavingsState.success(message: 'Contribution added');
        },
      );
    } catch (e) {
      state = SavingsState.error(e.toString());
    }
  }

  /// Checks if a savings goal crossed a milestone and fires a notification.
  void _checkSavingsMilestone(String goalId) {
    Future(() async {
      try {
        final goals = await ref.read(savingsGoalsStreamProvider.future);
        final goal = goals.where((g) => g.id == goalId).firstOrNull;
        if (goal == null) return;

        // Unlock achievement if goal is fully funded.
        if (goal.isFullyFunded) {
          final achievements =
              AchievementService(ref.read(localStorageProvider));
          await achievements.unlock(Achievement.firstGoalCompleted);
        }

        // Each milestone (25/50/75/100%) once per goal.
        await ref.read(savingsMilestoneCheckerProvider).check(goal);
      } catch (_) {
        // Best-effort — silently ignore.
      }
    });
  }
}
