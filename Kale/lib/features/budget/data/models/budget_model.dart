import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/core/date/calendar_date.dart';
import 'package:kale/core/sync/pull.dart';
import 'package:kale/features/budget/domain/entities/budget.dart';
import 'package:kale/features/budget/domain/entities/budget_category.dart';
import 'package:kale/features/budget/domain/entities/budget_enums.dart';
import 'package:kale/features/budget/domain/entities/budget_period_range.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

/// Data model for [Budget] with JSON serialization and Drift conversion.
///
/// `total_income_minor` is an integer count of minor units of the account's
/// base currency. `start_date`/`end_date` are plain `YYYY-MM-DD` dates.
@freezed
abstract class BudgetModel with _$BudgetModel implements PulledRow {
  const factory BudgetModel({
    required String id,
    required String name,
    required String strategy,
    required String period,
    @CalendarDateJsonConverter()
    @JsonKey(name: 'start_date')
    required CalendarDate startDate,
    @CalendarDateJsonConverter()
    @JsonKey(name: 'end_date')
    required CalendarDate endDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'server_id') String? serverId,
    @Default(BudgetPeriodRange.defaultStartDay)
    @JsonKey(name: 'period_start_day')
    int periodStartDay,
    @JsonKey(name: 'total_income_minor') int? totalIncomeMinor,
    @Default(true) @JsonKey(name: 'is_percentage_based') bool isPercentageBased,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _BudgetModel;
  const BudgetModel._();

  /// Creates a [BudgetModel] from JSON.
  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  /// Creates a [BudgetModel] from a Drift [db.Budget] row.
  factory BudgetModel.fromDrift(db.Budget row) => BudgetModel(
        id: row.id,
        serverId: row.serverId,
        name: row.name,
        strategy: row.strategy,
        period: row.period,
        startDate: row.startDate,
        endDate: row.endDate,
        periodStartDay: row.periodStartDay,
        totalIncomeMinor: row.totalIncomeMinor,
        isPercentageBased: row.isPercentageBased,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        isSynced: row.isSynced,
      );

  /// Converts this model to a domain [Budget] entity.
  ///
  /// Category allocations must be provided separately since
  /// they come from a different table.
  Budget toEntity({
    List<BudgetCategoryAllocation> categories = const [],
  }) =>
      Budget(
        id: id,
        name: name,
        strategy: _parseStrategy(strategy),
        period: _parsePeriod(period),
        startDate: startDate,
        endDate: endDate,
        periodStartDay: periodStartDay,
        totalIncomeMinor: totalIncomeMinor,
        isPercentageBased: isPercentageBased,
        categories: categories,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isSynced: isSynced,
      );

  /// Converts this model to a Drift [db.BudgetsCompanion] for upserting.
  db.BudgetsCompanion toDriftCompanion() => db.BudgetsCompanion(
        id: drift.Value(id),
        serverId: serverId != null
            ? drift.Value(serverId)
            : const drift.Value.absent(),
        name: drift.Value(name),
        strategy: drift.Value(strategy),
        period: drift.Value(period),
        startDate: drift.Value(startDate),
        endDate: drift.Value(endDate),
        periodStartDay: drift.Value(periodStartDay),
        totalIncomeMinor: drift.Value(totalIncomeMinor),
        isPercentageBased: drift.Value(isPercentageBased),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        deletedAt: drift.Value(deletedAt),
        isSynced: drift.Value(isSynced),
      );

  static BudgetStrategy _parseStrategy(String value) {
    return BudgetStrategy.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BudgetStrategy.custom,
    );
  }

  static BudgetPeriod _parsePeriod(String value) {
    return BudgetPeriod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BudgetPeriod.monthly,
    );
  }
}

/// Reads and writes a [CalendarDate] as a `YYYY-MM-DD` JSON string (a
/// Postgres `DATE`).
class CalendarDateJsonConverter extends JsonConverter<CalendarDate, String> {
  const CalendarDateJsonConverter();

  @override
  CalendarDate fromJson(String json) => CalendarDate.parse(json);

  @override
  String toJson(CalendarDate object) => object.toIso();
}
