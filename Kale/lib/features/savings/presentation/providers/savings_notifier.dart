import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';
import 'package:kale/features/savings/presentation/providers/savings_providers.dart';
import 'package:kale/features/savings/presentation/providers/savings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'savings_notifier.g.dart';

/// Manages savings goal mutation state and actions.
@riverpod
class SavingsNotifier extends _$SavingsNotifier {
  @override
  SavingsState build() => const SavingsState.initial();

  /// Creates a new savings goal.
  Future<void> createGoal({
    required String name,
    required double targetAmount,
    required String currencyCode,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    state = const SavingsState.loading();
    try {
      final result =
          await ref.read(savingsRepositoryProvider).createSavingsGoal(
                name: name,
                targetAmount: targetAmount,
                currencyCode: currencyCode,
                description: description,
                deadline: deadline,
                iconName: iconName,
                colorHex: colorHex,
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
    required double targetAmount,
    required String currencyCode,
    required SavingsGoalStatus status,
    String? description,
    DateTime? deadline,
    String? iconName,
    String? colorHex,
  }) async {
    state = const SavingsState.loading();
    try {
      final result =
          await ref.read(savingsRepositoryProvider).updateSavingsGoal(
                id: id,
                name: name,
                targetAmount: targetAmount,
                currencyCode: currencyCode,
                status: status,
                description: description,
                deadline: deadline,
                iconName: iconName,
                colorHex: colorHex,
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
      final result =
          await ref.read(savingsRepositoryProvider).deleteSavingsGoal(id);
      state = result.fold(
        (failure) => SavingsState.error(failure.message),
        (_) => const SavingsState.success(message: 'Goal deleted'),
      );
    } catch (e) {
      state = SavingsState.error(e.toString());
    }
  }

  /// Contributes money to a savings goal.
  Future<void> contribute({
    required String goalId,
    required double amount,
    ContributionSource source = ContributionSource.manual,
    String? note,
  }) async {
    state = const SavingsState.loading();
    try {
      final result =
          await ref.read(savingsRepositoryProvider).contributeToGoal(
                goalId: goalId,
                amount: amount,
                source: source,
                note: note,
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
        final localStorage = ref.read(localStorageProvider);
        if (!localStorage.isNotificationsEnabled) return;

        final goals =
            await ref.read(savingsGoalsStreamProvider.future);
        final goal = goals.where((g) => g.id == goalId).firstOrNull;
        if (goal == null) return;

        // Unlock achievement if goal is fully funded.
        if (goal.isFullyFunded) {
          final achievements =
              AchievementService(ref.read(localStorageProvider));
          await achievements.unlock(Achievement.firstGoalCompleted);
        }

        final percent = (goal.progress * 100).round();
        // Only notify at meaningful milestones.
        const milestones = [25, 50, 75, 100];
        final milestone = milestones
            .where((m) => percent >= m)
            .lastOrNull;
        if (milestone == null) return;

        // Only notify if we just crossed this milestone (within 5%).
        if (percent > milestone + 5) return;

        await ref.read(notificationServiceProvider).showSavingsMilestone(
              goalName: goal.name,
              milestonePercent: milestone,
            );
      } catch (_) {
        // Best-effort — silently ignore.
      }
    });
  }
}
