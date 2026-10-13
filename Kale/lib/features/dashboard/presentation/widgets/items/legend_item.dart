import 'package:flutter/material.dart';
import 'package:kale/core/money/money.dart';

class LegendItem {
  const LegendItem({
    required this.name,
    required this.color,
    required this.amount,
  });

  final String name;
  final Color color;
  final Money amount;
}
