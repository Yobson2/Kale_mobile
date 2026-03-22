import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/widgets/loading/app_shimmer_list.dart';
import 'package:kale/core/widgets/states/app_error_state.dart';

/// Generic widget for handling [AsyncValue] loading, error, and data states.
///
/// Uses [AppShimmerList] for loading and [AppErrorState] for errors by default.
class AsyncValueWidget<T> extends StatelessWidget {
  /// Creates an [AsyncValueWidget].
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.loadingItemCount = 3,
    super.key,
  });

  /// The async value to render.
  final AsyncValue<T> value;

  /// Builder for the data state.
  final Widget Function(T data) data;

  /// Optional custom loading widget.
  final Widget? loading;

  /// Optional custom error widget builder.
  final Widget Function(Object error, StackTrace? stack)? error;

  /// Number of shimmer items to show when loading (default 3).
  final int loadingItemCount;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () =>
          loading ?? AppShimmerList(itemCount: loadingItemCount),
      error: (err, stack) =>
          error?.call(err, stack) ??
          AppErrorState(
            message: err.toString(),
            onRetry: null,
          ),
      data: data,
    );
  }
}
