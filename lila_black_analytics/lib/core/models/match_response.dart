import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lila_black_analytics/core/models/event_models.dart';
part 'match_response.freezed.dart';
part 'match_response.g.dart';

@freezed
class MatchResponse with _$MatchResponse {
  const factory MatchResponse({
    @JsonKey(name: 'match_id') required String matchId,
    @JsonKey(name: 'map_id') required String mapId,
    required List<EventModel> events,
  }) = _MatchResponse;

  factory MatchResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchResponseFromJson(json);
      
        @override
        // TODO: implement events
        List<EventModel> get events => throw UnimplementedError();
      
        @override
        // TODO: implement mapId
        String get mapId => throw UnimplementedError();
      
        @override
        // TODO: implement matchId
        String get matchId => throw UnimplementedError();
      
        @override
        Map<String, dynamic> toJson() {
          // TODO: implement toJson
          throw UnimplementedError();
        }
}
