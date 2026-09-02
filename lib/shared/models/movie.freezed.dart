// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Movie {

 int get id; int? get tmdbId; String get title; String? get originalTitle; String? get overview; DateTime? get releaseDate; int? get releaseYear; int? get runtime; String? get posterPath; String? get backdropPath; String? get certification; String? get originalLanguage; int? get tmdbCollectionId; CollectionStatus get status; List<String> get genres; DateTime get createdAt; DateTime get updatedAt; DateTime? get lastMetadataSyncAt;
/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieCopyWith<Movie> get copyWith => _$MovieCopyWithImpl<Movie>(this as Movie, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Movie&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.certification, certification) || other.certification == certification)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.tmdbCollectionId, tmdbCollectionId) || other.tmdbCollectionId == tmdbCollectionId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastMetadataSyncAt, lastMetadataSyncAt) || other.lastMetadataSyncAt == lastMetadataSyncAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,title,originalTitle,overview,releaseDate,releaseYear,runtime,posterPath,backdropPath,certification,originalLanguage,tmdbCollectionId,status,const DeepCollectionEquality().hash(genres),createdAt,updatedAt,lastMetadataSyncAt);

@override
String toString() {
  return 'Movie(id: $id, tmdbId: $tmdbId, title: $title, originalTitle: $originalTitle, overview: $overview, releaseDate: $releaseDate, releaseYear: $releaseYear, runtime: $runtime, posterPath: $posterPath, backdropPath: $backdropPath, certification: $certification, originalLanguage: $originalLanguage, tmdbCollectionId: $tmdbCollectionId, status: $status, genres: $genres, createdAt: $createdAt, updatedAt: $updatedAt, lastMetadataSyncAt: $lastMetadataSyncAt)';
}


}

/// @nodoc
abstract mixin class $MovieCopyWith<$Res>  {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) _then) = _$MovieCopyWithImpl;
@useResult
$Res call({
 int id, int? tmdbId, String title, String? originalTitle, String? overview, DateTime? releaseDate, int? releaseYear, int? runtime, String? posterPath, String? backdropPath, String? certification, String? originalLanguage, int? tmdbCollectionId, CollectionStatus status, List<String> genres, DateTime createdAt, DateTime updatedAt, DateTime? lastMetadataSyncAt
});




}
/// @nodoc
class _$MovieCopyWithImpl<$Res>
    implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._self, this._then);

  final Movie _self;
  final $Res Function(Movie) _then;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tmdbId = freezed,Object? title = null,Object? originalTitle = freezed,Object? overview = freezed,Object? releaseDate = freezed,Object? releaseYear = freezed,Object? runtime = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? certification = freezed,Object? originalLanguage = freezed,Object? tmdbCollectionId = freezed,Object? status = null,Object? genres = null,Object? createdAt = null,Object? updatedAt = null,Object? lastMetadataSyncAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,certification: freezed == certification ? _self.certification : certification // ignore: cast_nullable_to_non_nullable
as String?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,tmdbCollectionId: freezed == tmdbCollectionId ? _self.tmdbCollectionId : tmdbCollectionId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMetadataSyncAt: freezed == lastMetadataSyncAt ? _self.lastMetadataSyncAt : lastMetadataSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Movie].
extension MoviePatterns on Movie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Movie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Movie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Movie value)  $default,){
final _that = this;
switch (_that) {
case _Movie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Movie value)?  $default,){
final _that = this;
switch (_that) {
case _Movie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? tmdbId,  String title,  String? originalTitle,  String? overview,  DateTime? releaseDate,  int? releaseYear,  int? runtime,  String? posterPath,  String? backdropPath,  String? certification,  String? originalLanguage,  int? tmdbCollectionId,  CollectionStatus status,  List<String> genres,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastMetadataSyncAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Movie() when $default != null:
return $default(_that.id,_that.tmdbId,_that.title,_that.originalTitle,_that.overview,_that.releaseDate,_that.releaseYear,_that.runtime,_that.posterPath,_that.backdropPath,_that.certification,_that.originalLanguage,_that.tmdbCollectionId,_that.status,_that.genres,_that.createdAt,_that.updatedAt,_that.lastMetadataSyncAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? tmdbId,  String title,  String? originalTitle,  String? overview,  DateTime? releaseDate,  int? releaseYear,  int? runtime,  String? posterPath,  String? backdropPath,  String? certification,  String? originalLanguage,  int? tmdbCollectionId,  CollectionStatus status,  List<String> genres,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastMetadataSyncAt)  $default,) {final _that = this;
switch (_that) {
case _Movie():
return $default(_that.id,_that.tmdbId,_that.title,_that.originalTitle,_that.overview,_that.releaseDate,_that.releaseYear,_that.runtime,_that.posterPath,_that.backdropPath,_that.certification,_that.originalLanguage,_that.tmdbCollectionId,_that.status,_that.genres,_that.createdAt,_that.updatedAt,_that.lastMetadataSyncAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? tmdbId,  String title,  String? originalTitle,  String? overview,  DateTime? releaseDate,  int? releaseYear,  int? runtime,  String? posterPath,  String? backdropPath,  String? certification,  String? originalLanguage,  int? tmdbCollectionId,  CollectionStatus status,  List<String> genres,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastMetadataSyncAt)?  $default,) {final _that = this;
switch (_that) {
case _Movie() when $default != null:
return $default(_that.id,_that.tmdbId,_that.title,_that.originalTitle,_that.overview,_that.releaseDate,_that.releaseYear,_that.runtime,_that.posterPath,_that.backdropPath,_that.certification,_that.originalLanguage,_that.tmdbCollectionId,_that.status,_that.genres,_that.createdAt,_that.updatedAt,_that.lastMetadataSyncAt);case _:
  return null;

}
}

}

/// @nodoc


class _Movie implements Movie {
  const _Movie({required this.id, this.tmdbId, required this.title, this.originalTitle, this.overview, this.releaseDate, this.releaseYear, this.runtime, this.posterPath, this.backdropPath, this.certification, this.originalLanguage, this.tmdbCollectionId, required this.status, final  List<String> genres = const <String>[], required this.createdAt, required this.updatedAt, this.lastMetadataSyncAt}): _genres = genres;
  

@override final  int id;
@override final  int? tmdbId;
@override final  String title;
@override final  String? originalTitle;
@override final  String? overview;
@override final  DateTime? releaseDate;
@override final  int? releaseYear;
@override final  int? runtime;
@override final  String? posterPath;
@override final  String? backdropPath;
@override final  String? certification;
@override final  String? originalLanguage;
@override final  int? tmdbCollectionId;
@override final  CollectionStatus status;
 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? lastMetadataSyncAt;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieCopyWith<_Movie> get copyWith => __$MovieCopyWithImpl<_Movie>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Movie&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.certification, certification) || other.certification == certification)&&(identical(other.originalLanguage, originalLanguage) || other.originalLanguage == originalLanguage)&&(identical(other.tmdbCollectionId, tmdbCollectionId) || other.tmdbCollectionId == tmdbCollectionId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastMetadataSyncAt, lastMetadataSyncAt) || other.lastMetadataSyncAt == lastMetadataSyncAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tmdbId,title,originalTitle,overview,releaseDate,releaseYear,runtime,posterPath,backdropPath,certification,originalLanguage,tmdbCollectionId,status,const DeepCollectionEquality().hash(_genres),createdAt,updatedAt,lastMetadataSyncAt);

@override
String toString() {
  return 'Movie(id: $id, tmdbId: $tmdbId, title: $title, originalTitle: $originalTitle, overview: $overview, releaseDate: $releaseDate, releaseYear: $releaseYear, runtime: $runtime, posterPath: $posterPath, backdropPath: $backdropPath, certification: $certification, originalLanguage: $originalLanguage, tmdbCollectionId: $tmdbCollectionId, status: $status, genres: $genres, createdAt: $createdAt, updatedAt: $updatedAt, lastMetadataSyncAt: $lastMetadataSyncAt)';
}


}

/// @nodoc
abstract mixin class _$MovieCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$MovieCopyWith(_Movie value, $Res Function(_Movie) _then) = __$MovieCopyWithImpl;
@override @useResult
$Res call({
 int id, int? tmdbId, String title, String? originalTitle, String? overview, DateTime? releaseDate, int? releaseYear, int? runtime, String? posterPath, String? backdropPath, String? certification, String? originalLanguage, int? tmdbCollectionId, CollectionStatus status, List<String> genres, DateTime createdAt, DateTime updatedAt, DateTime? lastMetadataSyncAt
});




}
/// @nodoc
class __$MovieCopyWithImpl<$Res>
    implements _$MovieCopyWith<$Res> {
  __$MovieCopyWithImpl(this._self, this._then);

  final _Movie _self;
  final $Res Function(_Movie) _then;

/// Create a copy of Movie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tmdbId = freezed,Object? title = null,Object? originalTitle = freezed,Object? overview = freezed,Object? releaseDate = freezed,Object? releaseYear = freezed,Object? runtime = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? certification = freezed,Object? originalLanguage = freezed,Object? tmdbCollectionId = freezed,Object? status = null,Object? genres = null,Object? createdAt = null,Object? updatedAt = null,Object? lastMetadataSyncAt = freezed,}) {
  return _then(_Movie(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbId: freezed == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,certification: freezed == certification ? _self.certification : certification // ignore: cast_nullable_to_non_nullable
as String?,originalLanguage: freezed == originalLanguage ? _self.originalLanguage : originalLanguage // ignore: cast_nullable_to_non_nullable
as String?,tmdbCollectionId: freezed == tmdbCollectionId ? _self.tmdbCollectionId : tmdbCollectionId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastMetadataSyncAt: freezed == lastMetadataSyncAt ? _self.lastMetadataSyncAt : lastMetadataSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
