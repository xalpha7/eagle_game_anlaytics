// lib/websocket_service.dart

// ignore_for_file: strict_top_level_inference

import 'dart:convert';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService extends GetxService {
  AppSession appSession;
  WebsocketService({required this.appSession});
  WebSocketChannel? _channel;
  final String socketUri = 'wss://eagle-game-anlaytics.onrender.com/ws';
  // final String socketUri = 'ws://localhost:10000/ws';
  // final dashcontroller = Get.put(DashboardController());

  @override
  void onInit() {
    super.onInit();

    print("calling the websocket init cal");

    connect();

    Future.delayed(const Duration(seconds: 1), () {
      senddata(action: "get_init_data", data: null);
    });
  }

  void connect() {
    try {
      print("connecting to websocket");
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
      // print("connecting ???" + message.toString());

      final Map<String, dynamic> jsonFrame = jsonDecode(message);
      final String packetType = jsonFrame['type'] ?? '';

      switch (packetType) {
        case 'init_data':
          var dates = jsonFrame['date'] ?? [];
          var maps = jsonFrame['maps'] ?? [];

          appSession.dashboardController.displayDate.value = dates;
          appSession.dashboardController.availableMaps.value = maps;

          break;

        case 'get_heatmap_data':
          final heatmapPayload = jsonFrame['data'] ?? {};
          final heatmapData = heatmapPayload['heatmap'] ?? null;
          print("heatmapData>>" + heatmapData.toString());
          appSession.dashboardController.loadHeatMapFromApi(heatmapData);
          break;
        case 'get_matches_per_date':
          var mapsPayload = jsonFrame['data'] ?? {};
          final all_maps = mapsPayload.entries
              .map((e) => [e.key, e.value])
              .toList();
          appSession.dashboardController.updateMatches(all_maps);
          break;

        case 'game_play':
          final Map<String, dynamic> gamePlayPayload = jsonFrame['data'] ?? {};
          var metadata = gamePlayPayload['metadata'] ?? {};
          var timelinedata = gamePlayPayload['timeline'] ?? {};
          var mapName = metadata['map_id'] ?? {};
          var match_id = metadata['match_id'] ?? null;
          var match_date = metadata['match_date'] ?? null;

          appSession.dashboardController.runGameplay(
            mapName: mapName,
            timelineData: timelinedata,
          );

          Future.delayed(const Duration(seconds: 1), () {
            senddata(
              action: "get_heatmap_data",
              data: match_date,
              data_2: match_id,
            );
          });
      }
    } catch (e) {
      print("Error executing payload serialization pipeline: $e");
    }
  }

  // UI Lifecycle Outbound Triggers
  void senddata({required action, required data, data_2}) {
    print({"action": action, "data": data, "data_2": data_2}.toString());
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({"action": action, "data": data, "data_2": data_2}),
      );
    }
  }

  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }
}
