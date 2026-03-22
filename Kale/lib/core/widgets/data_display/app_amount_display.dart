import 'package:flutter/material.dart';
import 'package:kale/core/theme/app_finance_colors.dart';
import 'package:kale/core/utils/currency_formatter.dart';
import 'package:kale/core/widgets/data_display/app_count_up_text.dart';

/// Displays a currency amount with animated count-up and semantic color coding.
///
/// Automatically colors the amount based on [type]: green for income,
/// red for expense, or default text color for neutral.
class AppAmountDisplay extends StatelessWidget {
  /// Creates an [AppAmountDisplay].
  const AppAmountDisplay({
    required this.amount,
    this.currencyCode = 'XOF',
    this.type = AmountType.neutral,
    this.style,
    this.showSign = false,
    this.animate = true,
    super.key,
  });

  /// The amount to display.
  final double amount;

  /// Currency code for formatting.
  final String currencyCode;

  /// Semantic type that determines the color.
  final AmountType type;

  /// Base text style. Color will be overridden by [type].
  final TextStyle? style;

  /// Whether to show +/- prefix.
  final bool showSign;

  /// Whether to animate the value counting up.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (type) {
      AmountType.income => colorScheme.income,
      AmountType.expense => colorScheme.expense,
      AmountType.neutral => null,
    };

    final effectiveStyle = (style ?? Theme.of(context).textTheme.bodyLarge)
        ?.copyWith(color: color);

    final prefix = showSign
        ? (type == AmountType.income ? '+' : type == AmountType.expense ? '-' : '')
        : '';

    if (animate) {
      return AppCountUpText(
        value: amount,
        style: effectiveStyle,
        formatter: (v) => '$prefix${CurrencyFormatter.format(
          v,
          currencyCode: currencyCode,
        )}',
      );
    }

    return Text(
      '$prefix${CurrencyFormatter.format(
        amount,
        currencyCode: currencyCode,
      )}',
      style: effectiveStyle,
    );
  }
}

/// Semantic type for amount display coloring.
enum AmountType {
  /// Income — displayed in green.
  income,

  /// Expense — displayed in red.
  expense,

  /// Neutral — uses default text color.
  neutral,
}
