import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/providers/api_provider.dart';
import '../../core/providers/app_state_providers.dart';

final heatmapOverlayEnabledProvider = StateProvider<bool>((ref) => false);
final heatmapTypeProvider = StateProvider<String>((ref) => 'TRAFFIC');
final heatmapOpacityProvider = StateProvider<double>((ref) => 0.6);

final heatmapImageProvider = FutureProvider<Uint8List?>((ref) async {
  final enabled = ref.watch(heatmapOverlayEnabledProvider);
  if (!enabled) return null;

  final mapId = ref.watch(selectedMapProvider);
  final type = ref.watch(heatmapTypeProvider);
  if (mapId == null) return null;

  return ref.watch(telemetryRepositoryProvider).getHeatmap(mapId, type);
});