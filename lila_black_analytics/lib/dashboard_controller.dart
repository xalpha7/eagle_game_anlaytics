// lib/dashboard_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import 'models.dart';

class DashboardController extends GetxController {
  // Step 1 & 2 Lifecycle Properties
  var availableDates = <String>[].obs;
  var selectedDate = "".obs;
  var mapsPlayed = <String>[].obs;
  var selectedMap = "".obs;

  // Step 3 Content Properties
  var matchStats = <MatchStat>[].obs;
  var selectedMatchId = "".obs;

  // Step 4 Spatial Heatmaps Management
  var showTraffic = false.obs;
  var showKills = false.obs;
  var showDeaths = false.obs;
  var showLoot = false.obs;
  var heatmapOpacity = 0.6.obs;

  var trafficBase64 = "".obs;
  var killsBase64 = "".obs;
  var deathsBase64 = "".obs;
  var lootBase64 = "".obs;

  // Step 5 Playback Replay Properties
  var isPlaying = false.obs;
  var startTs = 0.obs;
  var endTs = 0.obs;
  var currentPlaybackTime = 0.obs;
  var playbackEvents = <PlaybackEvent>[].obs;
  Timer? _tickerTimer;

  int get totalDuration => endTs.value - startTs.value;

  void updateHeatmaps(Map<String, dynamic> layers) {
    trafficBase64.value = _cleanBase64String(layers['traffic']);
    killsBase64.value = _cleanBase64String(layers['kills']);
    deathsBase64.value = _cleanBase64String(layers['deaths']);
    lootBase64.value = _cleanBase64String(layers['loot']);
  }

  String _cleanBase64String(dynamic rawValue) {
    if (rawValue == null) return "";
    String base64Str = rawValue.toString();
    if (base64Str.contains(',')) {
      return base64Str.split(',').last; // Strips standard data:image/png;base64 header
    }
    return base64Str;
  }

  void setupPlayback(Map<String, dynamic> playbackData) {
    startTs.value = playbackData['start_ts'] ?? 0;
    endTs.value = playbackData['end_ts'] ?? 0;
    currentPlaybackTime.value = startTs.value;
    
    final List eventsJson = playbackData['events'] ?? [];
    playbackEvents.value = eventsJson.map((e) => PlaybackEvent.fromJson(e)).toList();
    
    // Sort events sequentially to optimize drawing passes
    playbackEvents.sort((a, b) => a.timestampSeconds.compareTo(b.timestampSeconds));
  }

  void startTickerLoop() {
    if (isPlaying.value) return;
    if (currentPlaybackTime.value >= endTs.value) {
      currentPlaybackTime.value = startTs.value;
    }
    
    isPlaying.value = true;
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentPlaybackTime.value >= endTs.value) {
        isPlaying.value = false;
        _tickerTimer?.cancel();
      } else {
        currentPlaybackTime.value += 1; // Tracks timeline progress sequentially
      }
    });
  }

  void stopTickerLoop() {
    isPlaying.value = false;
    _tickerTimer?.cancel();
  }

  void seekTimeline(int targetedTimestamp) {
    stopTickerLoop();
    currentPlaybackTime.value = targetedTimestamp;
  }

  void resetPlaybackEngine() {
    stopTickerLoop();
    playbackEvents.clear();
    startTs.value = 0;
    endTs.value = 0;
    currentPlaybackTime.value = 0;
    selectedMatchId.value = "";
  }

  @override
  void onClose() {
    _tickerTimer?.cancel();
    super.onClose();
  }
}