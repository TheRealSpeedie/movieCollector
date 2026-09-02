// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_with_entries.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionEntry {

 int get tmdbMovieId; String get title; String? get originalTitle; String? get posterPath; DateTime? get releaseDate; Movie? get localMovie;
/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionEntryCopyWith<CollectionEntry> get copyWith => _$CollectionEntryCopyWithImpl<CollectionEntry>(this as CollectionEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionEntry&&(identical(other.tmdbMovieId, tmdbMovieId) || other.tmdbMovieId == tmdbMovieId)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.localMovie, localMovie) || other.localMovie == localMovie));
}


@override
int get hashCode => Object.hash(runtimeType,tmdbMovieId,title,originalTitle,posterPath,releaseDate,localMovie);

@override
String toString() {
  return 'CollectionEntry(tmdbMovieId: $tmdbMovieId, title: $title, originalTitle: $originalTitle, posterPath: $posterPath, releaseDate: $releaseDate, localMovie: $localMovie)';
}


}

/// @nodoc
abstract mixin class $CollectionEntryCopyWith<$Res>  {
  factory $CollectionEntryCopyWith(CollectionEntry value, $Res Function(CollectionEntry) _then) = _$CollectionEntryCopyWithImpl;
@useResult
$Res call({
 int tmdbMovieId, String title, String? originalTitle, String? posterPath, DateTime? releaseDate, Movie? localMovie
});


$MovieCopyWith<$Res>? get localMovie;

}
/// @nodoc
class _$CollectionEntryCopyWithImpl<$Res>
    implements $CollectionEntryCopyWith<$Res> {
  _$CollectionEntryCopyWithImpl(this._self, this._then);

  final CollectionEntry _self;
  final $Res Function(CollectionEntry) _then;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tmdbMovieId = null,Object? title = null,Object? originalTitle = freezed,Object? posterPath = freezed,Object? releaseDate = freezed,Object? localMovie = freezed,}) {
  return _then(_self.copyWith(
tmdbMovieId: null == tmdbMovieId ? _self.tmdbMovieId : tmdbMovieId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,localMovie: freezed == localMovie ? _self.localMovie : localMovie // ignore: cast_nullable_to_non_nullable
as Movie?,
  ));
}
/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res>? get localMovie {
    if (_self.localMovie == null) {
    return null;
  }

  return $MovieCopyWith<$Res>(_self.localMovie!, (value) {
    return _then(_self.copyWith(localMovie: value));
  });
}
}


/// Adds pattern-matching-related methods to [CollectionEntry].
extension CollectionEntryPatterns on CollectionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionEntry value)  $default,){
final _that = this;
switch (_that) {
case _CollectionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tmdbMovieId,  String title,  String? originalTitle,  String? posterPath,  DateTime? releaseDate,  Movie? localMovie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that.tmdbMovieId,_that.title,_that.originalTitle,_that.posterPath,_that.releaseDate,_that.localMovie);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tmdbMovieId,  String title,  String? originalTitle,  String? posterPath,  DateTime? releaseDate,  Movie? localMovie)  $default,) {final _that = this;
switch (_that) {
case _CollectionEntry():
return $default(_that.tmdbMovieId,_that.title,_that.originalTitle,_that.posterPath,_that.releaseDate,_that.localMovie);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tmdbMovieId,  String title,  String? originalTitle,  String? posterPath,  DateTime? releaseDate,  Movie? localMovie)?  $default,) {final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that.tmdbMovieId,_that.title,_that.originalTitle,_that.posterPath,_that.releaseDate,_that.localMovie);case _:
  return null;

}
}

}

/// @nodoc


class _CollectionEntry implements CollectionEntry {
  const _CollectionEntry({required this.tmdbMovieId, required this.title, this.originalTitle, this.posterPath, this.releaseDate, this.localMovie});
  

@override final  int tmdbMovieId;
@override final  String title;
@override final  String? originalTitle;
@override final  String? posterPath;
@override final  DateTime? releaseDate;
@override final  Movie? localMovie;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionEntryCopyWith<_CollectionEntry> get copyWith => __$CollectionEntryCopyWithImpl<_CollectionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionEntry&&(identical(other.tmdbMovieId, tmdbMovieId) || other.tmdbMovieId == tmdbMovieId)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.localMovie, localMovie) || other.localMovie == localMovie));
}


@override
int get hashCode => Object.hash(runtimeType,tmdbMovieId,title,originalTitle,posterPath,releaseDate,localMovie);

@override
String toString() {
  return 'CollectionEntry(tmdbMovieId: $tmdbMovieId, title: $title, originalTitle: $originalTitle, posterPath: $posterPath, releaseDate: $releaseDate, localMovie: $localMovie)';
}


}

/// @nodoc
abstract mixin class _$CollectionEntryCopyWith<$Res> implements $CollectionEntryCopyWith<$Res> {
  factory _$CollectionEntryCopyWith(_CollectionEntry value, $Res Function(_CollectionEntry) _then) = __$CollectionEntryCopyWithImpl;
@override @useResult
$Res call({
 int tmdbMovieId, String title, String? originalTitle, String? posterPath, DateTime? releaseDate, Movie? localMovie
});


@override $MovieCopyWith<$Res>? get localMovie;

}
/// @nodoc
class __$CollectionEntryCopyWithImpl<$Res>
    implements _$CollectionEntryCopyWith<$Res> {
  __$CollectionEntryCopyWithImpl(this._self, this._then);

  final _CollectionEntry _self;
  final $Res Function(_CollectionEntry) _then;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tmdbMovieId = null,Object? title = null,Object? originalTitle = freezed,Object? posterPath = freezed,Object? releaseDate = freezed,Object? localMovie = freezed,}) {
  return _then(_CollectionEntry(
tmdbMovieId: null == tmdbMovieId ? _self.tmdbMovieId : tmdbMovieId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,localMovie: freezed == localMovie ? _self.localMovie : localMovie // ignore: cast_nullable_to_non_nullable
as Movie?,
  ));
}

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res>? get localMovie {
    if (_self.localMovie == null) {
    return null;
  }

  return $MovieCopyWith<$Res>(_self.localMovie!, (value) {
    return _then(_self.copyWith(localMovie: value));
  });
}
}

/// @nodoc
mixin _$CollectionWithEntries {

 int get id; int? get tmdbCollectionId; String get name; String? get overview; String? get posterPath; String? get backdropPath; List<CollectionEntry> get entries;
/// Create a copy of CollectionWithEntries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionWithEntriesCopyWith<CollectionWithEntries> get copyWith => _$CollectionWithEntriesCopyWithImpl<CollectionWithEntries>(this as CollectionWithEntries, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionWithEntries&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbCollectionId, tmdbCollectionId) || other.tmdbCollectionId == tmdbCollectionId)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other.entries, entries));
}


@override
int get hashCode => Object.hash(runtimeType,id,tmdbCollectionId,name,overview,posterPath,backdropPath,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'CollectionWithEntries(id: $id, tmdbCollectionId: $tmdbCollectionId, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, entries: $entries)';
}


}

/// @nodoc
abstract mixin class $CollectionWithEntriesCopyWith<$Res>  {
  factory $CollectionWithEntriesCopyWith(CollectionWithEntries value, $Res Function(CollectionWithEntries) _then) = _$CollectionWithEntriesCopyWithImpl;
@useResult
$Res call({
 int id, int? tmdbCollectionId, String name, String? overview, String? posterPath, String? backdropPath, List<CollectionEntry> entries
});




}
/// @nodoc
class _$CollectionWithEntriesCopyWithImpl<$Res>
    implements $CollectionWithEntriesCopyWith<$Res> {
  _$CollectionWithEntriesCopyWithImpl(this._self, this._then);

  final CollectionWithEntries _self;
  final $Res Function(CollectionWithEntries) _then;

/// Create a copy of CollectionWithEntries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tmdbCollectionId = freezed,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? entries = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbCollectionId: freezed == tmdbCollectionId ? _self.tmdbCollectionId : tmdbCollectionId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<CollectionEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionWithEntries].
extension CollectionWithEntriesPatterns on CollectionWithEntries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionWithEntries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionWithEntries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionWithEntries value)  $default,){
final _that = this;
switch (_that) {
case _CollectionWithEntries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionWithEntries value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionWithEntries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? tmdbCollectionId,  String name,  String? overview,  String? posterPath,  String? backdropPath,  List<CollectionEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionWithEntries() when $default != null:
return $default(_that.id,_that.tmdbCollectionId,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? tmdbCollectionId,  String name,  String? overview,  String? posterPath,  String? backdropPath,  List<CollectionEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _CollectionWithEntries():
return $default(_that.id,_that.tmdbCollectionId,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? tmdbCollectionId,  String name,  String? overview,  String? posterPath,  String? backdropPath,  List<CollectionEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _CollectionWithEntries() when $default != null:
return $default(_that.id,_that.tmdbCollectionId,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.entries);case _:
  return null;

}
}

}

/// @nodoc


class _CollectionWithEntries implements CollectionWithEntries {
  const _CollectionWithEntries({required this.id, this.tmdbCollectionId, required this.name, this.overview, this.posterPath, this.backdropPath, final  List<CollectionEntry> entries = const <CollectionEntry>[]}): _entries = entries;
  

@override final  int id;
@override final  int? tmdbCollectionId;
@override final  String name;
@override final  String? overview;
@override final  String? posterPath;
@override final  String? backdropPath;
 final  List<CollectionEntry> _entries;
@override@JsonKey() List<CollectionEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of CollectionWithEntries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionWithEntriesCopyWith<_CollectionWithEntries> get copyWith => __$CollectionWithEntriesCopyWithImpl<_CollectionWithEntries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionWithEntries&&(identical(other.id, id) || other.id == id)&&(identical(other.tmdbCollectionId, tmdbCollectionId) || other.tmdbCollectionId == tmdbCollectionId)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&const DeepCollectionEquality().equals(other._entries, _entries));
}


@override
int get hashCode => Object.hash(runtimeType,id,tmdbCollectionId,name,overview,posterPath,backdropPath,const DeepCollectionEquality().hash(_entries));

@override
String toString() {
  return 'CollectionWithEntries(id: $id, tmdbCollectionId: $tmdbCollectionId, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$CollectionWithEntriesCopyWith<$Res> implements $CollectionWithEntriesCopyWith<$Res> {
  factory _$CollectionWithEntriesCopyWith(_CollectionWithEntries value, $Res Function(_CollectionWithEntries) _then) = __$CollectionWithEntriesCopyWithImpl;
@override @useResult
$Res call({
 int id, int? tmdbCollectionId, String name, String? overview, String? posterPath, String? backdropPath, List<CollectionEntry> entries
});




}
/// @nodoc
class __$CollectionWithEntriesCopyWithImpl<$Res>
    implements _$CollectionWithEntriesCopyWith<$Res> {
  __$CollectionWithEntriesCopyWithImpl(this._self, this._then);

  final _CollectionWithEntries _self;
  final $Res Function(_CollectionWithEntries) _then;

/// Create a copy of CollectionWithEntries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tmdbCollectionId = freezed,Object? name = null,Object? overview = freezed,Object? posterPath = freezed,Object? backdropPath = freezed,Object? entries = null,}) {
  return _then(_CollectionWithEntries(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tmdbCollectionId: freezed == tmdbCollectionId ? _self.tmdbCollectionId : tmdbCollectionId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: freezed == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<CollectionEntry>,
  ));
}


}

// dart format on
