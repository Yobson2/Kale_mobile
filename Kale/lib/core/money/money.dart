import 'package:intl/intl.dart';
import 'package:kale/core/money/currency.dart';
import 'package:meta/meta.dart';

export 'package:kale/core/money/currency.dart';

/// An exact amount of money: an integer count of minor units in a [currency].
///
/// Pure Dart (no Flutter), usable from the domain layer. Arithmetic stays in
/// integers and refuses to mix currencies (throws [ArgumentError]).
@immutable
class Money implements Comparable<Money> {
  const Money.fromMinorUnits(this.minorUnits, this.currency);

  const Money.zero(this.currency) : minorUnits = 0;

  /// Adds up [amounts], all of which must be in [currency].
  ///
  /// [currency] is required so that an empty list still has a currency.
  factory Money.sum(Iterable<Money> amounts, Currency currency) =>
      amounts.fold(Money.zero(currency), (total, m) => total + m);

  /// Parses what a user typed into an amount field, or returns null if it is
  /// not a valid amount in [currency].
  ///
  /// Follows [locale] (the device locale) with French as fallback: the
  /// locale's grouping separator and any whitespace (including no-break
  /// spaces) are ignored, and the locale's decimal separator marks the
  /// fraction. `.` is also accepted as a decimal separator when the locale
  /// does not use it for grouping, so `10.50` works on a French keyboard.
  ///
  /// Fraction rule: input with more fraction digits than the currency allows
  /// is **rejected, never rounded**. For a 0-decimal currency such as XOF,
  /// any fractional part (even `,0`) is rejected; for EUR, `10,5` and `10,50`
  /// are accepted and `10,505` is rejected.
  static Money? tryParse(String input, Currency currency, {String? locale}) {
    final symbols = NumberFormat.decimalPattern(_resolveLocale(locale)).symbols;

    var text = input.replaceAll(RegExp(r'\s'), '');
    if (symbols.GROUP_SEP.trim().isNotEmpty) {
      text = text.replaceAll(symbols.GROUP_SEP, '');
    }

    var negative = false;
    if (text.startsWith('-') || text.startsWith(symbols.MINUS_SIGN)) {
      negative = true;
      text = text.substring(1);
    }

    text = text.replaceAll(symbols.DECIMAL_SEP, '.');
    final match = RegExp(r'^(\d+)(?:\.(\d+))?$').firstMatch(text);
    if (match == null) return null;

    final fraction = match.group(2) ?? '';
    if (fraction.length > currency.decimalPlaces) return null;

    final major = int.tryParse(match.group(1)!);
    final minor =
        int.tryParse(fraction.padRight(currency.decimalPlaces, '0')) ?? 0;
    if (major == null) return null;

    final units = major * _scaleOf(currency) + minor;
    return Money.fromMinorUnits(negative ? -units : units, currency);
  }

  /// The amount in the currency's smallest unit (francs for XOF, cents for EUR).
  final int minorUnits;

  final Currency currency;

  bool get isZero => minorUnits == 0;
  bool get isNegative => minorUnits < 0;
  bool get isPositive => minorUnits > 0;

  Money operator +(Money other) {
    _requireSameCurrency(other);
    return Money.fromMinorUnits(minorUnits + other.minorUnits, currency);
  }

  Money operator -(Money other) {
    _requireSameCurrency(other);
    return Money.fromMinorUnits(minorUnits - other.minorUnits, currency);
  }

  Money operator -() => Money.fromMinorUnits(-minorUnits, currency);

  @override
  int compareTo(Money other) {
    _requireSameCurrency(other);
    return minorUnits.compareTo(other.minorUnits);
  }

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator <=(Money other) => compareTo(other) <= 0;
  bool operator >(Money other) => compareTo(other) > 0;
  bool operator >=(Money other) => compareTo(other) >= 0;

  /// Formats for display, following [locale] (the device locale, e.g. `fr_CI`
  /// or `en-US`) and the currency's decimal places.
  ///
  /// A missing or unsupported [locale] falls back to French, which groups
  /// thousands with U+202F and puts the symbol after the amount: `10 000 FCFA`.
  /// Integer-only: no floating point is involved.
  String format({String? locale, bool withSymbol = true}) {
    final resolved = _resolveLocale(locale);
    final symbols = NumberFormat.decimalPattern(resolved).symbols;
    final scale = _scaleOf(currency);
    final absolute = minorUnits.abs();

    final buffer = StringBuffer()
      ..write(NumberFormat('#,##0', resolved).format(absolute ~/ scale));
    if (currency.decimalPlaces > 0) {
      buffer
        ..write(symbols.DECIMAL_SEP)
        ..write(
          (absolute % scale).toString().padLeft(currency.decimalPlaces, '0'),
        );
    }

    var number = buffer.toString();
    if (withSymbol) {
      final symbolFirst = symbols.CURRENCY_PATTERN.trimLeft().startsWith('¤');
      if (symbolFirst) {
        final spacer =
            RegExp(r'\p{L}$', unicode: true).hasMatch(currency.symbol)
                ? '\u00A0'
                : '';
        number = '${currency.symbol}$spacer$number';
      } else {
        number = '$number\u00A0${currency.symbol}';
      }
    }
    return isNegative ? '${symbols.MINUS_SIGN}$number' : number;
  }

  void _requireSameCurrency(Money other) {
    if (other.currency != currency) {
      throw ArgumentError.value(
        other,
        'other',
        'Cannot combine ${currency.code} with ${other.currency.code}',
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.minorUnits == minorUnits &&
      other.currency == currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => 'Money($minorUnits ${currency.code})';
}

/// The locale used when the device locale is missing or unsupported.
const fallbackMoneyLocale = 'fr';

String _resolveLocale(String? locale) {
  if (locale == null || locale.isEmpty) return fallbackMoneyLocale;
  return Intl.verifiedLocale(
        locale,
        NumberFormat.localeExists,
        onFailure: (_) => fallbackMoneyLocale,
      ) ??
      fallbackMoneyLocale;
}

/// 10^decimalPlaces, computed in integers.
int _scaleOf(Currency currency) {
  var scale = 1;
  for (var i = 0; i < currency.decimalPlaces; i++) {
    scale *= 10;
  }
  return scale;
}
