import 'dart:async';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/websocket_service.dart';

// --- Data Models ---
class PlayerPosition {
  final String userId;
  final bool isBot;
  final double pixelX;
  final double pixelY;
  final String event; // Added event type

  PlayerPosition({
    required this.userId,
    required this.isBot,
    required this.pixelX,
    required this.pixelY,
    required this.event,
  });
}

class DashboardController extends GetxController {
  // --- State Variables ---

  var isPlaying = false.obs;
  var currentMapImage = ''.obs;
  AppSession appSession;
  DashboardController({required this.appSession});

  // Map to hold active players based on user_id to easily update their positions
  var activePlayers = <String, PlayerPosition>{}.obs;

  Timer? _gameTimer;
  List<dynamic> _timelineData = [];
  int _currentFrame = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }

  // =================== match selector ui ==================
  final Rxn selectedDate = Rxn();
  final Rxn selectedMap = Rxn();
  final Rxn selectedMatch = Rxn();
  final RxInt matchSelectionMode = 1.obs;
  final RxList displayDate = [].obs;
  final RxList availableMaps = [].obs;
  final RxList availableMatches = [].obs;

  /// Filtered matches for selected map
  final RxList relevantMatches = [].obs;

  final RxBool showRadioButtons = false.obs;
  final RxBool showPlayHighestPlayersButton = false.obs;
  final RxBool showAllMatchesDropdown = false.obs;
  final RxBool showPlaySelectedMatchButton = false.obs;

  void _updateUi() {
    showRadioButtons.value = selectedDate.value != null;
    showPlayHighestPlayersButton.value =
        selectedDate.value != null && matchSelectionMode.value == 1;
    showAllMatchesDropdown.value =
        selectedDate.value != null && matchSelectionMode.value == 2;
    showPlaySelectedMatchButton.value = selectedMatch.value != null;
  }

  void onDateSelected(dynamic value) {
    selectedDate.value = value;
    selectedMap.value = null;
    selectedMatch.value = null;
    availableMaps.clear();
    availableMatches.clear();
    relevantMatches.clear();
    _updateUi();
  }

  void onMatchModeChanged(int value) {
    matchSelectionMode.value = value;
    selectedMap.value = null;
    selectedMatch.value = null;
    availableMaps.clear();
    availableMatches.clear();
    relevantMatches.clear();
    if (value == 2) {
      loadMatchesList();
    }
    _updateUi();
  }

  void onMapSelected(dynamic value) {
    selectedMap.value = value;
    selectedMatch.value = null;
    relevantMatches.assignAll(
      availableMatches.where((match) => match[1] == value),
    );
    _updateUi();
  }

  void onMatchSelected(dynamic value) {
    selectedMatch.value = value;
    _updateUi();
  }

  /// Build map dropdown from availableMatches
  void buildAvailableMaps() {
    final maps = availableMatches.map((e) => e[1]).toSet().toList();
    availableMaps.assignAll(maps);
  }

  Future<void> loadMatchesList() async {
    availableMatches.clear();
    availableMaps.clear();
    relevantMatches.clear();

    appSession.websocketService.senddata(
      action: "get_matches_per_date",
      data: selectedDate.value,
    );
  }

  void updateMatches(List matches) {
    availableMatches.assignAll(matches);
    buildAvailableMaps();
    _updateUi();
  }

  Future<void> playHighestPlayerMatch() async {
    if (selectedDate.value == null) return;
    appSession.websocketService.senddata(
      action: "get_match_playback",
      data: selectedDate.value,
    );
  }

  Future<void> playSelectedMatch() async {
    if (selectedDate.value == null ||
        selectedMap.value == null ||
        selectedMatch.value == null) {
      return;
    }
    final matchId = selectedMatch.value[0];
    appSession.websocketService.senddata(
      action: "get_match_playback",
      data: selectedDate.value,
      data_2: matchId,
    );
  }

  // ----------------------------------------
  // ========================================= =======================
  // Triggered when a user taps a date tile
  // ignore: strict_top_level_inference
  void runGameplay({required timelineData, required mapName}) {
    // print("timelineData>>" + timelineData.toString());
    // print("mapName>>" + mapName.toString());
    var imgExtension = "png";
    if (mapName == "Lockdown") {
      imgExtension = "jpg";
    }
    currentMapImage.value = 'minimaps/${mapName}_Minimap.${imgExtension}';

    _timelineData = timelineData;

    isPlaying.value = true;
    _currentFrame = 0;
    activePlayers.clear();

    // 2. Start the game loop timer
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_currentFrame >= _timelineData.length) {
        timer.cancel(); // End of timeline
        return;
      }

      _processFrame(_timelineData[_currentFrame]);
      _currentFrame++;
    });
  }

  void _processFrame(Map<String, dynamic> frame) {
    List<dynamic> events = frame['events'];

    for (var event in events) {
      var id = event['user_id'];

      // Update or add the player position
      activePlayers[id] = PlayerPosition(
        userId: id,
        isBot: event['is_bot'] ?? false,
        pixelX: (event['pixel_x'] as num).toDouble(),
        pixelY: (event['pixel_y'] as num).toDouble(),
        event: event['event'] ?? 'Position', // Extract event type
      );
    }
  }

  void stopGameplay() {
    _gameTimer?.cancel();
    isPlaying.value = false;
    activePlayers.clear();
  }
}
