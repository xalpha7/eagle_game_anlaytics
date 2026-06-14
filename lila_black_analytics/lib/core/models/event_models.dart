import 'package:freezed_annotation/freezed_annotation.dart';

// FIXED: Matching the exact plural filename to clear the build runner warning
part 'event_models.freezed.dart';
part 'event_models.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'match_id') required String matchId,
    @JsonKey(name: 'map_id') required String mapId,
    required double x,
    required double y,
    required double z,
    @JsonKey(name: 'pixel_x') required double pixelX,
    @JsonKey(name: 'pixel_y') required double pixelY,
    required int ts,
    required String event,
    @JsonKey(name: 'is_bot') required bool isBot,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) => 
      _$EventModelFromJson(json);
      
        @override
        // TODO: implement event
        String get event => throw UnimplementedError();
      
        @override
        // TODO: implement isBot
        bool get isBot => throw UnimplementedError();
      
        @override
        // TODO: implement mapId
        String get mapId => throw UnimplementedError();
      
        @override
        // TODO: implement matchId
        String get matchId => throw UnimplementedError();
      
        @override
        // TODO: implement pixelX
        double get pixelX => throw UnimplementedError();
      
        @override
        // TODO: implement pixelY
        double get pixelY => throw UnimplementedError();
      
        @override
        Map<String, dynamic> toJson() {
          // TODO: implement toJson
          throw UnimplementedError();
        }
      
        @override
        // TODO: implement ts
        int get ts => throw UnimplementedError();
      
        @override
        // TODO: implement userId
        String get userId => throw UnimplementedError();
      
        @override
        // TODO: implement x
        double get x => throw UnimplementedError();
      
        @override
        // TODO: implement y
        double get y => throw UnimplementedError();
      
        @override
        // TODO: implement z
        double get z => throw UnimplementedError();
}