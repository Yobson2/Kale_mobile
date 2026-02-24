import 'package:flutter/material.dart';

class LegendItem {
  const LegendItem({
    required this.name,
    required this.color,
    required this.amount,
  });

  final String name;
  final Color color;
  final double amount;
}
