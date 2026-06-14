import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lila_black_analytics/core/providers/app_state_providers.dart';
import 'package:lila_black_analytics/features/heatmap/heatmap_provider.dart';


class StatsPanel extends ConsumerWidget {
  const StatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(matchStatsProvider);

    return Container(
      width: 300,
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('MATCH STATISTICS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
          Expanded(
            child: statsAsync.when(
              data: (stats) => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _StatRow('Match ID', stats.matchId),
                  _StatRow('Map', stats.mapId),
                  const Divider(),
                  _StatRow('Total Humans', stats.totalHumans.toString()),
                  _StatRow('Total Bots', stats.totalBots.toString()),
                  _StatRow('Duration', '${stats.durationSeconds}s'),
                  const Divider(),
                  _StatRow('Kills', stats.kills.toString(), color: Colors.redAccent),
                  _StatRow('Deaths', stats.deaths.toString(), color: Colors.orangeAccent),
                  _StatRow('Loot Events', stats.loots.toString(), color: Colors.green),
                  _StatRow('Storm Deaths', stats.stormDeaths.toString(), color: Colors.yellow),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(e.toString()))),
            ),
          ),
          const Divider(),
          _buildHeatmapControls(ref),
        ],
      ),
    );
  }

  Widget _StatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.white)),
        ],
      ),
    );
  }

  Widget _buildHeatmapControls(WidgetRef ref) {
    final heatmapEnabled = ref.watch(heatmapOverlayEnabledProvider);
    final opacity = ref.watch(heatmapOpacityProvider);
    final type = ref.watch(heatmapTypeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Heatmap Overlay', style: TextStyle(fontWeight: FontWeight.bold)),
              Switch(
                value: heatmapEnabled,
                onChanged: (val) => ref.read(heatmapOverlayEnabledProvider.notifier).state = val,
              )
            ],
          ),
          if (heatmapEnabled) ...[
            DropdownButton<String>(
              isExpanded: true,
              value: type,
              items: ['TRAFFIC', 'KILLS', 'DEATHS', 'LOOT'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                if (val != null) ref.read(heatmapTypeProvider.notifier).state = val;
              },
            ),
            const SizedBox(height: 8),
            const Text('Opacity', style: TextStyle(fontSize: 12)),
            Slider(
              value: opacity,
              min: 0.0,
              max: 1.0,
              onChanged: (val) => ref.read(heatmapOpacityProvider.notifier).state = val,
            )
          ]
        ],
      ),
    );
  }
}