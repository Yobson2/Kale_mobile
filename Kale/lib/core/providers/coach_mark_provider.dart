import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kale/core/providers/storage_providers.dart';
import 'package:kale/core/services/coach_mark_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_mark_provider.g.dart';

/// Provides a [CoachMarkService] instance backed by [LocalStorage].
@Riverpod(keepAlive: true)
CoachMarkService coachMarkService(Ref ref) {
  return CoachMarkService(ref.watch(localStorageProvider));
}
