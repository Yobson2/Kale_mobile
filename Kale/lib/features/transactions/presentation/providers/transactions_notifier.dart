import 'package:kale/core/config/feature_flags.dart';
import 'package:kale/core/providers/notification_provider.dart';
import 'package:kale/core/providers/share_provider.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/achievement_service.dart';
import 'package:kale/core/services/budget_alert_checker.dart';
import 'package:kale/core/services/streak_service.dart';
import 'package:kale/features/budget/presentation/providers/budgets_providers.dart';
import 'package:kale/features/profile/presentation/providers/profile_providers.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';
import 'package:kale/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:kale/features/transactions/domain/usecases/export_transactions_csv_usecase.dart';
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
    required int amountMinor,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  }) async {
    state = const TransactionsState.loading();
    try {
      final result = await ref.read(createTransactionUseCaseProvider).call(
            CreateTransactionParams(
              amountMinor: amountMinor,
              type: type,
              categoryId: categoryId,
              date: date,
              paymentMethod: paymentMethod,
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
    required int amountMinor,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    required PaymentMethod paymentMethod,
    String? description,
    String? mobileMoneyProvider,
    String? mobileMoneyRef,
  }) async {
    state = const TransactionsState.loading();
    try {
      final result = await ref.read(updateTransactionUseCaseProvider).call(
            UpdateTransactionParams(
              id: id,
              amountMinor: amountMinor,
              type: type,
              categoryId: categoryId,
              date: date,
              paymentMethod: paymentMethod,
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
      final result = await ref.read(deleteTransactionUseCaseProvider).call(id);
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

  /// Records streak and checks transaction-related achievements, when
  /// gamification is on.
  void _checkAchievements() {
    if (!ref.read(featureFlagsProvider).gamificationEnabled) return;
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
        final transactions = await ref.read(transactionsStreamProvider.future);
        if (transactions.length >= 100) {
          await achievements.unlock(Achievement.transactions100);
        }
      } catch (_) {
        // Best-effort — silently ignore.
      }
    });
  }

  /// Alerts once if the transaction's category reached 80% or 100% of its
  /// allocation in this budget period (see [BudgetAlertChecker]).
  void _checkBudgetAlert(String categoryId) {
    Future(() async {
      try {
        final budget = await ref.read(activeBudgetProvider.future);
        if (budget == null) return;

        final checker = ref.read(budgetAlertCheckerProvider);

        // Resolve category name for the notification.
        final categories = await ref.read(categoriesStreamProvider.future);
        final category =
            categories.where((c) => c.id == categoryId).firstOrNull;

        await checker.checkAndAlert(
          budget: budget,
          categoryId: categoryId,
          currency: ref.read(baseCurrencyProvider),
          categoryName: category?.name,
        );
      } catch (_) {
        // Silently ignore — budget alert is best-effort.
      }
    });
  }

  /// Exports the transactions between [startDate] and [endDate] (all when
  /// null) as CSV and opens the share sheet with it. Returns how many
  /// transactions were exported, or null if it failed.
  Future<int?> exportCsv({
    required CsvLabels labels,
    required String fileName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final categories = await ref.read(categoriesStreamProvider.future);
      final result = await ref.read(exportTransactionsCsvUseCaseProvider).call(
            ExportTransactionsCsvParams(
              labels: labels,
              categoryNames: {for (final c in categories) c.id: c.name},
              currency: ref.read(baseCurrencyProvider),
              startDate: startDate,
              endDate: endDate,
            ),
          );
      final csv = result.fold((_) => null, (csv) => csv);
      if (csv == null) return null;
      // The header is the first line; every other line is a transaction.
      final count = '\r\n'.allMatches(csv).length - 1;
      if (count > 0) {
        await ref.read(shareServiceProvider).shareTextFile(
              fileName: fileName,
              content: csv,
              mimeType: 'text/csv',
            );
      }
      return count;
    } catch (_) {
      return null;
    }
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
