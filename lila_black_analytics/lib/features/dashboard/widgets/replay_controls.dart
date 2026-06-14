import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../replay/replay_controller.dart';

class ReplayControls extends ConsumerWidget {
  const ReplayControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(replayControllerProvider);
    final controller = ref.read(replayControllerProvider.notifier);

    return Container(
      height: 80,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 32,
            onPressed: state.isPlaying ? controller.pause : controller.play,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Slider(
              value: state.currentPlaybackTime.toDouble().clamp(state.minTime.toDouble(), state.maxTime.toDouble()),
              min: state.minTime.toDouble(),
              max: state.maxTime.toDouble() == state.minTime.toDouble() ? state.minTime.toDouble() + 1 : state.maxTime.toDouble(),
              onChanged: (val) {
                controller.pause();
                controller.seek(val);
              },
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<int>(
            value: state.speed,
            items: [1, 2, 5, 10].map((s) => DropdownMenuItem(value: s, child: Text('${s}x Speed'))).toList(),
            onChanged: (val) {
              if (val != null) controller.setSpeed(val);
            },
          ),
        ],
      ),
    );
  }
}