// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TvSeries {

 int get id; int get tmdbId; String get name; String? get originalName; String? get overview; String? get posterPath; String? get backdropPath; DateTime? get firstAirDate; DateTime? get lastAirDate; int? get numberOfSeasons; String? get seriesStatus; String? get originalLanguage; String? get contentRating; List<String> get genres; DateTime get createdAt; DateTime get updatedAt; DateTime? get lastMetadataSyncAt;
/// Create a copy of TvSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvSeriesCopyWith<TvSeries> get copyWith => _$TvSeriesCopyWithImpl<TvSeries>(this as TvSeries, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.lastAirDate, lastAirDate) || other.lastAirDate == lastAirDate)&&(identical(other.numberOfSeasons, numberOfSeasons) || other.numberOfSeasons == numberOfSeasons)&&(identical(other.seriesStatus, seriesStatus) || other.seriesStatus == seriesStatus)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.contentRating, contentRating) || other.contentRating == contentRating)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastMetadataSyncAt, lastMetadataSyncAt) || other.lastMetadataSyncAt == lastMetadataSyncAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,name,originalName,overview,posterPath,backdropPath,firstAirDate,lastAirDate,numberOfSeasons,seriesStatus,originalLanguage,contentRating,const DeepCollectionEquality().hash(genres),createdAt,updatedAt,lastMetadataSyncAt);

@override
String toString() {
  return 'TvSeries(id: $id, tmdbId: $tmdbId, name: $name, originalName: $originalName, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, numberOfSeasons: $numberOfSeasons, seriesStatus: $seriesStatus, originalLanguage: $originalLanguage, contentRating: $contentRating, genres: $genres, createdAt: $createdAt, updatedAt: $updatedAt, lastMetadataSyncAt: $lastMetadataSyncAt)';
}


}

/// @nodoc
abstract mixin class $TvSeriesCopyWith<$Res>  {
  factory $TvSeriesCopyWith(TvSeries value, $Res Function(TvSeries) _then) = _$TvSeriesCopyWithImpl;
@useResult
$Res call({
 int id, int tmdbId, String name, String? originalName, String? overview, String? posterPath, String? backdropPath, DateTime? firstAirDate, DateTime? lastAirDate, int? numberOfSeasons, String? seriesStatus, String? originalLanguage, String? contentRating, List<String> genres, DateTime createdAt, DateTime updatedAt, DateTime? lastMetadataSyncAt
});




}
/// @nodoc
class _$TvSeriesCopyWithImpl<$Res>
    implements $TvSeriesCopyWith<$Res> {
  _$TvSeriesCopyWithImpl(this._self, this._then);

  final TvSeries _self;
  final $Res Function(TvSeries) _then;

/// Create a copy of TvSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tmdbId = null,Object? name = null,Object? originalName = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? lastAirDate = freezed,Object? numberOfSeasons = freezed,Object? seriesStatus = freezed,Object? originalLanguage = freezed,Object? contentRating = freezed,Object? genres = null,Object? createdAt = null,Object? updatedAt = null,Object? lastMetadataSyncAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAirDate: freezed == lastAirDate ? _self.lastAirDate : lastAirDate // ignore: cast_nullable_to_non_nullable
as DateTime?,numberOfSeasons: freezed == numberOfSeasons ? _self.numberOfSeasons : numberOfSeasons // ignore: cast_nullable_to_non_nullable
as int?,seriesStatus: freezed == seriesStatus ? _self.seriesStatus : seriesStatus // ignore: cast_nullable_to_non_nullable
as String?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,contentRating: freezed == contentRating ? _self.contentRating : contentRating // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMetadataSyncAt: freezed == lastMetadataSyncAt ? _self.lastMetadataSyncAt : lastMetadataSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvSeries].
extension TvSeriesPatterns on TvSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvSeries value)  $default,){
final _that = this;
switch (_that) {
case _TvSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvSeries value)?  $default,){
final _that = this;
switch (_that) {
case _TvSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int tmdbId,  String name,  String? originalName,  String? overview,  String? posterPath,  String? backdropPath,  DateTime? firstAirDate,  DateTime? lastAirDate,  int? numberOfSeasons,  String? seriesStatus,  String? originalLanguage,  String? contentRating,  List<String> genres,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastMetadataSyncAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvSeries() when $default != null:
return $default(_that.id,_that.tmdbId,_that.name,_that.originalName,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.seriesStatus,_that.originalLanguage,_that.contentRating,_that.genres,_that.createdAt,_that.updatedAt,_that.lastMetadataSyncAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int tmdbId,  String name,  String? originalName,  String? overview,  String? posterPath,  String? backdropPath,  DateTime? firstAirDate,  DateTime? lastAirDate,  int? numberOfSeasons,  String? seriesStatus,  String? originalLanguage,  String? contentRating,  List<String> genres,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastMetadataSyncAt)  $default,) {final _that = this;
switch (_that) {
case _TvSeries():
return $default(_that.id,_that.tmdbId,_that.name,_that.originalName,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.seriesStatus,_that.originalLanguage,_that.contentRating,_that.genres,_that.createdAt,_that.updatedAt,_that.lastMetadataSyncAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int tmdbId,  String name,  String? originalName,  String? overview,  String? posterPath,  String? backdropPath,  DateTime? firstAirDate,  DateTime? lastAirDate,  int? numberOfSeasons,  String? seriesStatus,  String? originalLanguage,  String? contentRating,  List<String> genres,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastMetadataSyncAt)?  $default,) {final _that = this;
switch (_that) {
case _TvSeries() when $default != null:
return $default(_that.id,_that.tmdbId,_that.name,_that.originalName,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.lastAirDate,_that.numberOfSeasons,_that.seriesStatus,_that.originalLanguage,_that.contentRating,_that.genres,_that.createdAt,_that.updatedAt,_that.lastMetadataSyncAt);case _:
  return null;

}
}

}

/// @nodoc


class _TvSeries implements TvSeries {
  const _TvSeries({required this.id, required this.tmdbId, required this.name, this.originalName, this.overview, this.posterPath, this.backdropPath, this.firstAirDate, this.lastAirDate, this.numberOfSeasons, this.seriesStatus, this.originalLanguage, this.contentRating, final  List<String> genres = const <String>[], required this.createdAt, required this.updatedAt, this.lastMetadataSyncAt}): _genres = genres;
  

@override final  int id;
@override final  int tmdbId;
@override final  String name;
@override final  String? originalName;
@override final  String? overview;
@override final  String? posterPath;
@override final  String? backdropPath;
@override final  DateTime? firstAirDate;
@override final  DateTime? lastAirDate;
@override final  int? numberOfSeasons;
@override final  String? seriesStatus;
@override final  String? originalLanguage;
@override final  String? contentRating;
 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? lastMetadataSyncAt;

/// Create a copy of TvSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvSeriesCopyWith<_TvSeries> get copyWith => __$TvSeriesCopyWithImpl<_TvSeries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.name, name) || other.name == name)&&(identical(other.originalName, originalName) || other.originalName == originalName)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.lastAirDate, lastAirDate) || other.lastAirDate == lastAirDate)&&(identical(other.numberOfSeasons, numberOfSeasons) || other.numberOfSeasons == numberOfSeasons)&&(identical(other.seriesStatus, seriesStatus) || other.seriesStatus == seriesStatus)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.contentRating, contentRating) || other.contentRating == contentRating)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastMetadataSyncAt, lastMetadataSyncAt) || other.lastMetadataSyncAt == lastMetadataSyncAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,name,originalName,overview,posterPath,backdropPath,firstAirDate,lastAirDate,numberOfSeasons,seriesStatus,originalLanguage,contentRating,const DeepCollectionEquality().hash(_genres),createdAt,updatedAt,lastMetadataSyncAt);

@override
String toString() {
  return 'TvSeries(id: $id, tmdbId: $tmdbId, name: $name, originalName: $originalName, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, lastAirDate: $lastAirDate, numberOfSeasons: $numberOfSeasons, seriesStatus: $seriesStatus, originalLanguage: $originalLanguage, contentRating: $contentRating, genres: $genres, createdAt: $createdAt, updatedAt: $updatedAt, lastMetadataSyncAt: $lastMetadataSyncAt)';
}


}

/// @nodoc
abstract mixin class _$TvSeriesCopyWith<$Res> implements $TvSeriesCopyWith<$Res> {
  factory _$TvSeriesCopyWith(_TvSeries value, $Res Function(_TvSeries) _then) = __$TvSeriesCopyWithImpl;
@override @useResult
$Res call({
 int id, int tmdbId, String name, String? originalName, String? overview, String? posterPath, String? backdropPath, DateTime? firstAirDate, DateTime? lastAirDate, int? numberOfSeasons, String? seriesStatus, String? originalLanguage, String? contentRating, List<String> genres, DateTime createdAt, DateTime updatedAt, DateTime? lastMetadataSyncAt
});




}
/// @nodoc
class __$TvSeriesCopyWithImpl<$Res>
    implements _$TvSeriesCopyWith<$Res> {
  __$TvSeriesCopyWithImpl(this._self, this._then);

  final _TvSeries _self;
  final $Res Function(_TvSeries) _then;

/// Create a copy of TvSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tmdbId = null,Object? name = null,Object? originalName = freezed,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? lastAirDate = freezed,Object? numberOfSeasons = freezed,Object? seriesStatus = freezed,Object? originalLanguage = freezed,Object? contentRating = freezed,Object? genres = null,Object? createdAt = null,Object? updatedAt = null,Object? lastMetadataSyncAt = freezed,}) {
  return _then(_TvSeries(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAirDate: freezed == lastAirDate ? _self.lastAirDate : lastAirDate // ignore: cast_nullable_to_non_nullable
as DateTime?,numberOfSeasons: freezed == numberOfSeasons ? _self.numberOfSeasons : numberOfSeasons // ignore: cast_nullable_to_non_nullable
as int?,seriesStatus: freezed == seriesStatus ? _self.seriesStatus : seriesStatus // ignore: cast_nullable_to_non_nullable
as String?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,contentRating: freezed == contentRating ? _self.contentRating : contentRating // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMetadataSyncAt: freezed == lastMetadataSyncAt ? _self.lastMetadataSyncAt : lastMetadataSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
