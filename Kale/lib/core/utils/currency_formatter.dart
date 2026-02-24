import 'package:intl/intl.dart';
import 'package:kale/core/constants/currencies.dart';

/// Formats amounts with correct currency symbols.
class CurrencyFormatter {
  const CurrencyFormatter._();

  /// Formats [amount] with the given [currencyCode].
  static String format(
    double amount, {
    String currencyCode = 'XOF',
    bool showSymbol = true,
    bool compact = false,
  }) {
    final currency = SupportedCurrencies.byCode(currencyCode) ??
        SupportedCurrencies.defaultCurrency;

    final formatter = NumberFormat.currency(
      symbol: showSymbol ? '${currency.symbol} ' : '',
      decimalDigits: currency.decimalPlaces,
      locale: _localeForCurrency(currencyCode),
    );

    if (compact && amount.abs() >= 1000) {
      return _formatCompact(amount, currency);
    }

    return formatter.format(amount);
  }

  /// Formats amount in compact form (e.g., 1.2K, 3.5M).
  static String _formatCompact(double amount, Currency currency) {
    final compact = NumberFormat.compactCurrency(
      symbol: '${currency.symbol} ',
      decimalDigits: currency.decimalPlaces > 0 ? 1 : 0,
    );
    return compact.format(amount);
  }

  /// Returns appropriate locale for currency formatting.
  static String _localeForCurrency(String code) {
    switch (code) {
      case 'XOF':
      case 'XAF':
        return 'fr';
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'fr_FR';
      default:
        return 'en';
    }
  }
}
