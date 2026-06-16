// lib/views/dashboard_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';
import '../websocket_service.dart';
import 'minimap_viewport.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final wsService = Get.put(WebsocketService());

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text(
          'LILA BLACK Telemetry Suite Pro',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.orangeAccent),
            tooltip: 'Initialize Target Diagnostics Parameters',
            onPressed: () {
              controller.selectedDate.value = "";
              controller.selectedMap.value = "";
              controller.resetPlaybackEngine();
              wsService.sendGetInitData(null);
            },
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Sidebar Control Matrix
          Container(
            width: 320,
            decoration: const BoxDecoration(
              color: Color(0xFF161616),
              border: Border(right: BorderSide(color: Colors.white12)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1. LIFECYCLE MANAGEMENT FILTERS",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Step 1 Selection Flow
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedDate.value.isEmpty
                          ? null
                          : controller.selectedDate.value,
                      hint: const Text(
                        "Select Session Log Date",
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                      dropdownColor: const Color(0xFF1A1A1A),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      items: controller.availableDates
                          .map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          )
                          .toList(),
                      onChanged: (date) {
                        if (date != null) {
                          controller.selectedDate.value = date;
                          controller.selectedMap.value = "";
                          controller.resetPlaybackEngine();
                          wsService.sendGetInitData(date);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Step 2 Selection Flow
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedMap.value.isEmpty
                          ? null
                          : controller.selectedMap.value,
                      hint: const Text(
                        "Filter Spatial Map (Optional)",
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                      dropdownColor: const Color(0xFF1A1A1A),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      items: controller.mapsPlayed
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                      onChanged: (map) {
                        controller.selectedMap.value = map ?? "";
                        controller.resetPlaybackEngine();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step 3 Content Submission Trigger
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text(
                        "FETCH ANALYTICS PAYLOAD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        if (controller.selectedDate.value.isNotEmpty) {
                          wsService.fetchDateData(
                            controller.selectedDate.value,
                            controller.selectedMap.value.isEmpty
                                ? null
                                : controller.selectedMap.value,
                          );
                        }
                      },
                    ),
                  ),

                  const Divider(color: Colors.white12, height: 40),
                  const Text(
                    "2. SPATIAL HEATMAP PROJECTIONS",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => CheckboxListTile(
                      title: const Text(
                        "Traffic Flow Projections",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      value: controller.showTraffic.value,
                      dense: true,
                      onChanged: (v) =>
                          controller.showTraffic.value = v ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text(
                        "Combat Elimination Flashes",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      value: controller.showKills.value,
                      dense: true,
                      onChanged: (v) => controller.showKills.value = v ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text(
                        "Casualty Drop Positions",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      value: controller.showDeaths.value,
                      dense: true,
                      onChanged: (v) =>
                          controller.showDeaths.value = v ?? false,
                    ),
                  ),
                  Obx(
                    () => CheckboxListTile(
                      title: const Text(
                        "Loot Box Interactions",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      value: controller.showLoot.value,
                      dense: true,
                      onChanged: (v) => controller.showLoot.value = v ?? false,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Obx(
                      () => Row(
                        children: [
                          const Text(
                            "Alpha:",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: controller.heatmapOpacity.value,
                              min: 0.1,
                              max: 1.0,
                              activeColor: Colors.orangeAccent,
                              onChanged: (v) =>
                                  controller.heatmapOpacity.value = v,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Central Visualization Workspace Frame & Interactive Table Data Grid Layouts
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Map Viewport Window Frame Layout Area
                      const Expanded(
                        flex: 3,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: MinimapViewport(),
                          ),
                        ),
                      ),

                      // Match Selection Tab Interface Data Grid
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF141414),
                            border: Border(
                              left: BorderSide(color: Colors.white12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "3. CHOOSE LIVE TELEMETRY TARGET MATCH",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(() {
                                  if (controller.matchStats.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        "No operational session logs tracked.",
                                        style: TextStyle(
                                          color: Colors.white24,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    itemCount: controller.matchStats.length,
                                    separatorBuilder: (c, i) => const Divider(
                                      color: Colors.white12,
                                      height: 1,
                                    ),
                                    itemBuilder: (context, idx) {
                                      final match = controller.matchStats[idx];
                                      final bool isTargeted =
                                          controller.selectedMatchId.value ==
                                          match.matchId;

                                      // FIXED: Safe decoration extraction prevents color clash assertion
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: isTargeted
                                              ? Colors.orangeAccent.withOpacity(
                                                  0.08,
                                                )
                                              : Colors.transparent,
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            "Match: ${match.matchId.substring(0, min(8, match.matchId.length))}...",
                                            style: TextStyle(
                                              color: isTargeted
                                                  ? Colors.orangeAccent
                                                  : Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Map: ${match.mapId}\nKills: ${match.kills} | Duration: ${match.durationSeconds}s",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white38,
                                            ),
                                          ),
                                          isThreeLine: true,
                                          trailing: const Icon(
                                            Icons.arrow_right,
                                            color: Colors.white38,
                                          ),
                                          onTap: () {
                                            controller.selectedMatchId.value =
                                                match.matchId;
                                            controller.selectedMap.value =
                                                match.mapId;
                                            wsService.fetchMatchPlayback(
                                              match.matchId,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Replay Control Strip Dashboard Component
                Obx(() {
                  if (controller.startTs.value == 0)
                    return const SizedBox.shrink();

                  final current = controller.currentPlaybackTime.value;
                  final start = controller.startTs.value;
                  final end = controller.endTs.value;
                  final double progressValue = current
                      .clamp(start, end)
                      .toDouble();

                  return Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF161616),
                      border: Border(top: BorderSide(color: Colors.white12)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.isPlaying.value
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                          ),
                          iconSize: 42,
                          color: Colors.orangeAccent,
                          onPressed: () {
                            if (controller.isPlaying.value) {
                              controller.stopTickerLoop();
                            } else {
                              controller.startTickerLoop();
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "${current - start}s",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: progressValue,
                            min: start.toDouble(),
                            max: end.toDouble(),
                            activeColor: Colors.orangeAccent,
                            inactiveColor: Colors.white12,
                            onChanged: (newTimestampValue) {
                              controller.seekTimeline(
                                newTimestampValue.toInt(),
                              );
                            },
                          ),
                        ),
                        Text(
                          "Total: ${controller.totalDuration}s",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
