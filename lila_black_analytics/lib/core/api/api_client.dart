import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:lila_black_analytics/core/models/match_response.dart';
import 'package:lila_black_analytics/core/models/match_stats_response.dart';
import '../../config/app_config.dart';


class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  Future<List<String>> getMaps() async {
    final response = await _dio.get('/maps');
    return List<String>.from(response.data);
  }

  Future<List<String>> getDates() async {
    final response = await _dio.get('/dates');
    return List<String>.from(response.data);
  }

  Future<List<String>> getMatches({String? mapId, String? date}) async {
    final response = await _dio.get(
      '/matches',
      queryParameters: {
        if (mapId != null) 'map_id': mapId,
        if (date != null) 'date': date,
      },
    );
    return List<String>.from(response.data);
  }

  Future<MatchResponse> getMatch(String matchId) async {
    final response = await _dio.get('/matches/$matchId');
    return MatchResponse.fromJson(response.data);
  }

  Future<MatchStatsResponse> getStats(String matchId) async {
    final response = await _dio.get('/matches/$matchId/stats');
    return MatchStatsResponse.fromJson(response.data);
  }

  Future<Uint8List> getHeatmap(String mapId, String heatmapType) async {
    final response = await _dio.get(
      '/heatmap',
      queryParameters: {'map_id': mapId, 'heatmap_type': heatmapType},
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }
}