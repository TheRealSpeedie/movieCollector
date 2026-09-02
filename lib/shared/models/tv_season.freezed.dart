// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_season.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TvSeason {

 int get id; int get seriesId; int? get tmdbSeasonId; int get seasonNumber; String get name; String? get overview; String? get posterPath; DateTime? get airDate; int? get episodeCount; CollectionStatus? get status; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TvSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvSeasonCopyWith<TvSeason> get copyWith => _$TvSeasonCopyWithImpl<TvSeason>(this as TvSeason, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.tmdbSeasonId, tmdbSeasonId) || other.tmdbSeasonId == tmdbSeasonId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,seriesId,tmdbSeasonId,seasonNumber,name,overview,posterPath,airDate,episodeCount,status,createdAt,updatedAt);

@override
String toString() {
  return 'TvSeason(id: $id, seriesId: $seriesId, tmdbSeasonId: $tmdbSeasonId, seasonNumber: $seasonNumber, name: $name, overview: $overview, posterPath: $posterPath, airDate: $airDate, episodeCount: $episodeCount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TvSeasonCopyWith<$Res>  {
  factory $TvSeasonCopyWith(TvSeason value, $Res Function(TvSeason) _then) = _$TvSeasonCopyWithImpl;
@useResult
$Res call({
 int id, int seriesId, int? tmdbSeasonId, int seasonNumber, String name, String? overview, String? posterPath, DateTime? airDate, int? episodeCount, CollectionStatus? status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TvSeasonCopyWithImpl<$Res>
    implements $TvSeasonCopyWith<$Res> {
  _$TvSeasonCopyWithImpl(this._self, this._then);

  final TvSeason _self;
  final $Res Function(TvSeason) _then;

/// Create a copy of TvSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = null,Object? tmdbSeasonId = freezed,Object? seasonNumber = null,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? airDate = freezed,Object? episodeCount = freezed,Object? status = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int,tmdbSeasonId: freezed == tmdbSeasonId ? _self.tmdbSeasonId : tmdbSeasonId // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as DateTime?,episodeCount: freezed == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TvSeason].
extension TvSeasonPatterns on TvSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvSeason value)  $default,){
final _that = this;
switch (_that) {
case _TvSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvSeason value)?  $default,){
final _that = this;
switch (_that) {
case _TvSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int seriesId,  int? tmdbSeasonId,  int seasonNumber,  String name,  String? overview,  String? posterPath,  DateTime? airDate,  int? episodeCount,  CollectionStatus? status,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvSeason() when $default != null:
return $default(_that.id,_that.seriesId,_that.tmdbSeasonId,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodeCount,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int seriesId,  int? tmdbSeasonId,  int seasonNumber,  String name,  String? overview,  String? posterPath,  DateTime? airDate,  int? episodeCount,  CollectionStatus? status,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TvSeason():
return $default(_that.id,_that.seriesId,_that.tmdbSeasonId,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodeCount,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int seriesId,  int? tmdbSeasonId,  int seasonNumber,  String name,  String? overview,  String? posterPath,  DateTime? airDate,  int? episodeCount,  CollectionStatus? status,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TvSeason() when $default != null:
return $default(_that.id,_that.seriesId,_that.tmdbSeasonId,_that.seasonNumber,_that.name,_that.overview,_that.posterPath,_that.airDate,_that.episodeCount,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TvSeason implements TvSeason {
  const _TvSeason({required this.id, required this.seriesId, this.tmdbSeasonId, required this.seasonNumber, required this.name, this.overview, this.posterPath, this.airDate, this.episodeCount, this.status, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  int seriesId;
@override final  int? tmdbSeasonId;
@override final  int seasonNumber;
@override final  String name;
@override final  String? overview;
@override final  String? posterPath;
@override final  DateTime? airDate;
@override final  int? episodeCount;
@override final  CollectionStatus? status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TvSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvSeasonCopyWith<_TvSeason> get copyWith => __$TvSeasonCopyWithImpl<_TvSeason>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.tmdbSeasonId, tmdbSeasonId) || other.tmdbSeasonId == tmdbSeasonId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,seriesId,tmdbSeasonId,seasonNumber,name,overview,posterPath,airDate,episodeCount,status,createdAt,updatedAt);

@override
String toString() {
  return 'TvSeason(id: $id, seriesId: $seriesId, tmdbSeasonId: $tmdbSeasonId, seasonNumber: $seasonNumber, name: $name, overview: $overview, posterPath: $posterPath, airDate: $airDate, episodeCount: $episodeCount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TvSeasonCopyWith<$Res> implements $TvSeasonCopyWith<$Res> {
  factory _$TvSeasonCopyWith(_TvSeason value, $Res Function(_TvSeason) _then) = __$TvSeasonCopyWithImpl;
@override @useResult
$Res call({
 int id, int seriesId, int? tmdbSeasonId, int seasonNumber, String name, String? overview, String? posterPath, DateTime? airDate, int? episodeCount, CollectionStatus? status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TvSeasonCopyWithImpl<$Res>
    implements _$TvSeasonCopyWith<$Res> {
  __$TvSeasonCopyWithImpl(this._self, this._then);

  final _TvSeason _self;
  final $Res Function(_TvSeason) _then;

/// Create a copy of TvSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = null,Object? tmdbSeasonId = freezed,Object? seasonNumber = null,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? airDate = freezed,Object? episodeCount = freezed,Object? status = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TvSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int,tmdbSeasonId: freezed == tmdbSeasonId ? _self.tmdbSeasonId : tmdbSeasonId // ignore: cast_nullable_to_non_nullable
as int?,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as DateTime?,episodeCount: freezed == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
