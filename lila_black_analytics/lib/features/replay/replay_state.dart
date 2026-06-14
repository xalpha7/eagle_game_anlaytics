import 'package:freezed_annotation/freezed_annotation.dart';

part 'replay_state.freezed.dart';

@freezed
class ReplayState with _$ReplayState {
  const factory ReplayState({
    @Default(false) bool isPlaying,
    @Default(1) int speed,
    @Default(0) int currentPlaybackTime,
    @Default(0) int minTime,
    @Default(0) int maxTime,
  }) = _ReplayState;
  
  @override
  // TODO: implement currentPlaybackTime
  int get currentPlaybackTime => throw UnimplementedError();
  
  @override
  // TODO: implement isPlaying
  bool get isPlaying => throw UnimplementedError();
  
  @override
  // TODO: implement maxTime
  int get maxTime => throw UnimplementedError();
  
  @override
  // TODO: implement minTime
  int get minTime => throw UnimplementedError();
  
  @override
  // TODO: implement speed
  int get speed => throw UnimplementedError();
}