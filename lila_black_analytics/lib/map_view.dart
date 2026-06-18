import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'player_painter.dart';

class MapView extends StatelessWidget {
  MapView({Key? key}) : super(key: key);

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    print(
      "controller.currentMapImage.value,>>" +
          controller.currentMapImage.value.toString(),
    );
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(
                () => Image.asset(
                  controller.currentMapImage.value,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text(
                      'Map Image Not Found',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Obx(() {
                return CustomPaint(
                  painter: PlayerPainter(
                    players: controller.activePlayers.values.toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
