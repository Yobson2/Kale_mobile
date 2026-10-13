import 'package:meta/meta.dart';

/// A currency Kalé can hold money in. Pure Dart, usable from the domain layer.
@immutable
class Currency {
  const Currency({
    required this.code,
    required this.symbol,
    required this.decimalPlaces,
  });

  /// ISO 4217 code, e.g. `XOF`.
  final String code;

  /// Display symbol, e.g. `FCFA`.
  final String symbol;

  /// Number of minor-unit digits: 0 for XOF, 2 for EUR.
  final int decimalPlaces;

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

/// The currencies reference: every currency selectable in Kalé.
///
/// Mirrors the server's currencies table (code, symbol, decimal places).
abstract final class Currencies {
  // CFA francs: no minor unit.
  static const xof = Currency(code: 'XOF', symbol: 'FCFA', decimalPlaces: 0);
  static const xaf = Currency(code: 'XAF', symbol: 'FCFA', decimalPlaces: 0);

  static const ngn = Currency(code: 'NGN', symbol: '₦', decimalPlaces: 2);
  static const ghs = Currency(code: 'GHS', symbol: 'GH₵', decimalPlaces: 2);
  static const kes = Currency(code: 'KES', symbol: 'KSh', decimalPlaces: 2);
  static const ugx = Currency(code: 'UGX', symbol: 'USh', decimalPlaces: 0);
  static const tzs = Currency(code: 'TZS', symbol: 'TSh', decimalPlaces: 0);
  static const rwf = Currency(code: 'RWF', symbol: 'RF', decimalPlaces: 0);
  static const zar = Currency(code: 'ZAR', symbol: 'R', decimalPlaces: 2);
  static const etb = Currency(code: 'ETB', symbol: 'Br', decimalPlaces: 2);
  static const egp = Currency(code: 'EGP', symbol: 'E£', decimalPlaces: 2);
  static const mad = Currency(code: 'MAD', symbol: 'MAD', decimalPlaces: 2);
  static const usd = Currency(code: 'USD', symbol: r'$', decimalPlaces: 2);
  static const eur = Currency(code: 'EUR', symbol: '€', decimalPlaces: 2);

  static const List<Currency> all = [
    xof,
    xaf,
    ngn,
    ghs,
    kes,
    ugx,
    tzs,
    rwf,
    zar,
    etb,
    egp,
    mad,
    usd,
    eur,
  ];

  /// Looks up a currency by ISO code (case-insensitive); null if unsupported.
  static Currency? byCode(String code) {
    final upper = code.toUpperCase();
    for (final currency in all) {
      if (currency.code == upper) return currency;
    }
    return null;
  }
}
