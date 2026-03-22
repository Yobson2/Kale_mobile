import 'package:flutter/material.dart';

/// A themed segmented control built on Material 3's [SegmentedButton].
///
/// Replaces inline toggle chips/buttons with a consistent, accessible control.
class AppSegmentedControl<T extends Object> extends StatelessWidget {
  /// Creates an [AppSegmentedControl].
  const AppSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.showSelectedIcon = false,
    super.key,
  });

  /// The segments to display with their labels and values.
  final List<AppSegment<T>> segments;

  /// The currently selected value(s).
  final Set<T> selected;

  /// Called when selection changes.
  final ValueChanged<Set<T>> onSelectionChanged;

  /// Whether multiple segments can be selected at once.
  final bool multiSelectionEnabled;

  /// Whether to show the check icon on the selected segment.
  final bool showSelectedIcon;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments
          .map(
            (s) => ButtonSegment<T>(
              value: s.value,
              label: Text(s.label),
              icon: s.icon != null ? Icon(s.icon) : null,
            ),
          )
          .toList(),
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: multiSelectionEnabled,
      showSelectedIcon: showSelectedIcon,
    );
  }
}

/// A single segment in an [AppSegmentedControl].
class AppSegment<T> {
  /// Creates an [AppSegment].
  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
  });

  /// The value this segment represents.
  final T value;

  /// Display label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;
}
