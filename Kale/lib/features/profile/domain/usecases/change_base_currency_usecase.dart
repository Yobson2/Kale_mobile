import 'package:dartz/dartz.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/usecase/usecase.dart';
import 'package:kale/features/profile/domain/repositories/profile_repository.dart';
import 'package:kale/features/transactions/domain/repositories/transactions_repository.dart';

/// What happened to a base-currency change request.
enum BaseCurrencyChange {
  /// The base currency is now the requested one.
  changed,

  /// Nothing changed: the account has transactions, so the change would
  /// relabel their amounts without converting them. Ask the user, then
  /// call again with `relabelConfirmed: true`.
  needsRelabelConfirmation,
}

/// Sets the account's base currency (decision Q12).
///
/// Free while the account has no transactions. Afterwards it is a relabel
/// (amounts keep their numbers, no conversion), allowed only once the user
/// has confirmed a warning.
class ChangeBaseCurrencyUseCase
    extends UseCase<BaseCurrencyChange, ChangeBaseCurrencyParams> {
  const ChangeBaseCurrencyUseCase({
    required ProfileRepository profileRepository,
    required TransactionsRepository transactionsRepository,
  })  : _profile = profileRepository,
        _transactions = transactionsRepository;

  final ProfileRepository _profile;
  final TransactionsRepository _transactions;

  @override
  Future<Either<Failure, BaseCurrencyChange>> call(
    ChangeBaseCurrencyParams params,
  ) async {
    if (!params.relabelConfirmed) {
      final count = await _transactions.countTransactions();
      final countFailure = count.fold<Failure?>((f) => f, (_) => null);
      if (countFailure != null) return Left(countFailure);

      final current = await _profile.getBaseCurrency();
      final isChange = current.fold((_) => true, (c) => c != params.currency);
      if (count.getOrElse(() => 0) > 0 && isChange) {
        return const Right(BaseCurrencyChange.needsRelabelConfirmation);
      }
    }
    final saved = await _profile.setBaseCurrency(params.currency);
    return saved.map((_) => BaseCurrencyChange.changed);
  }
}

/// Parameters for [ChangeBaseCurrencyUseCase].
class ChangeBaseCurrencyParams {
  const ChangeBaseCurrencyParams({
    required this.currency,
    this.relabelConfirmed = false,
  });

  final Currency currency;

  /// The user accepted that existing amounts are relabelled, not converted.
  final bool relabelConfirmed;
}
