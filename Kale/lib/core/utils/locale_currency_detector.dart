import 'dart:ui';

/// Detects the most likely currency code based on the device locale/region.
///
/// Maps African country codes to their local currencies.
/// Falls back to XOF (West African CFA Franc) if the region is unknown.
class LocaleCurrencyDetector {
  LocaleCurrencyDetector._();

  /// Country code → ISO 4217 currency code mapping for supported regions.
  static const _countryToCurrency = <String, String>{
    // BCEAO zone (XOF)
    'SN': 'XOF', // Senegal
    'CI': 'XOF', // Ivory Coast
    'BJ': 'XOF', // Benin
    'ML': 'XOF', // Mali
    'BF': 'XOF', // Burkina Faso
    'TG': 'XOF', // Togo
    'NE': 'XOF', // Niger
    'GW': 'XOF', // Guinea-Bissau

    // BEAC zone (XAF)
    'CM': 'XAF', // Cameroon
    'GA': 'XAF', // Gabon
    'CG': 'XAF', // Republic of Congo
    'TD': 'XAF', // Chad
    'CF': 'XAF', // Central African Republic
    'GQ': 'XAF', // Equatorial Guinea

    // Individual currencies
    'NG': 'NGN', // Nigeria
    'GH': 'GHS', // Ghana
    'KE': 'KES', // Kenya
    'UG': 'UGX', // Uganda
    'TZ': 'TZS', // Tanzania
    'RW': 'RWF', // Rwanda
    'ZA': 'ZAR', // South Africa
    'ET': 'ETB', // Ethiopia
    'EG': 'EGP', // Egypt
    'MA': 'MAD', // Morocco

    // International
    'US': 'USD',
    'FR': 'EUR',
    'DE': 'EUR',
  };

  /// Default currency when region cannot be determined.
  static const defaultCurrency = 'XOF';

  /// Detects the currency code from the device's current locale.
  ///
  /// Uses [PlatformDispatcher.implicitView] locale to determine the
  /// country code, then maps it to the appropriate currency.
  static String detect() {
    final locale = PlatformDispatcher.instance.locale;
    final countryCode = locale.countryCode?.toUpperCase();

    if (countryCode == null || countryCode.isEmpty) {
      return defaultCurrency;
    }

    return _countryToCurrency[countryCode] ?? defaultCurrency;
  }
}
