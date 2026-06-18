import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/DashboardController.dart';

class PlaybackControls extends StatelessWidget {
  final DashboardController controller;

  const PlaybackControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Controls + Speed in single row
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 0,
                    alignment: WrapAlignment.center,
                    children: [
                      _controlButton(
                        icon: Icons.restart_alt,
                        tooltip: "Restart",
                        onPressed: controller.restartGameplay,
                      ),

                      _controlButton(
                        icon: Icons.fast_rewind,
                        tooltip: "Rewind",
                        onPressed: () => controller.rewind(frames: 10),
                      ),

                      _controlButton(
                        icon: controller.isPaused.value
                            ? Icons.play_arrow
                            : Icons.pause,
                        tooltip: controller.isPaused.value ? "Play" : "Pause",
                        iconSize: 24,
                        onPressed: () {
                          if (controller.isPaused.value) {
                            controller.resumeGameplay();
                          } else {
                            controller.pauseGameplay();
                          }
                        },
                      ),

                      _controlButton(
                        icon: Icons.fast_forward,
                        tooltip: "Forward",
                        onPressed: () => controller.fastForward(frames: 10),
                      ),

                      _controlButton(
                        icon: Icons.stop,
                        tooltip: "Stop",
                        onPressed: controller.stopGameplay,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                /// Compact Speed Selector
                ToggleButtons(
                  constraints: const BoxConstraints(
                    minWidth: 34,
                    minHeight: 24,
                  ),
                  // visualDensity: VisualDensity.compact,
                  isSelected: [
                    controller.playbackSpeed.value == 0.5,
                    controller.playbackSpeed.value == 1,
                    controller.playbackSpeed.value == 2,
                    controller.playbackSpeed.value == 4,
                  ],
                  onPressed: (index) {
                    const speeds = [0.5, 1.0, 2.0, 4.0];
                    controller.setSpeed(speeds[index]);
                  },
                  children: const [
                    Text("0.5"),
                    Text("1"),
                    Text("2"),
                    Text("4"),
                  ],
                ),
              ],
            ),

            /// Timeline
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: controller.timelineProgress.value,
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: controller.seekToFrameByProgress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    double iconSize = 20,
  }) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
      splashRadius: 16,
      iconSize: iconSize,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
