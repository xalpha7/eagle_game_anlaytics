import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/MatchSelector.dart';
import 'map_view.dart';

class DashboardScreen extends StatefulWidget {
  AppSession appSession;
  DashboardScreen({super.key, required this.appSession});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController controller;

  @override
  void initState() {
    controller = widget.appSession.dashboardController;
    super.initState();
  }

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
          return MatchSelector(appSession: widget.appSession);
        }
      }),
    );
  }
}
