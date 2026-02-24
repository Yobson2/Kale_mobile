import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/savings/domain/entities/savings_contribution.dart';
import 'package:kale/features/savings/domain/entities/savings_enums.dart';

part 'savings_contribution_model.freezed.dart';
part 'savings_contribution_model.g.dart';

/// Data model for savings contributions.
@freezed
abstract class SavingsContributionModel with _$SavingsContributionModel {
  const SavingsContributionModel._();

  const factory SavingsContributionModel({
    required String id,
    @JsonKey(name: 'goal_id') required String goalId,
    required double amount,
    required String source,
    String? note,
    required DateTime date,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _SavingsContributionModel;

  factory SavingsContributionModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsContributionModelFromJson(json);

  /// Creates a model from a Drift database row.
  factory SavingsContributionModel.fromDrift(db.SavingsContribution row) =>
      SavingsContributionModel(
        id: row.id,
        goalId: row.goalId,
        amount: row.amount,
        source: row.source,
        note: row.note,
        date: row.date,
        createdAt: row.createdAt,
        isSynced: row.isSynced,
      );

  /// Converts to a domain entity.
  SavingsContribution toEntity() => SavingsContribution(
        id: id,
        goalId: goalId,
        amount: amount,
        source: ContributionSource.values.firstWhere(
          (e) => e.name == source,
          orElse: () => ContributionSource.manual,
        ),
        date: date,
        note: note,
        createdAt: createdAt,
      );

  /// Converts to a Drift companion for upsert.
  db.SavingsContributionsCompanion toDriftCompanion() =>
      db.SavingsContributionsCompanion(
        id: drift.Value(id),
        goalId: drift.Value(goalId),
        amount: drift.Value(amount),
        source: drift.Value(source),
        note: drift.Value(note),
        date: drift.Value(date),
        createdAt: drift.Value(createdAt),
        isSynced: drift.Value(isSynced),
      );
}
