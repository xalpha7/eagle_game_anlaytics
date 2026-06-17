import 'dart:async';
import 'package:get/get.dart';
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
  WebsocketService wsSocket;
  DashboardController({required this.wsSocket});
  // --- State Variables ---
  var displayDate = <String>[].obs;
  var isPlaying = false.obs;
  var currentMapImage = ''.obs;
  late WebsocketService apiSocket;

  // Map to hold active players based on user_id to easily update their positions
  var activePlayers = <String, PlayerPosition>{}.obs;

  Timer? _gameTimer;
  List<dynamic> _timelineData = [];
  int _currentFrame = 0;

  @override
  void onInit() {
    super.onInit();
    apiSocket = Get.find<WebsocketService>();
    _loadDates();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }

  void _loadDates() {
    // Populate the initial dates list
    displayDate.assignAll([
      "February_10",
      "February_11",
      "February_12",
      "February_13",
    ]);
  }

  // Triggered when a user taps a date tile
  // ignore: strict_top_level_inference
  void runGameplay({required timelineData, required mapName}) {
    // print("timelineData>>" + timelineData.toString());
    // print("mapName>>" + mapName.toString());
    currentMapImage.value = 'assets/minimaps/${mapName}_Minimap.png';

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

  void getGameplayFromDate({required date}) {
    apiSocket.senddata(action: "fetch_match_playback", data: date);
  }

  void stopGameplay() {
    _gameTimer?.cancel();
    isPlaying.value = false;
    activePlayers.clear();
  }
}
