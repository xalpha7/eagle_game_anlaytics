import 'package:flutter/material.dart';
import 'widgets/filter_panel.dart';
import 'widgets/stats_panel.dart';
import 'widgets/replay_controls.dart';
import '../minimap/minimap_viewer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          // Top Toolbar
          FilterPanel(),
          Divider(height: 1, thickness: 1),
          
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Panel
                StatsPanel(),
                VerticalDivider(width: 1, thickness: 1),
                
                // Center Map View
                Expanded(child: MinimapViewer()),
              ],
            ),
          ),
          
          Divider(height: 1, thickness: 1),
          // Bottom Controls
          ReplayControls(),
        ],
      ),
    );
  }
}