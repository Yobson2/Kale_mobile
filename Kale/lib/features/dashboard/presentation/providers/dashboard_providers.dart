import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/database/database_providers.dart';
import 'package:kale/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:kale/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_providers.g.dart';

/// Selected dashboard period.
enum DashboardPeriod {
  /// Today only.
  daily,

  /// Current week (Monday to Sunday).
  weekly,

  /// Current calendar month.
  monthly,
}

/// Provides the [DashboardRepository] implementation.
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DashboardRepositoryImpl(
    transactionsDao: db.transactionsDao,
    categoriesDao: db.categoriesDao,
  );
}

/// Manages the selected dashboard period.
@riverpod
class DashboardPeriodNotifier extends _$DashboardPeriodNotifier {
  @override
  DashboardPeriod build() => DashboardPeriod.monthly;

  /// Changes the selected dashboard period.
  void setPeriod(DashboardPeriod period) => state = period;
}

/// Provides a category ID to display name lookup map.
///
/// Used by the budget page and other screens that need to resolve
/// category IDs to human-readable names.
@riverpod
Future<Map<String, String>> categoryNames(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final allCategories = await db.categoriesDao.getAll();
  return {
    for (final cat in allCategories) cat.id: cat.name,
  };
}

/// Provides the [DashboardSummary] for the currently selected period.
@riverpod
Future<DashboardSummary> dashboardSummary(Ref ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  final period = ref.watch(dashboardPeriodNotifierProvider);

  final now = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  switch (period) {
    case DashboardPeriod.daily:
      startDate = DateTime(now.year, now.month, now.day);
      endDate = startDate.add(const Duration(days: 1));
    case DashboardPeriod.weekly:
      final weekday = now.weekday;
      startDate = DateTime(now.year, now.month, now.day - (weekday - 1));
      endDate = startDate.add(const Duration(days: 7));
    case DashboardPeriod.monthly:
      startDate = DateTime(now.year, now.month);
      endDate = DateTime(now.year, now.month + 1);
  }

  final result = await repository.getDashboardSummary(
    startDate: startDate,
    endDate: endDate,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (summary) => summary,
  );
}
