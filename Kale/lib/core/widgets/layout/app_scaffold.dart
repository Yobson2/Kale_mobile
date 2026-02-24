import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/providers/connectivity_provider.dart';
import 'package:kale/core/widgets/states/app_offline_banner.dart';

/// Custom scaffold with safe area and connectivity banner.
///
/// Use this instead of [Scaffold] throughout the app.
class AppScaffold extends ConsumerWidget {
  /// Creates an [AppScaffold].
  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.showOfflineBanner = true,
  });

  /// The main content widget.
  final Widget body;

  /// Optional app bar.
  final PreferredSizeWidget? appBar;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional floating action button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional drawer.
  final Widget? drawer;

  /// Background color override.
  final Color? backgroundColor;

  /// Whether to resize when keyboard appears.
  final bool resizeToAvoidBottomInset;

  /// Whether to show the offline connectivity banner.
  final bool showOfflineBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Column(
        children: [
          if (showOfflineBanner && !isOnline) const AppOfflineBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}
