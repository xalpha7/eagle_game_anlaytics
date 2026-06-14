// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchResponse {

@JsonKey(name: 'match_id') String get matchId;@JsonKey(name: 'map_id') String get mapId; List<EventModel> get events;
/// Create a copy of MatchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchResponseCopyWith<MatchResponse> get copyWith => _$MatchResponseCopyWithImpl<MatchResponse>(this as MatchResponse, _$identity);

  /// Serializes this MatchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchResponse&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.mapId, mapId) || other.mapId == mapId)&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,mapId,const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'MatchResponse(matchId: $matchId, mapId: $mapId, events: $events)';
}


}

/// @nodoc
abstract mixin class $MatchResponseCopyWith<$Res>  {
  factory $MatchResponseCopyWith(MatchResponse value, $Res Function(MatchResponse) _then) = _$MatchResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'match_id') String matchId,@JsonKey(name: 'map_id') String mapId, List<EventModel> events
});




}
/// @nodoc
class _$MatchResponseCopyWithImpl<$Res>
    implements $MatchResponseCopyWith<$Res> {
  _$MatchResponseCopyWithImpl(this._self, this._then);

  final MatchResponse _self;
  final $Res Function(MatchResponse) _then;

/// Create a copy of MatchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? mapId = null,Object? events = null,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,mapId: null == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<EventModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchResponse].
extension MatchResponsePatterns on MatchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchResponse value)  $default,){
final _that = this;
switch (_that) {
case _MatchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MatchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId,  List<EventModel> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchResponse() when $default != null:
return $default(_that.matchId,_that.mapId,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId,  List<EventModel> events)  $default,) {final _that = this;
switch (_that) {
case _MatchResponse():
return $default(_that.matchId,_that.mapId,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId,  List<EventModel> events)?  $default,) {final _that = this;
switch (_that) {
case _MatchResponse() when $default != null:
return $default(_that.matchId,_that.mapId,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchResponse implements MatchResponse {
  const _MatchResponse({@JsonKey(name: 'match_id') required this.matchId, @JsonKey(name: 'map_id') required this.mapId, required final  List<EventModel> events}): _events = events;
  factory _MatchResponse.fromJson(Map<String, dynamic> json) => _$MatchResponseFromJson(json);

@override@JsonKey(name: 'match_id') final  String matchId;
@override@JsonKey(name: 'map_id') final  String mapId;
 final  List<EventModel> _events;
@override List<EventModel> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of MatchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchResponseCopyWith<_MatchResponse> get copyWith => __$MatchResponseCopyWithImpl<_MatchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchResponse&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.mapId, mapId) || other.mapId == mapId)&&const DeepCollectionEquality().equals(other._events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,mapId,const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'MatchResponse(matchId: $matchId, mapId: $mapId, events: $events)';
}


}

/// @nodoc
abstract mixin class _$MatchResponseCopyWith<$Res> implements $MatchResponseCopyWith<$Res> {
  factory _$MatchResponseCopyWith(_MatchResponse value, $Res Function(_MatchResponse) _then) = __$MatchResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'match_id') String matchId,@JsonKey(name: 'map_id') String mapId, List<EventModel> events
});




}
/// @nodoc
class __$MatchResponseCopyWithImpl<$Res>
    implements _$MatchResponseCopyWith<$Res> {
  __$MatchResponseCopyWithImpl(this._self, this._then);

  final _MatchResponse _self;
  final $Res Function(_MatchResponse) _then;

/// Create a copy of MatchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? mapId = null,Object? events = null,}) {
  return _then(_MatchResponse(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,mapId: null == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<EventModel>,
  ));
}


}

// dart format on
