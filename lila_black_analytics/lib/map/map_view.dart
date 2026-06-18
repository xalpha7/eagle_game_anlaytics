import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/DashboardController.dart';

import 'package:lila_black_analytics/map/HeatMapPainter.dart';
import 'package:lila_black_analytics/map/player_painter.dart';

class MapView extends StatelessWidget {
  MapView({super.key});

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(0),
        child: Obx(
          () => Stack(
            children: [
              /// MAP IMAGE
              Positioned.fill(
                child: Image.asset(
                  controller.currentMapImage.value,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Center(child: Text('Map Image Not Found'));
                  },
                ),
              ),

              /// HEATMAP LAYER
              Positioned.fill(
                child: CustomPaint(
                  painter: HeatMapPainter(
                    traffic: controller.trafficHeatMap.value,
                    kills: controller.killsHeatMap.value,
                    deaths: controller.deathsHeatMap.value,
                  ),
                ),
              ),

              /// PLAYER LAYER
              Positioned.fill(
                child: CustomPaint(
                  painter: PlayerPainter(
                    players: controller.activePlayers.values.toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
