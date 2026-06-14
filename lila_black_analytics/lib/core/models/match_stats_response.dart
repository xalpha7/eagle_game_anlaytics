import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_stats_response.freezed.dart';
part 'match_stats_response.g.dart';

@freezed
class MatchStatsResponse with _$MatchStatsResponse {
  const factory MatchStatsResponse({
    @JsonKey(name: 'match_id') required String matchId,
    @JsonKey(name: 'map_id') required String mapId,
    @JsonKey(name: 'total_humans') required int totalHumans,
    @JsonKey(name: 'total_bots') required int totalBots,
    required int kills,
    required int deaths,
    required int loots,
    @JsonKey(name: 'storm_deaths') required int stormDeaths,
    @JsonKey(name: 'duration_seconds') required int durationSeconds,
  }) = _MatchStatsResponse;

  factory MatchStatsResponse.fromJson(Map<String, dynamic> json) => _$MatchStatsResponseFromJson(json);
  
  @override
  // TODO: implement deaths
  int get deaths => throw UnimplementedError();
  
  @override
  // TODO: implement durationSeconds
  int get durationSeconds => throw UnimplementedError();
  
  @override
  // TODO: implement kills
  int get kills => throw UnimplementedError();
  
  @override
  // TODO: implement loots
  int get loots => throw UnimplementedError();
  
  @override
  // TODO: implement mapId
  String get mapId => throw UnimplementedError();
  
  @override
  // TODO: implement matchId
  String get matchId => throw UnimplementedError();
  
  @override
  // TODO: implement stormDeaths
  int get stormDeaths => throw UnimplementedError();
  
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement totalBots
  int get totalBots => throw UnimplementedError();
  
  @override
  // TODO: implement totalHumans
  int get totalHumans => throw UnimplementedError();
}