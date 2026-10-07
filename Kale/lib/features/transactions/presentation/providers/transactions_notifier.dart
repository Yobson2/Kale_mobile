import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/core/services/budget_alert_checker.dart';
import 'package:kale/core/services/streak_service.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:kale/features/transactions/presentation/providers/transactions_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_notifier.g.dart';

/// Manages transaction mutation state and actions.
///
/// Uses [Notifier] pattern (Riverpod 2.0+) for synchronous state
/// with async side effects.
@riverpod
class TransactionsNotifier extends _$TransactionsNotifier {
  @override
  TransactionsState build() {
    return const TransactionsState.initial();
  }

  /// Creates a new transaction.
  Future<void> createTransaction({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    required String currencyCode,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  }) async {
    state = const TransactionsState.loading();
    try {
      final result = await ref.read(createTransactionUseCaseProvider).call(
            CreateTransactionParams(
              amount: amount,
              type: type,
              categoryId: categoryId,
              date: date,
              paymentMethod: paymentMethod,
              currencyCode: currencyCode,
              description: description,
              mobileMoneyProvider: mobileMoneyProvider,
              mobileMoneyRef: mobileMoneyRef,
            ),
          );
      state = result.fold(
        (failure) => TransactionsState.error(failure.message),
        (_) => const TransactionsState.success(
          message: 'Transaction created',
        ),
      );

      // Fire-and-forget post-transaction checks.
      if (state is TransactionsSuccess) {
        _checkAchievements();
        if (type == TransactionType.expense) {
          _checkBudgetAlert(categoryId);
        }
      }
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }

  /// Updates an existing transaction.
  Future<void> updateTransaction({
    required String id,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    required String currencyCode,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  }) async {
    state = const TransactionsState.loading();
    try {
      final result = await ref.read(updateTransactionUseCaseProvider).call(
            UpdateTransactionParams(
              id: id,
              amount: amount,
              type: type,
              categoryId: categoryId,
              date: date,
              paymentMethod: paymentMethod,
              currencyCode: currencyCode,
              description: description,
              mobileMoneyProvider: mobileMoneyProvider,
              mobileMoneyRef: mobileMoneyRef,
            ),
          );
      state = result.fold(
        (failure) => TransactionsState.error(failure.message),
        (_) => const TransactionsState.success(
          message: 'Transaction updated',
        ),
      );
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }

  /// Deletes a transaction by [id].
  Future<void> deleteTransaction(String id) async {
    state = const TransactionsState.loading();
    try {
      final result =
          await ref.read(deleteTransactionUseCaseProvider).call(id);
      state = result.fold(
        (failure) => TransactionsState.error(failure.message),
        (_) => const TransactionsState.success(
          message: 'Transaction deleted',
        ),
      );
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }

  /// Triggers a full refresh from the server.
  Future<void> refreshFromServer() async {
    state = const TransactionsState.loading();
    try {
      final repository = ref.read(transactionsRepositoryProvider);
      final result = await repository.refreshFromServer();
      state = result.fold(
        (failure) => TransactionsState.error(failure.message),
        (_) => const TransactionsState.success(
          message: 'Transactions refreshed',
        ),
      );
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }

  /// Records streak and checks transaction-related achievements.
  void _checkAchievements() {
    Future(() async {
      try {
        final localStorage = ref.read(localStorageProvider);
        final achievements = AchievementService(localStorage);
        final streak = StreakService(localStorage);

        // Record the daily streak.
        await streak.recordTransaction();

        // First transaction badge.
        await achievements.unlock(Achievement.firstTransaction);

        // Streak badges.
        final currentStreak = streak.currentStreak;
        if (currentStreak >= 7) {
          await achievements.unlock(Achievement.streak7);
        }
        if (currentStreak >= 30) {
          await achievements.unlock(Achievement.streak30);
        }

        // 100 transactions badge.
        final transactions =
            await ref.read(transactionsStreamProvider.future);
        if (transactions.length >= 100) {
          await achievements.unlock(Achievement.transactions100);
        }
      } catch (_) {
        // Best-effort — silently ignore.
      }
    });
  }

  /// Checks if the transaction's category has exceeded the budget alert
  /// threshold and fires a notification if so.
  void _checkBudgetAlert(String categoryId) {
    Future(() async {
      try {
        final budget = await ref.read(activeBudgetProvider.future);
        if (budget == null) return;

        final checker = BudgetAlertChecker(
          notificationService: ref.read(notificationServiceProvider),
          localStorage: ref.read(localStorageProvider),
        );

        // Resolve category name for the notification.
        final categories =
            await ref.read(categoriesStreamProvider.future);
        final category = categories
            .where((c) => c.id == categoryId)
            .firstOrNull;

        await checker.checkAndAlert(
          budget: budget,
          categoryId: categoryId,
          categoryName: category?.name,
        );
      } catch (_) {
        // Silently ignore — budget alert is best-effort.
      }
    });
  }

  /// Loads a single transaction by [id].
  Future<void> loadTransaction(String id) async {
    state = const TransactionsState.loading();
    try {
      final repository = ref.read(transactionsRepositoryProvider);
      final result = await repository.getTransactionById(id);
      state = result.fold(
        (failure) => TransactionsState.error(failure.message),
        TransactionsState.loaded,
      );
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }
}
