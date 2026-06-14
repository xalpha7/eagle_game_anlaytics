// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchStatsResponse {

@JsonKey(name: 'match_id') String get matchId;@JsonKey(name: 'map_id') String get mapId;@JsonKey(name: 'total_humans') int get totalHumans;@JsonKey(name: 'total_bots') int get totalBots; int get kills; int get deaths; int get loots;@JsonKey(name: 'storm_deaths') int get stormDeaths;@JsonKey(name: 'duration_seconds') int get durationSeconds;
/// Create a copy of MatchStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchStatsResponseCopyWith<MatchStatsResponse> get copyWith => _$MatchStatsResponseCopyWithImpl<MatchStatsResponse>(this as MatchStatsResponse, _$identity);

  /// Serializes this MatchStatsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchStatsResponse&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.mapId, mapId) || other.mapId == mapId)&&(identical(other.totalHumans, totalHumans) || other.totalHumans == totalHumans)&&(identical(other.totalBots, totalBots) || other.totalBots == totalBots)&&(identical(other.kills, kills) || other.kills == kills)&&(identical(other.deaths, deaths) || other.deaths == deaths)&&(identical(other.loots, loots) || other.loots == loots)&&(identical(other.stormDeaths, stormDeaths) || other.stormDeaths == stormDeaths)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,mapId,totalHumans,totalBots,kills,deaths,loots,stormDeaths,durationSeconds);

@override
String toString() {
  return 'MatchStatsResponse(matchId: $matchId, mapId: $mapId, totalHumans: $totalHumans, totalBots: $totalBots, kills: $kills, deaths: $deaths, loots: $loots, stormDeaths: $stormDeaths, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $MatchStatsResponseCopyWith<$Res>  {
  factory $MatchStatsResponseCopyWith(MatchStatsResponse value, $Res Function(MatchStatsResponse) _then) = _$MatchStatsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'match_id') String matchId,@JsonKey(name: 'map_id') String mapId,@JsonKey(name: 'total_humans') int totalHumans,@JsonKey(name: 'total_bots') int totalBots, int kills, int deaths, int loots,@JsonKey(name: 'storm_deaths') int stormDeaths,@JsonKey(name: 'duration_seconds') int durationSeconds
});




}
/// @nodoc
class _$MatchStatsResponseCopyWithImpl<$Res>
    implements $MatchStatsResponseCopyWith<$Res> {
  _$MatchStatsResponseCopyWithImpl(this._self, this._then);

  final MatchStatsResponse _self;
  final $Res Function(MatchStatsResponse) _then;

/// Create a copy of MatchStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? mapId = null,Object? totalHumans = null,Object? totalBots = null,Object? kills = null,Object? deaths = null,Object? loots = null,Object? stormDeaths = null,Object? durationSeconds = null,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,mapId: null == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String,totalHumans: null == totalHumans ? _self.totalHumans : totalHumans // ignore: cast_nullable_to_non_nullable
as int,totalBots: null == totalBots ? _self.totalBots : totalBots // ignore: cast_nullable_to_non_nullable
as int,kills: null == kills ? _self.kills : kills // ignore: cast_nullable_to_non_nullable
as int,deaths: null == deaths ? _self.deaths : deaths // ignore: cast_nullable_to_non_nullable
as int,loots: null == loots ? _self.loots : loots // ignore: cast_nullable_to_non_nullable
as int,stormDeaths: null == stormDeaths ? _self.stormDeaths : stormDeaths // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchStatsResponse].
extension MatchStatsResponsePatterns on MatchStatsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchStatsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchStatsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchStatsResponse value)  $default,){
final _that = this;
switch (_that) {
case _MatchStatsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchStatsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MatchStatsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId, @JsonKey(name: 'total_humans')  int totalHumans, @JsonKey(name: 'total_bots')  int totalBots,  int kills,  int deaths,  int loots, @JsonKey(name: 'storm_deaths')  int stormDeaths, @JsonKey(name: 'duration_seconds')  int durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchStatsResponse() when $default != null:
return $default(_that.matchId,_that.mapId,_that.totalHumans,_that.totalBots,_that.kills,_that.deaths,_that.loots,_that.stormDeaths,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId, @JsonKey(name: 'total_humans')  int totalHumans, @JsonKey(name: 'total_bots')  int totalBots,  int kills,  int deaths,  int loots, @JsonKey(name: 'storm_deaths')  int stormDeaths, @JsonKey(name: 'duration_seconds')  int durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _MatchStatsResponse():
return $default(_that.matchId,_that.mapId,_that.totalHumans,_that.totalBots,_that.kills,_that.deaths,_that.loots,_that.stormDeaths,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'match_id')  String matchId, @JsonKey(name: 'map_id')  String mapId, @JsonKey(name: 'total_humans')  int totalHumans, @JsonKey(name: 'total_bots')  int totalBots,  int kills,  int deaths,  int loots, @JsonKey(name: 'storm_deaths')  int stormDeaths, @JsonKey(name: 'duration_seconds')  int durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _MatchStatsResponse() when $default != null:
return $default(_that.matchId,_that.mapId,_that.totalHumans,_that.totalBots,_that.kills,_that.deaths,_that.loots,_that.stormDeaths,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchStatsResponse implements MatchStatsResponse {
  const _MatchStatsResponse({@JsonKey(name: 'match_id') required this.matchId, @JsonKey(name: 'map_id') required this.mapId, @JsonKey(name: 'total_humans') required this.totalHumans, @JsonKey(name: 'total_bots') required this.totalBots, required this.kills, required this.deaths, required this.loots, @JsonKey(name: 'storm_deaths') required this.stormDeaths, @JsonKey(name: 'duration_seconds') required this.durationSeconds});
  factory _MatchStatsResponse.fromJson(Map<String, dynamic> json) => _$MatchStatsResponseFromJson(json);

@override@JsonKey(name: 'match_id') final  String matchId;
@override@JsonKey(name: 'map_id') final  String mapId;
@override@JsonKey(name: 'total_humans') final  int totalHumans;
@override@JsonKey(name: 'total_bots') final  int totalBots;
@override final  int kills;
@override final  int deaths;
@override final  int loots;
@override@JsonKey(name: 'storm_deaths') final  int stormDeaths;
@override@JsonKey(name: 'duration_seconds') final  int durationSeconds;

/// Create a copy of MatchStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchStatsResponseCopyWith<_MatchStatsResponse> get copyWith => __$MatchStatsResponseCopyWithImpl<_MatchStatsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchStatsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchStatsResponse&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.mapId, mapId) || other.mapId == mapId)&&(identical(other.totalHumans, totalHumans) || other.totalHumans == totalHumans)&&(identical(other.totalBots, totalBots) || other.totalBots == totalBots)&&(identical(other.kills, kills) || other.kills == kills)&&(identical(other.deaths, deaths) || other.deaths == deaths)&&(identical(other.loots, loots) || other.loots == loots)&&(identical(other.stormDeaths, stormDeaths) || other.stormDeaths == stormDeaths)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,mapId,totalHumans,totalBots,kills,deaths,loots,stormDeaths,durationSeconds);

@override
String toString() {
  return 'MatchStatsResponse(matchId: $matchId, mapId: $mapId, totalHumans: $totalHumans, totalBots: $totalBots, kills: $kills, deaths: $deaths, loots: $loots, stormDeaths: $stormDeaths, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$MatchStatsResponseCopyWith<$Res> implements $MatchStatsResponseCopyWith<$Res> {
  factory _$MatchStatsResponseCopyWith(_MatchStatsResponse value, $Res Function(_MatchStatsResponse) _then) = __$MatchStatsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'match_id') String matchId,@JsonKey(name: 'map_id') String mapId,@JsonKey(name: 'total_humans') int totalHumans,@JsonKey(name: 'total_bots') int totalBots, int kills, int deaths, int loots,@JsonKey(name: 'storm_deaths') int stormDeaths,@JsonKey(name: 'duration_seconds') int durationSeconds
});




}
/// @nodoc
class __$MatchStatsResponseCopyWithImpl<$Res>
    implements _$MatchStatsResponseCopyWith<$Res> {
  __$MatchStatsResponseCopyWithImpl(this._self, this._then);

  final _MatchStatsResponse _self;
  final $Res Function(_MatchStatsResponse) _then;

/// Create a copy of MatchStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? mapId = null,Object? totalHumans = null,Object? totalBots = null,Object? kills = null,Object? deaths = null,Object? loots = null,Object? stormDeaths = null,Object? durationSeconds = null,}) {
  return _then(_MatchStatsResponse(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,mapId: null == mapId ? _self.mapId : mapId // ignore: cast_nullable_to_non_nullable
as String,totalHumans: null == totalHumans ? _self.totalHumans : totalHumans // ignore: cast_nullable_to_non_nullable
as int,totalBots: null == totalBots ? _self.totalBots : totalBots // ignore: cast_nullable_to_non_nullable
as int,kills: null == kills ? _self.kills : kills // ignore: cast_nullable_to_non_nullable
as int,deaths: null == deaths ? _self.deaths : deaths // ignore: cast_nullable_to_non_nullable
as int,loots: null == loots ? _self.loots : loots // ignore: cast_nullable_to_non_nullable
as int,stormDeaths: null == stormDeaths ? _self.stormDeaths : stormDeaths // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
