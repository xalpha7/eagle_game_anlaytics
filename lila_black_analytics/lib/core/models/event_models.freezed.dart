// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventModel {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'match_id') String get matchId;@JsonKey(name: 'map_id') String get mapId; double get x; double get y; double get z;@JsonKey(name: 'pixel_x') double get pixelX;@JsonKey(name: 'pixel_y') double get pixelY; int get ts; String get event;@JsonKey(name: 'is_bot') bool get isBot;
/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventModelCopyWith<EventModel> get copyWith => _$EventModelCopyWithImpl<EventModel>(this as EventModel, _$identity);

  /// Serializes this EventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.mapId, mapId) || other.mapId == mapId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.z, z) || other.z == z)&&(identical(other.pixelX, pixelX) || other.pixelX == pixelX)&&(identical(other.pixelY, pixelY) || other.pixelY == pixelY)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.event, event) || other.event == event)&&(identical(other.isBot, isBot) || other.isBot == isBot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,matchId,mapId,x,y,z,pixelX,pixelY,ts,event,isBot);

@override
String toString() {
  return 'EventModel(userId: $userId, matchId: $matchId, mapId: $mapId, x: $x, y: $y, z: $z, pixelX: $pixelX, pixelY: $pixelY, ts: $ts, event: $event, isBot: $isBot)';
}


}

/// @nodoc
abstract mixin class $EventModelCopyWith<$Res>  {
  factory $EventModelCopyWith(EventModel value, $Res Function(EventModel) _then) = _$EventModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'match_id') String matchId,@JsonKey(name: 'map_id') String mapId, double x, double y, double z,@JsonKey(name: 'pixel_x') double pixelX,@JsonKey(name: 'pixel_y') double pixelY, int ts, String event,@JsonKey(name: 'is_bot') bool isBot
});




}
/// @nodoc
class _$EventModelCopyWithImpl<$Res>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._self, this._then);

  final EventModel _self;
  final $Res Function(EventModel) _then;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? matchId = null,Object? mapId = null,Object? x = null,Object? y = null,Object? z = null,Object? pixelX = null,Object? pixelY = null,Object? ts = null,Object? event = null,Object? isBot = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,mapId: null == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,z: null == z ? _self.z : z // ignore: cast_nullable_to_non_nullable
as double,pixelX: null == pixelX ? _self.pixelX : pixelX // ignore: cast_nullable_to_non_nullable
as double,pixelY: null == pixelY ? _self.pixelY : pixelY // ignore: cast_nullable_to_non_nullable
as double,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as int,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,isBot: null == isBot ? _self.isBot : isBot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventModel].
extension EventModelPatterns on EventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventModel value)  $default,){
final _that = this;
switch (_that) {
case _EventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventModel value)?  $default,){
final _that = this;
switch (_that) {
case _EventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId,  double x,  double y,  double z, @JsonKey(name: 'pixel_x')  double pixelX, @JsonKey(name: 'pixel_y')  double pixelY,  int ts,  String event, @JsonKey(name: 'is_bot')  bool isBot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventModel() when $default != null:
return $default(_that.userId,_that.matchId,_that.mapId,_that.x,_that.y,_that.z,_that.pixelX,_that.pixelY,_that.ts,_that.event,_that.isBot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId,  double x,  double y,  double z, @JsonKey(name: 'pixel_x')  double pixelX, @JsonKey(name: 'pixel_y')  double pixelY,  int ts,  String event, @JsonKey(name: 'is_bot')  bool isBot)  $default,) {final _that = this;
switch (_that) {
case _EventModel():
return $default(_that.userId,_that.matchId,_that.mapId,_that.x,_that.y,_that.z,_that.pixelX,_that.pixelY,_that.ts,_that.event,_that.isBot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId,  double x,  double y,  double z, @JsonKey(name: 'pixel_x')  double pixelX, @JsonKey(name: 'pixel_y')  double pixelY,  int ts,  String event, @JsonKey(name: 'is_bot')  bool isBot)?  $default,) {final _that = this;
switch (_that) {
case _EventModel() when $default != null:
return $default(_that.userId,_that.matchId,_that.mapId,_that.x,_that.y,_that.z,_that.pixelX,_that.pixelY,_that.ts,_that.event,_that.isBot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventModel implements EventModel {
  const _EventModel({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'match_id') required this.matchId, @JsonKey(name: 'map_id') required this.mapId, required this.x, required this.y, required this.z, @JsonKey(name: 'pixel_x') required this.pixelX, @JsonKey(name: 'pixel_y') required this.pixelY, required this.ts, required this.event, @JsonKey(name: 'is_bot') required this.isBot});
  factory _EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'match_id') final  String matchId;
@override@JsonKey(name: 'map_id') final  String mapId;
@override final  double x;
@override final  double y;
@override final  double z;
@override@JsonKey(name: 'pixel_x') final  double pixelX;
@override@JsonKey(name: 'pixel_y') final  double pixelY;
@override final  int ts;
@override final  String event;
@override@JsonKey(name: 'is_bot') final  bool isBot;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventModelCopyWith<_EventModel> get copyWith => __$EventModelCopyWithImpl<_EventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.mapId, mapId) || other.mapId == mapId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.z, z) || other.z == z)&&(identical(other.pixelX, pixelX) || other.pixelX == pixelX)&&(identical(other.pixelY, pixelY) || other.pixelY == pixelY)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.event, event) || other.event == event)&&(identical(other.isBot, isBot) || other.isBot == isBot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,matchId,mapId,x,y,z,pixelX,pixelY,ts,event,isBot);

@override
String toString() {
  return 'EventModel(userId: $userId, matchId: $matchId, mapId: $mapId, x: $x, y: $y, z: $z, pixelX: $pixelX, pixelY: $pixelY, ts: $ts, event: $event, isBot: $isBot)';
}


}

/// @nodoc
abstract mixin class _$EventModelCopyWith<$Res> implements $EventModelCopyWith<$Res> {
  factory _$EventModelCopyWith(_EventModel value, $Res Function(_EventModel) _then) = __$EventModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'match_id') String matchId,@JsonKey(name: 'map_id') String mapId, double x, double y, double z,@JsonKey(name: 'pixel_x') double pixelX,@JsonKey(name: 'pixel_y') double pixelY, int ts, String event,@JsonKey(name: 'is_bot') bool isBot
});




}
/// @nodoc
class __$EventModelCopyWithImpl<$Res>
    implements _$EventModelCopyWith<$Res> {
  __$EventModelCopyWithImpl(this._self, this._then);

  final _EventModel _self;
  final $Res Function(_EventModel) _then;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? matchId = null,Object? mapId = null,Object? x = null,Object? y = null,Object? z = null,Object? pixelX = null,Object? pixelY = null,Object? ts = null,Object? event = null,Object? isBot = null,}) {
  return _then(_EventModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,mapId: null == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,z: null == z ? _self.z : z // ignore: cast_nullable_to_non_nullable
as double,pixelX: null == pixelX ? _self.pixelX : pixelX // ignore: cast_nullable_to_non_nullable
as double,pixelY: null == pixelY ? _self.pixelY : pixelY // ignore: cast_nullable_to_non_nullable
as double,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as int,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,isBot: null == isBot ? _self.isBot : isBot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
