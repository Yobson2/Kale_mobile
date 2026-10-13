import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';

/// The base currency used until the user has chosen one.
const defaultBaseCurrency = Currencies.xof;

/// The account profile: for now, the account's base currency.
///
/// Every amount in the app is in the base currency (decision Q4). There is
/// no per-entry currency and no conversion.
abstract class ProfileRepository {
  /// Watches the base currency; emits null until one is chosen.
  Stream<Currency?> watchBaseCurrency();

  /// Gets the base currency, or null if none was chosen yet.
  Future<Either<Failure, Currency?>> getBaseCurrency();

  /// Stores [currency] as the base currency on the device and queues it
  /// for the server. No amount is converted.
  Future<Either<Failure, Currency>> setBaseCurrency(Currency currency);

  /// Pulls the profile from the server, keeping unsynced local changes.
  Future<Either<Failure, void>> refreshFromServer();
}
