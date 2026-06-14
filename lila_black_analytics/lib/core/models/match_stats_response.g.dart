// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchStatsResponse _$MatchStatsResponseFromJson(Map<String, dynamic> json) =>
    _MatchStatsResponse(
      matchId: json['match_id'] as String,
      mapId: json['map_id'] as String,
      totalHumans: (json['total_humans'] as num).toInt(),
      totalBots: (json['total_bots'] as num).toInt(),
      kills: (json['kills'] as num).toInt(),
      deaths: (json['deaths'] as num).toInt(),
      loots: (json['loots'] as num).toInt(),
      stormDeaths: (json['storm_deaths'] as num).toInt(),
      durationSeconds: (json['duration_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$MatchStatsResponseToJson(_MatchStatsResponse instance) =>
    <String, dynamic>{
      'match_id': instance.matchId,
      'map_id': instance.mapId,
      'total_humans': instance.totalHumans,
      'total_bots': instance.totalBots,
      'kills': instance.kills,
      'deaths': instance.deaths,
      'loots': instance.loots,
      'storm_deaths': instance.stormDeaths,
      'duration_seconds': instance.durationSeconds,
    };
