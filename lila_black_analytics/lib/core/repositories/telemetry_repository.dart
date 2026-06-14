import 'dart:typed_data';
import '../api/api_client.dart';
import '../models/match_response.dart';
import '../models/match_stats_response.dart';

class TelemetryRepository {
  final ApiClient _apiClient;

  TelemetryRepository(this._apiClient);

  Future<List<String>> getMaps() => _apiClient.getMaps();
  
  Future<List<String>> getDates() => _apiClient.getDates();
  
  Future<List<String>> getMatches({String? mapId, String? date}) => 
      _apiClient.getMatches(mapId: mapId, date: date);

  Future<MatchResponse> getMatch(String matchId) => _apiClient.getMatch(matchId);
  
  Future<MatchStatsResponse> getStats(String matchId) => _apiClient.getStats(matchId);

  Future<Uint8List> getHeatmap(String mapId, String heatmapType) => 
      _apiClient.getHeatmap(mapId, heatmapType);
}