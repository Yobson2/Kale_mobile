import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/features/dashboard/domain/entities/dashboard_summary.dart';

/// Abstract repository for fetching dashboard summary data.
abstract class DashboardRepository {
  /// Gets a [DashboardSummary] for the given date range.
  Future<Either<Failure, DashboardSummary>> getDashboardSummary({
    required DateTime startDate,
    required DateTime endDate,
  });
}
