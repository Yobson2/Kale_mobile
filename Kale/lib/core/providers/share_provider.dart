import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/services/share_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_provider.g.dart';

/// Provides the [ShareService] (overridden in tests).
@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) => const PlatformShareService();
