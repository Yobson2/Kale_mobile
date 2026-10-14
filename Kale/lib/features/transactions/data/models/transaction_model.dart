import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kale/core/database/app_database.dart' as db;
import 'package:kale/features/transactions/domain/entities/transaction.dart';
import 'package:kale/features/transactions/domain/entities/transaction_enums.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Data model for [Transaction] with JSON serialization and Drift mapping.
///
/// `amount_minor` is an integer count of minor units of the account's base
/// currency. There is no per-transaction currency.
@freezed
abstract class TransactionModel with _$TransactionModel {
  const TransactionModel._();

  const factory TransactionModel({
    required String id,
    @JsonKey(name: 'server_id') String? serverId,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    required String type,
    @JsonKey(name: 'category_id') required String categoryId,
    String? description,
    required DateTime date,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @Default(false) @JsonKey(name: 'is_recurring') bool isRecurring,
    @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
    @JsonKey(name: 'mobile_money_provider') String? mobileMoneyProvider,
    @JsonKey(name: 'mobile_money_ref') String? mobileMoneyRef,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @Default(true)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSynced,
  }) = _TransactionModel;

  /// Creates a [TransactionModel] from JSON.
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Creates a [TransactionModel] from a Drift database row.
  factory TransactionModel.fromDrift(db.Transaction row) => TransactionModel(
        id: row.id,
        serverId: row.serverId,
        amountMinor: row.amountMinor,
        type: row.type,
        categoryId: row.categoryId,
        description: row.description,
        date: row.date,
        paymentMethod: row.paymentMethod,
        isRecurring: row.isRecurring,
        recurringRuleId: row.recurringRuleId,
        mobileMoneyProvider: row.mobileMoneyProvider,
        mobileMoneyRef: row.mobileMoneyRef,
        accountId: row.accountId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        isSynced: row.isSynced,
      );

  /// Creates a [TransactionModel] from a domain [Transaction] entity.
  factory TransactionModel.fromEntity(Transaction entity) => TransactionModel(
        id: entity.id,
        amountMinor: entity.amountMinor,
        type: entity.type.name,
        categoryId: entity.categoryId,
        description: entity.description,
        date: entity.date,
        paymentMethod: entity.paymentMethod.name,
        isRecurring: entity.isRecurring,
        recurringRuleId: entity.recurringRuleId,
        mobileMoneyProvider: entity.mobileMoneyProvider,
        mobileMoneyRef: entity.mobileMoneyRef,
        accountId: entity.accountId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        isSynced: entity.isSynced,
      );

  /// Converts this model to a domain [Transaction] entity.
  Transaction toEntity() => Transaction(
        id: id,
        amountMinor: amountMinor,
        type: TransactionType.values.firstWhere((e) => e.name == type),
        categoryId: categoryId,
        description: description,
        date: date,
        paymentMethod:
            PaymentMethod.values.firstWhere((e) => e.name == paymentMethod),
        isRecurring: isRecurring,
        recurringRuleId: recurringRuleId,
        mobileMoneyProvider: mobileMoneyProvider,
        mobileMoneyRef: mobileMoneyRef,
        accountId: accountId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isSynced: isSynced,
      );

  /// Converts this model to a Drift companion for insert/update operations.
  db.TransactionsCompanion toDriftCompanion({required bool isSynced}) =>
      db.TransactionsCompanion(
        id: drift.Value(id),
        serverId: serverId != null
            ? drift.Value(serverId)
            : const drift.Value.absent(),
        amountMinor: drift.Value(amountMinor),
        type: drift.Value(type),
        categoryId: drift.Value(categoryId),
        description: drift.Value(description),
        date: drift.Value(date),
        paymentMethod: drift.Value(paymentMethod),
        isRecurring: drift.Value(isRecurring),
        recurringRuleId: drift.Value(recurringRuleId),
        mobileMoneyProvider: drift.Value(mobileMoneyProvider),
        mobileMoneyRef: drift.Value(mobileMoneyRef),
        accountId: drift.Value(accountId),
        createdAt: drift.Value(createdAt),
        updatedAt: drift.Value(updatedAt),
        deletedAt: drift.Value(deletedAt),
        isSynced: drift.Value(isSynced),
      );
}
