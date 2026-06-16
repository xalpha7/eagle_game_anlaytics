// lib/websocket_service.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dashboard_controller.dart';
import 'models.dart';

class WebsocketService extends GetxService {
  WebSocketChannel? _channel;
  final String socketUri = 'ws://localhost:8765/ws';
  late DashboardController _controller;

  @override
  void onInit() {
    super.onInit();
    _controller = Get.find<DashboardController>();
    connectToPipeline();
  }

  void connectToPipeline() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(socketUri));
      _channel!.stream.listen(
        (message) => _parseIncomingFrame(message),
        onError: (err) => print('Asynchronous Pipeline WebSocket Error: $err'),
        onDone: () => print('Asynchronous Pipeline Interface Disconnected'),
      );

      // Auto-trigger initialization request on connection mount
      sendGetInitData(null);
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

          _controller.availableDates.value = dates;
          _controller.mapsPlayed.value = maps;
          break;

        case 'match_stats':
          final List statsData = jsonFrame['data'] ?? [];
          _controller.matchStats.value = statsData
              .map((s) => MatchStat.fromJson(s))
              .toList();
          break;

        case 'heatmap_data':
          final Map<String, dynamic> mapsPayload = jsonFrame['heatmaps'] ?? {};
          _controller.updateHeatmaps(mapsPayload);
          break;

        case 'match_playback_timeline':
          final Map<String, dynamic> pipelineData = jsonFrame['data'] ?? {};
          _controller.setupPlayback(pipelineData);
          break;
      }
    } catch (e) {
      print("Error executing payload serialization pipeline: $e");
    }
  }

  // UI Lifecycle Outbound Triggers
  void sendGetInitData(String? targetedDate) {
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({"action": "get_init_data", "date": targetedDate}),
      );
    }
  }

  void fetchDateData(String date, String? mapIdFilter) {
    if (_channel != null) {
      final payload = {"action": "fetch_date_data", "date": date};
      if (mapIdFilter != null && mapIdFilter.isNotEmpty) {
        payload["map_id"] = mapIdFilter;
      }
      _channel!.sink.add(jsonEncode(payload));
    }
  }

  void fetchMatchPlayback(String matchId) {
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({"action": "fetch_match_playback", "match_id": matchId}),
      );
    }
  }

  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }
}
