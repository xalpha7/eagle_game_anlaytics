import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'map_view.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Replay Dashboard'),
        leading: Obx(
          () => controller.isPlaying.value
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: controller.stopGameplay,
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: Obx(() {
        if (controller.isPlaying.value) {
          return Center(child: MapView());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: controller.displayDate.length,
              itemBuilder: (context, index) {
                String date = controller.displayDate[index];
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => {controller.getGameplayFromDate(date: date)},
                  child: Text(
                    date.replaceAll('_', ' '),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
