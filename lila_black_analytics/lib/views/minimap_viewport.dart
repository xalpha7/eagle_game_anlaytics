// lib/views/minimap_viewport.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';
import 'telemetry_painter.dart';

class MinimapViewport extends StatelessWidget {
  const MinimapViewport({Key? key}) : super(key: key);

  String _determineAssetUnderlay(String activeMapId) {
    switch (activeMapId) {
      case 'AmbroseValley':
        return 'assets/minimaps/AmbroseValley_Minimap.png';
      case 'GrandRift':
        return 'assets/minimaps/GrandRift_Minimap.png';
      case 'Lockdown':
        return 'assets/minimaps/Lockdown_Minimap.jpg';
      default:
        return ''; // Blanks canvas rendering path if empty
    }
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return AspectRatio(
      aspectRatio:
          1.0, // Enforces strict 1:1 mathematical bounds across screen resizing adjustments
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: 1024,
            height: 1024,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.grey[950],
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Obx(() {
              final String currentMap = controller.selectedMap.value;
              final String bgAsset = _determineAssetUnderlay(currentMap);

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Layer 1: Static Level Designer Mapping Backdrop
                  if (bgAsset.isNotEmpty)
                    Image.asset(bgAsset, fit: BoxFit.cover),

                  // Layer 2: Dynamic Spatial Processing Overlay Sub-Layers
                  _buildHeatmapOverlay(
                    controller.showTraffic.value,
                    controller.trafficBase64.value,
                    controller.heatmapOpacity.value,
                  ),
                  _buildHeatmapOverlay(
                    controller.showKills.value,
                    controller.killsBase64.value,
                    controller.heatmapOpacity.value,
                  ),
                  _buildHeatmapOverlay(
                    controller.showDeaths.value,
                    controller.deathsBase64.value,
                    controller.heatmapOpacity.value,
                  ),
                  _buildHeatmapOverlay(
                    controller.showLoot.value,
                    controller.lootBase64.value,
                    controller.heatmapOpacity.value,
                  ),

                  // Layer 3: Interactive Vector Painting Element Engine Canvas
                  if (controller.playbackEvents.isNotEmpty)
                    CustomPaint(
                      size: const Size(1024, 1024),
                      painter: TelemetryPainter(
                        historicalEvents: controller.playbackEvents,
                        currentPlaybackTime:
                            controller.currentPlaybackTime.value,
                      ),
                    ),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildHeatmapOverlay(
    bool isVisible,
    String base64Data,
    double baseOpacity,
  ) {
    if (!isVisible || base64Data.isEmpty) return const SizedBox.shrink();
    return Opacity(
      opacity: baseOpacity,
      child: Image.memory(
        base64Decode(base64Data),
        fit: BoxFit.fill,
        gaplessPlayback: true,
      ),
    );
  }
}
