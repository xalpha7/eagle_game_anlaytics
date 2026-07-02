import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/MatchSelector/MatchSelector.dart';
import 'package:lila_black_analytics/map/PlaybackControlls.dart';
import 'package:lila_black_analytics/map/map_view.dart';
import 'package:lila_black_analytics/map/player_painter.dart';
import 'package:lila_black_analytics/utils/GlassTile.dart';
import 'package:lila_black_analytics/utils/VoiceOrb.dart';

class DashboardScreen extends StatefulWidget {
  final AppSession appSession;

  const DashboardScreen({super.key, required this.appSession});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.appSession.dashboardController;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final bool isMobile = screenWidth < 700;
    final bool isTablet = screenWidth >= 700 && screenWidth < 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        centerTitle: true,
        leading: isMobile ? null : const SizedBox(width: 52),
        title: Text(
          widget.appSession.appName,
          style: TextStyle(fontSize: isMobile ? 16 : 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: isMobile ? 32 : 36,
                height: isMobile ? 32 : 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                  image: DecorationImage(
                    image: AssetImage(widget.appSession.appIcon),
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
          child: Obx(() {
            Widget matchPanel = GlassTile(
              child: MatchSelector(
                appSession: widget.appSession,
                controller: controller,
              ),
            );

            Widget analyticsPanel = GlassTile(
              child: controller.isPlaying.value
                  ? Column(
                      children: [
                        const TelemetryLegend(),
                        const SizedBox(height: 6),
                        Expanded(child: MapView()),
                        const SizedBox(height: 6),
                        PlaybackControls(controller: controller),
                      ],
                    )
                  : VoiceOrb_Retro(appSession: widget.appSession),
            );

            return Padding(
              padding: EdgeInsets.all(isMobile ? 8 : 12),
              child: isMobile
                  // ---------------- MOBILE LAYOUT ----------------
                  ? Column(
                      children: [
                        Expanded(flex: 8, child: analyticsPanel),
                        const SizedBox(height: 10),
                        Expanded(flex: 1, child: matchPanel),
                      ],
                    )
                  // ---------------- TABLET LAYOUT ----------------
                  : isTablet
                  ? Row(
                      children: [
                        Expanded(flex: 6, child: analyticsPanel),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: matchPanel),
                      ],
                    )
                  // ---------------- DESKTOP LAYOUT ----------------
                  : Row(
                      children: [
                        Expanded(flex: 3, child: matchPanel),
                        const SizedBox(width: 12),
                        Expanded(flex: 7, child: analyticsPanel),
                      ],
                    ),
            );
          }),
        ),
      ),
    );
  }
}
