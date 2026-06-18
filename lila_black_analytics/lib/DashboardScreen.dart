import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/map/PlaybackControlls.dart';
import 'package:lila_black_analytics/map/player_painter.dart';
import 'package:lila_black_analytics/utils/GlassTile.dart';
import 'package:lila_black_analytics/MatchSelector.dart';
import 'package:lila_black_analytics/utils/VoiceOrb.dart';
import 'map/map_view.dart';

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
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        centerTitle: true,

        leading: const SizedBox(width: 52),

        title: Text(widget.appSession.appName),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                  image: DecorationImage(
                    image: AssetImage(widget.appSession.appIcon), //
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0B0F), Color(0xFF13151A), Color(0xFF0D1117)],
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                children: [
                  Expanded(
                    child: GlassTile(
                      child: MatchSelector(appSession: widget.appSession),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GlassTile(
                      child: controller.isPlaying.value
                          ? Column(
                              children: [
                                TelemetryLegend(),
                                const SizedBox(height: 6),
                                Expanded(child: MapView()),

                                const SizedBox(height: 6),

                                PlaybackControls(controller: controller),
                              ],
                            )
                          : VoiceOrb_Retro(appSession: widget.appSession),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
