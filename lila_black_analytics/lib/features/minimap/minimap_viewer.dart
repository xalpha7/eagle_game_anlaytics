import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_state_providers.dart';
import '../replay/replay_controller.dart';
import '../heatmap/heatmap_overlay.dart';
import 'painters/path_painter.dart';
import 'painters/event_painter.dart';

class MinimapViewer extends ConsumerWidget {
  const MinimapViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapId = ref.watch(selectedMapProvider);
    final processedData = ref.watch(processedMatchDataProvider);
    final playbackTime = ref.watch(replayControllerProvider.select((state) => state.currentPlaybackTime));

    if (mapId == null) {
      return const Center(child: Text('Select a Map and Match to begin analysis.'));
    }

    String mapAsset;
    if (mapId == 'Lockdown') {
      mapAsset = 'assets/minimaps/Lockdown_Minimap.jpg';
    } else {
      mapAsset = 'assets/minimaps/${mapId}_Minimap.png';
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.1,
      maxScale: 10.0,
      constrained: false,
      child: Stack(
        children: [
          // Layer 1: Minimap Image
          Image.asset(mapAsset, fit: BoxFit.cover),
          
          // Constrain subsequent layers to match the Image bounds.
          Positioned.fill(
            child: Stack(
              children: [
                // Layer 2: Heatmap Overlay
                const Positioned.fill(child: HeatmapOverlay()),
                
                // Layer 3: Paths
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: PathPainter(processedData, playbackTime),
                    ),
                  ),
                ),
                
                // Layer 4: Events
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: EventPainter(processedData, playbackTime),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}