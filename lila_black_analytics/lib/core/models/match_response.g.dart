// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchResponse _$MatchResponseFromJson(Map<String, dynamic> json) =>
    _MatchResponse(
      matchId: json['match_id'] as String,
      mapId: json['map_id'] as String,
      events: (json['events'] as List<dynamic>)
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchResponseToJson(_MatchResponse instance) =>
    <String, dynamic>{
      'match_id': instance.matchId,
      'map_id': instance.mapId,
      'events': instance.events,
    };
