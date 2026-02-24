import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:kale/features/transactions/data/daos/categories_dao.dart';
import 'package:kale/features/transactions/data/daos/transactions_dao.dart';
import 'package:kale/features/transactions/data/models/transaction_model.dart';

/// Implementation of [DashboardRepository] that queries the local
/// transactions database to compute summary data.
class DashboardRepositoryImpl implements DashboardRepository {
  /// Creates a [DashboardRepositoryImpl].
  const DashboardRepositoryImpl({
    required TransactionsDao transactionsDao,
    required CategoriesDao categoriesDao,
  })  : _transactionsDao = transactionsDao,
        _categoriesDao = categoriesDao;

  final TransactionsDao _transactionsDao;
  final CategoriesDao _categoriesDao;

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Get total income for the period.
      final totalIncome = await _transactionsDao.getTotalForPeriod(
        startDate: startDate,
        endDate: endDate,
        type: 'income',
      );

      // Get total expenses for the period.
      final totalExpenses = await _transactionsDao.getTotalForPeriod(
        startDate: startDate,
        endDate: endDate,
        type: 'expense',
      );

      // Get recent transactions (all types, take first 5).
      final allTransactions = await _transactionsDao.getAll(
        startDate: startDate,
        endDate: endDate,
      );
      final recentTransactions = allTransactions
          .take(5)
          .map((row) => TransactionModel.fromDrift(row).toEntity())
          .toList();

      // Get top expense categories.
      final categoryTotals = await _transactionsDao.getCategoryTotals(
        startDate: startDate,
        endDate: endDate,
        type: 'expense',
      );
      final topExpenseCategories = <String, double>{};
      for (final ct in categoryTotals) {
        topExpenseCategories[ct.categoryId] = ct.total;
      }

      // Build category ID → name and color lookups.
      final allCategories = await _categoriesDao.getAll();
      final categoryNames = <String, String>{
        for (final cat in allCategories) cat.id: cat.name,
      };
      final categoryColors = <String, String>{
        for (final cat in allCategories) cat.id: cat.color,
      };

      return Right(
        DashboardSummary(
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          recentTransactions: recentTransactions,
          topExpenseCategories: topExpenseCategories,
          categoryNames: categoryNames,
          categoryColors: categoryColors,
        ),
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to load dashboard: $e'));
    }
  }
}
