import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_state_providers.dart';
import '../../replay/replay_controller.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapsAsync = ref.watch(mapsProvider);
    final datesAsync = ref.watch(datesProvider);
    final matchesAsync = ref.watch(matchesProvider);

    final selectedMap = ref.watch(selectedMapProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedMatchId = ref.watch(selectedMatchIdProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E1E1E),
      child: Row(
        children: [
          const Text('LILA BLACK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent)),
          const SizedBox(width: 32),
          
          // Map Filter
          mapsAsync.when(
            data: (maps) => DropdownButton<String>(
              hint: const Text('Select Map'),
              value: selectedMap,
              items: maps.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) {
                ref.read(selectedMapProvider.notifier).state = val;
                ref.read(selectedMatchIdProvider.notifier).state = null; // reset match
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Error loading maps'),
          ),
          const SizedBox(width: 16),
          
          // Date Filter
          datesAsync.when(
            data: (dates) => DropdownButton<String>(
              hint: const Text('Select Date'),
              value: selectedDate,
              items: dates.map((d) => DropdownMenuItem(value: d, child: Text(d.replaceAll('_', ' ')))).toList(),
              onChanged: (val) {
                ref.read(selectedDateProvider.notifier).state = val;
                ref.read(selectedMatchIdProvider.notifier).state = null; // reset match
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Error loading dates'),
          ),
          const SizedBox(width: 16),

          // Match Filter
          matchesAsync.when(
            data: (matches) => DropdownButton<String>(
              hint: const Text('Select Match'),
              value: selectedMatchId,
              items: matches.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) {
                ref.read(selectedMatchIdProvider.notifier).state = val;
                ref.read(replayControllerProvider.notifier).reset();
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}