// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventModel _$EventModelFromJson(Map<String, dynamic> json) => _EventModel(
  userId: json['user_id'] as String,
  matchId: json['match_id'] as String,
  mapId: json['map_id'] as String,
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  z: (json['z'] as num).toDouble(),
  pixelX: (json['pixel_x'] as num).toDouble(),
  pixelY: (json['pixel_y'] as num).toDouble(),
  ts: (json['ts'] as num).toInt(),
  event: json['event'] as String,
  isBot: json['is_bot'] as bool,
);

Map<String, dynamic> _$EventModelToJson(_EventModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'match_id': instance.matchId,
      'map_id': instance.mapId,
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'pixel_x': instance.pixelX,
      'pixel_y': instance.pixelY,
      'ts': instance.ts,
      'event': instance.event,
      'is_bot': instance.isBot,
    };
