import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lila_black_analytics/config/app_config.dart';
import 'package:lila_black_analytics/core/models/event_models.dart';
import 'package:lila_black_analytics/core/models/match_response.dart';
import 'package:lila_black_analytics/core/providers/api_provider.dart';
import 'package:lila_black_analytics/core/providers/app_state_providers.dart';

import 'replay_state.dart';

// Parsed and grouped match data for high-speed rendering
class ProcessedMatchData {
  final Map<String, List<EventModel>> userPaths;
  final List<EventModel> allEvents; // sorted chronologically
  ProcessedMatchData(this.userPaths, this.allEvents);
}

final matchDataProvider = FutureProvider<MatchResponse>((ref) async {
  final matchId = ref.watch(selectedMatchIdProvider);
  if (matchId == null) throw Exception('No match selected');
  return ref.watch(telemetryRepositoryProvider).getMatch(matchId);
});

final processedMatchDataProvider = Provider<ProcessedMatchData?>((ref) {
  final matchAsync = ref.watch(matchDataProvider);
  return matchAsync.whenOrNull(
    data: (match) {
      final sortedEvents = List<EventModel>.from(match.events)
        ..sort((a, b) => a.ts.compareTo(b.ts));
      
      final Map<String, List<EventModel>> paths = {};
      for (var event in sortedEvents) {
        paths.putIfAbsent(event.userId, () => []).add(event);
      }
      
      // Auto-initialize replay timeline bounds based on data
      if (sortedEvents.isNotEmpty) {
        Future.microtask(() => ref.read(replayControllerProvider.notifier)
            .initializeBounds(sortedEvents.first.ts, sortedEvents.last.ts));
      }
      
      return ProcessedMatchData(paths, sortedEvents);
    },
  );
});

final replayControllerProvider = StateNotifierProvider<ReplayController, ReplayState>((ref) {
  return ReplayController();
});

class ReplayController extends StateNotifier<ReplayState> {
  ReplayController() : super(const ReplayState());
  
  Timer? _ticker;

  void initializeBounds(int minTime, int maxTime) {
    state = state.copyWith(
      minTime: minTime,
      maxTime: maxTime,
      currentPlaybackTime: minTime,
      isPlaying: false,
    );
  }

  void play() {
    if (state.isPlaying) return;
    if (state.currentPlaybackTime >= state.maxTime) {
      seek(state.minTime.toDouble()); // Auto restart
    }
    state = state.copyWith(isPlaying: true);
    _ticker = Timer.periodic(const Duration(milliseconds: AppConfig.playbackTickMs), (timer) {
      final step = (AppConfig.playbackTickMs * state.speed).toInt();
      final nextTime = state.currentPlaybackTime + step;
      
      if (nextTime >= state.maxTime) {
        state = state.copyWith(currentPlaybackTime: state.maxTime, isPlaying: false);
        timer.cancel();
      } else {
        state = state.copyWith(currentPlaybackTime: nextTime);
      }
    });
  }

  void pause() {
    state = state.copyWith(isPlaying: false);
    _ticker?.cancel();
  }

  void seek(double time) {
    state = state.copyWith(currentPlaybackTime: time.toInt());
  }

  void setSpeed(int speed) {
    state = state.copyWith(speed: speed);
  }

  void reset() {
    pause();
    state = state.copyWith(currentPlaybackTime: state.minTime);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}