// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'replay_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReplayState {

 bool get isPlaying; int get speed; int get currentPlaybackTime; int get minTime; int get maxTime;
/// Create a copy of ReplayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplayStateCopyWith<ReplayState> get copyWith => _$ReplayStateCopyWithImpl<ReplayState>(this as ReplayState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplayState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.currentPlaybackTime, currentPlaybackTime) || other.currentPlaybackTime == currentPlaybackTime)&&(identical(other.minTime, minTime) || other.minTime == minTime)&&(identical(other.maxTime, maxTime) || other.maxTime == maxTime));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,speed,currentPlaybackTime,minTime,maxTime);

@override
String toString() {
  return 'ReplayState(isPlaying: $isPlaying, speed: $speed, currentPlaybackTime: $currentPlaybackTime, minTime: $minTime, maxTime: $maxTime)';
}


}

/// @nodoc
abstract mixin class $ReplayStateCopyWith<$Res>  {
  factory $ReplayStateCopyWith(ReplayState value, $Res Function(ReplayState) _then) = _$ReplayStateCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, int speed, int currentPlaybackTime, int minTime, int maxTime
});




}
/// @nodoc
class _$ReplayStateCopyWithImpl<$Res>
    implements $ReplayStateCopyWith<$Res> {
  _$ReplayStateCopyWithImpl(this._self, this._then);

  final ReplayState _self;
  final $Res Function(ReplayState) _then;

/// Create a copy of ReplayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPlaying = null,Object? speed = null,Object? currentPlaybackTime = null,Object? minTime = null,Object? maxTime = null,}) {
  return _then(_self.copyWith(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int,currentPlaybackTime: null == currentPlaybackTime ? _self.currentPlaybackTime : currentPlaybackTime // ignore: cast_nullable_to_non_nullable
as int,minTime: null == minTime ? _self.minTime : minTime // ignore: cast_nullable_to_non_nullable
as int,maxTime: null == maxTime ? _self.maxTime : maxTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplayState].
extension ReplayStatePatterns on ReplayState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplayState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplayState value)  $default,){
final _that = this;
switch (_that) {
case _ReplayState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplayState value)?  $default,){
final _that = this;
switch (_that) {
case _ReplayState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPlaying,  int speed,  int currentPlaybackTime,  int minTime,  int maxTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplayState() when $default != null:
return $default(_that.isPlaying,_that.speed,_that.currentPlaybackTime,_that.minTime,_that.maxTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPlaying,  int speed,  int currentPlaybackTime,  int minTime,  int maxTime)  $default,) {final _that = this;
switch (_that) {
case _ReplayState():
return $default(_that.isPlaying,_that.speed,_that.currentPlaybackTime,_that.minTime,_that.maxTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPlaying,  int speed,  int currentPlaybackTime,  int minTime,  int maxTime)?  $default,) {final _that = this;
switch (_that) {
case _ReplayState() when $default != null:
return $default(_that.isPlaying,_that.speed,_that.currentPlaybackTime,_that.minTime,_that.maxTime);case _:
  return null;

}
}

}

/// @nodoc


class _ReplayState implements ReplayState {
  const _ReplayState({this.isPlaying = false, this.speed = 1, this.currentPlaybackTime = 0, this.minTime = 0, this.maxTime = 0});
  

@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  int speed;
@override@JsonKey() final  int currentPlaybackTime;
@override@JsonKey() final  int minTime;
@override@JsonKey() final  int maxTime;

/// Create a copy of ReplayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplayStateCopyWith<_ReplayState> get copyWith => __$ReplayStateCopyWithImpl<_ReplayState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplayState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.currentPlaybackTime, currentPlaybackTime) || other.currentPlaybackTime == currentPlaybackTime)&&(identical(other.minTime, minTime) || other.minTime == minTime)&&(identical(other.maxTime, maxTime) || other.maxTime == maxTime));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,speed,currentPlaybackTime,minTime,maxTime);

@override
String toString() {
  return 'ReplayState(isPlaying: $isPlaying, speed: $speed, currentPlaybackTime: $currentPlaybackTime, minTime: $minTime, maxTime: $maxTime)';
}


}

/// @nodoc
abstract mixin class _$ReplayStateCopyWith<$Res> implements $ReplayStateCopyWith<$Res> {
  factory _$ReplayStateCopyWith(_ReplayState value, $Res Function(_ReplayState) _then) = __$ReplayStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPlaying, int speed, int currentPlaybackTime, int minTime, int maxTime
});




}
/// @nodoc
class __$ReplayStateCopyWithImpl<$Res>
    implements _$ReplayStateCopyWith<$Res> {
  __$ReplayStateCopyWithImpl(this._self, this._then);

  final _ReplayState _self;
  final $Res Function(_ReplayState) _then;

/// Create a copy of ReplayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? speed = null,Object? currentPlaybackTime = null,Object? minTime = null,Object? maxTime = null,}) {
  return _then(_ReplayState(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int,currentPlaybackTime: null == currentPlaybackTime ? _self.currentPlaybackTime : currentPlaybackTime // ignore: cast_nullable_to_non_nullable
as int,minTime: null == minTime ? _self.minTime : minTime // ignore: cast_nullable_to_non_nullable
as int,maxTime: null == maxTime ? _self.maxTime : maxTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
