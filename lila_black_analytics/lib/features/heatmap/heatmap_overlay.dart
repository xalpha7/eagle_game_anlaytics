import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'heatmap_provider.dart';

class HeatmapOverlay extends ConsumerWidget {
  const HeatmapOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(heatmapOverlayEnabledProvider);
    final opacity = ref.watch(heatmapOpacityProvider);
    final heatmapAsync = ref.watch(heatmapImageProvider);

    if (!isEnabled) return const SizedBox.shrink();

    return heatmapAsync.when(
      data: (bytes) {
        if (bytes == null) return const SizedBox.shrink();
        return Opacity(
          opacity: opacity,
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Icon(Icons.error, color: Colors.red)),
    );
  }
}