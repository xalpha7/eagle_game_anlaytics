// lib/websocket_service.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService extends GetxService {
  WebSocketChannel? _channel;
  final String socketUri = 'wss://eagle-game-anlaytics.onrender.com/ws';
  // final String socketUri = 'ws://localhost:8765/ws';

  @override
  void onInit() async {
    super.onInit();

    connect();
    // Get.lazyPut(() => DashboardController(), fenix: true);
    await Future.delayed(Duration(seconds: 1));
    senddata(action: "get_init_data", data: null);
  }

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(socketUri));
      _channel!.stream.listen(
        (message) => _parseIncomingFrame(message),
        onError: (err) => print('Asynchronous Pipeline WebSocket Error: $err'),
        onDone: () => print('Asynchronous Pipeline Interface Disconnected'),
      );
    } catch (e) {
      print('Failed to open socket pipeline: $e');
    }
  }

  void _parseIncomingFrame(String message) {
    try {
      final Map<String, dynamic> jsonFrame = jsonDecode(message);
      final String packetType = jsonFrame['type'] ?? '';

      switch (packetType) {
        case 'init_data':
          List<String> dates = List<String>.from(
            jsonFrame['available_dates'] ?? [],
          );
          List<String> maps = List<String>.from(jsonFrame['maps_played'] ?? []);

          break;

        case 'heatmap_data':
          final Map<String, dynamic> mapsPayload = jsonFrame['heatmaps'] ?? {};

          break;

        case 'game_play':
          final Map<String, dynamic> gamePlayPayload = jsonFrame['data'] ?? {};
          var metadata = gamePlayPayload['metadata'] ?? {};
          var timelinedata = gamePlayPayload['timeline'] ?? {};
          var mapName = metadata['map_id'] ?? {};
          final dashController = Get.find<DashboardController>();
          dashController.runGameplay(
            mapName: mapName,
            timelineData: timelinedata,
          );
          print("");
      }
    } catch (e) {
      print("Error executing payload serialization pipeline: $e");
    }
  }

  // UI Lifecycle Outbound Triggers
  void senddata({required action, required data}) {
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({"action": action, "data": data}),
        // jsonEncode({"action": "fetch_match_playback", "data": targetedDate}),
        // jsonEncode({"action": "get_init_data", "date": targetedDate}),
      );
    }
  }

  // void fetchDateData(String date, String? mapIdFilter) {
  //   print("mapIdFilter>>" + mapIdFilter.toString());
  //   if (_channel != null) {
  //     final payload = {"action": "fetch_date_data", "date": date};
  //     if (mapIdFilter != null && mapIdFilter.isNotEmpty) {
  //       payload["map_id"] = mapIdFilter;
  //     }
  //     _channel!.sink.add(jsonEncode(payload));
  //   }
  // }

  // void fetchMatchPlayback(String matchId) {
  //   if (_channel != null) {
  //     _channel!.sink.add(
  //       jsonEncode({"action": "get_match_playback", "match_id": matchId}),
  //     );
  //   }
  // }

  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }
}
