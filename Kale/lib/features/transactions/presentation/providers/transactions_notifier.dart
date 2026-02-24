import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/budget_alert_checker.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/delete_transaction_usecase.dart';
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

      // Fire-and-forget budget alert check for expense transactions.
      if (state is TransactionsSuccess && type == TransactionType.expense) {
        _checkBudgetAlert(categoryId);
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
