// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportTarget {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTarget);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ImportTarget()';
}


}

/// @nodoc
class $ImportTargetCopyWith<$Res>  {
$ImportTargetCopyWith(ImportTarget _, $Res Function(ImportTarget) __);
}


/// Adds pattern-matching-related methods to [ImportTarget].
extension ImportTargetPatterns on ImportTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ImportTargetSingleMovie value)?  singleMovie,TResult Function( ImportTargetMovieBundle value)?  movieBundle,TResult Function( ImportTargetSingleTvSeason value)?  singleTvSeason,TResult Function( ImportTargetTvSeasonBundle value)?  tvSeasonBundle,TResult Function( ImportTargetCompleteTvSeries value)?  completeTvSeries,TResult Function( ImportTargetSkipped value)?  skipped,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ImportTargetSingleMovie() when singleMovie != null:
return singleMovie(_that);case ImportTargetMovieBundle() when movieBundle != null:
return movieBundle(_that);case ImportTargetSingleTvSeason() when singleTvSeason != null:
return singleTvSeason(_that);case ImportTargetTvSeasonBundle() when tvSeasonBundle != null:
return tvSeasonBundle(_that);case ImportTargetCompleteTvSeries() when completeTvSeries != null:
return completeTvSeries(_that);case ImportTargetSkipped() when skipped != null:
return skipped(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ImportTargetSingleMovie value)  singleMovie,required TResult Function( ImportTargetMovieBundle value)  movieBundle,required TResult Function( ImportTargetSingleTvSeason value)  singleTvSeason,required TResult Function( ImportTargetTvSeasonBundle value)  tvSeasonBundle,required TResult Function( ImportTargetCompleteTvSeries value)  completeTvSeries,required TResult Function( ImportTargetSkipped value)  skipped,}){
final _that = this;
switch (_that) {
case ImportTargetSingleMovie():
return singleMovie(_that);case ImportTargetMovieBundle():
return movieBundle(_that);case ImportTargetSingleTvSeason():
return singleTvSeason(_that);case ImportTargetTvSeasonBundle():
return tvSeasonBundle(_that);case ImportTargetCompleteTvSeries():
return completeTvSeries(_that);case ImportTargetSkipped():
return skipped(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ImportTargetSingleMovie value)?  singleMovie,TResult? Function( ImportTargetMovieBundle value)?  movieBundle,TResult? Function( ImportTargetSingleTvSeason value)?  singleTvSeason,TResult? Function( ImportTargetTvSeasonBundle value)?  tvSeasonBundle,TResult? Function( ImportTargetCompleteTvSeries value)?  completeTvSeries,TResult? Function( ImportTargetSkipped value)?  skipped,}){
final _that = this;
switch (_that) {
case ImportTargetSingleMovie() when singleMovie != null:
return singleMovie(_that);case ImportTargetMovieBundle() when movieBundle != null:
return movieBundle(_that);case ImportTargetSingleTvSeason() when singleTvSeason != null:
return singleTvSeason(_that);case ImportTargetTvSeasonBundle() when tvSeasonBundle != null:
return tvSeasonBundle(_that);case ImportTargetCompleteTvSeries() when completeTvSeries != null:
return completeTvSeries(_that);case ImportTargetSkipped() when skipped != null:
return skipped(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TmdbSearchResult movie)?  singleMovie,TResult Function( TmdbCollectionDetails collection,  List<int> selectedTmdbIds)?  movieBundle,TResult Function( TmdbTvSearchResult series,  TmdbTvDetails details,  int seasonNumber)?  singleTvSeason,TResult Function( TmdbTvSearchResult series,  TmdbTvDetails details,  List<int> selectedSeasonNumbers)?  tvSeasonBundle,TResult Function( TmdbTvSearchResult series,  TmdbTvDetails details,  List<int> selectedSeasonNumbers)?  completeTvSeries,TResult Function()?  skipped,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ImportTargetSingleMovie() when singleMovie != null:
return singleMovie(_that.movie);case ImportTargetMovieBundle() when movieBundle != null:
return movieBundle(_that.collection,_that.selectedTmdbIds);case ImportTargetSingleTvSeason() when singleTvSeason != null:
return singleTvSeason(_that.series,_that.details,_that.seasonNumber);case ImportTargetTvSeasonBundle() when tvSeasonBundle != null:
return tvSeasonBundle(_that.series,_that.details,_that.selectedSeasonNumbers);case ImportTargetCompleteTvSeries() when completeTvSeries != null:
return completeTvSeries(_that.series,_that.details,_that.selectedSeasonNumbers);case ImportTargetSkipped() when skipped != null:
return skipped();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TmdbSearchResult movie)  singleMovie,required TResult Function( TmdbCollectionDetails collection,  List<int> selectedTmdbIds)  movieBundle,required TResult Function( TmdbTvSearchResult series,  TmdbTvDetails details,  int seasonNumber)  singleTvSeason,required TResult Function( TmdbTvSearchResult series,  TmdbTvDetails details,  List<int> selectedSeasonNumbers)  tvSeasonBundle,required TResult Function( TmdbTvSearchResult series,  TmdbTvDetails details,  List<int> selectedSeasonNumbers)  completeTvSeries,required TResult Function()  skipped,}) {final _that = this;
switch (_that) {
case ImportTargetSingleMovie():
return singleMovie(_that.movie);case ImportTargetMovieBundle():
return movieBundle(_that.collection,_that.selectedTmdbIds);case ImportTargetSingleTvSeason():
return singleTvSeason(_that.series,_that.details,_that.seasonNumber);case ImportTargetTvSeasonBundle():
return tvSeasonBundle(_that.series,_that.details,_that.selectedSeasonNumbers);case ImportTargetCompleteTvSeries():
return completeTvSeries(_that.series,_that.details,_that.selectedSeasonNumbers);case ImportTargetSkipped():
return skipped();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TmdbSearchResult movie)?  singleMovie,TResult? Function( TmdbCollectionDetails collection,  List<int> selectedTmdbIds)?  movieBundle,TResult? Function( TmdbTvSearchResult series,  TmdbTvDetails details,  int seasonNumber)?  singleTvSeason,TResult? Function( TmdbTvSearchResult series,  TmdbTvDetails details,  List<int> selectedSeasonNumbers)?  tvSeasonBundle,TResult? Function( TmdbTvSearchResult series,  TmdbTvDetails details,  List<int> selectedSeasonNumbers)?  completeTvSeries,TResult? Function()?  skipped,}) {final _that = this;
switch (_that) {
case ImportTargetSingleMovie() when singleMovie != null:
return singleMovie(_that.movie);case ImportTargetMovieBundle() when movieBundle != null:
return movieBundle(_that.collection,_that.selectedTmdbIds);case ImportTargetSingleTvSeason() when singleTvSeason != null:
return singleTvSeason(_that.series,_that.details,_that.seasonNumber);case ImportTargetTvSeasonBundle() when tvSeasonBundle != null:
return tvSeasonBundle(_that.series,_that.details,_that.selectedSeasonNumbers);case ImportTargetCompleteTvSeries() when completeTvSeries != null:
return completeTvSeries(_that.series,_that.details,_that.selectedSeasonNumbers);case ImportTargetSkipped() when skipped != null:
return skipped();case _:
  return null;

}
}

}

/// @nodoc


class ImportTargetSingleMovie implements ImportTarget {
  const ImportTargetSingleMovie({required this.movie});
  

 final  TmdbSearchResult movie;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportTargetSingleMovieCopyWith<ImportTargetSingleMovie> get copyWith => _$ImportTargetSingleMovieCopyWithImpl<ImportTargetSingleMovie>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTargetSingleMovie&&(identical(other.movie, movie) || other.movie == movie));
}


@override
int get hashCode => Object.hash(runtimeType,movie);

@override
String toString() {
  return 'ImportTarget.singleMovie(movie: $movie)';
}


}

/// @nodoc
abstract mixin class $ImportTargetSingleMovieCopyWith<$Res> implements $ImportTargetCopyWith<$Res> {
  factory $ImportTargetSingleMovieCopyWith(ImportTargetSingleMovie value, $Res Function(ImportTargetSingleMovie) _then) = _$ImportTargetSingleMovieCopyWithImpl;
@useResult
$Res call({
 TmdbSearchResult movie
});




}
/// @nodoc
class _$ImportTargetSingleMovieCopyWithImpl<$Res>
    implements $ImportTargetSingleMovieCopyWith<$Res> {
  _$ImportTargetSingleMovieCopyWithImpl(this._self, this._then);

  final ImportTargetSingleMovie _self;
  final $Res Function(ImportTargetSingleMovie) _then;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? movie = null,}) {
  return _then(ImportTargetSingleMovie(
movie: null == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as TmdbSearchResult,
  ));
}


}

/// @nodoc


class ImportTargetMovieBundle implements ImportTarget {
  const ImportTargetMovieBundle({required this.collection, required final  List<int> selectedTmdbIds}): _selectedTmdbIds = selectedTmdbIds;
  

 final  TmdbCollectionDetails collection;
 final  List<int> _selectedTmdbIds;
 List<int> get selectedTmdbIds {
  if (_selectedTmdbIds is EqualUnmodifiableListView) return _selectedTmdbIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedTmdbIds);
}


/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportTargetMovieBundleCopyWith<ImportTargetMovieBundle> get copyWith => _$ImportTargetMovieBundleCopyWithImpl<ImportTargetMovieBundle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTargetMovieBundle&&(identical(other.collection, collection) || other.collection == collection)&&const DeepCollectionEquality().equals(other._selectedTmdbIds, _selectedTmdbIds));
}


@override
int get hashCode => Object.hash(runtimeType,collection,const DeepCollectionEquality().hash(_selectedTmdbIds));

@override
String toString() {
  return 'ImportTarget.movieBundle(collection: $collection, selectedTmdbIds: $selectedTmdbIds)';
}


}

/// @nodoc
abstract mixin class $ImportTargetMovieBundleCopyWith<$Res> implements $ImportTargetCopyWith<$Res> {
  factory $ImportTargetMovieBundleCopyWith(ImportTargetMovieBundle value, $Res Function(ImportTargetMovieBundle) _then) = _$ImportTargetMovieBundleCopyWithImpl;
@useResult
$Res call({
 TmdbCollectionDetails collection, List<int> selectedTmdbIds
});




}
/// @nodoc
class _$ImportTargetMovieBundleCopyWithImpl<$Res>
    implements $ImportTargetMovieBundleCopyWith<$Res> {
  _$ImportTargetMovieBundleCopyWithImpl(this._self, this._then);

  final ImportTargetMovieBundle _self;
  final $Res Function(ImportTargetMovieBundle) _then;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? collection = null,Object? selectedTmdbIds = null,}) {
  return _then(ImportTargetMovieBundle(
collection: null == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as TmdbCollectionDetails,selectedTmdbIds: null == selectedTmdbIds ? _self._selectedTmdbIds : selectedTmdbIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class ImportTargetSingleTvSeason implements ImportTarget {
  const ImportTargetSingleTvSeason({required this.series, required this.details, required this.seasonNumber});
  

 final  TmdbTvSearchResult series;
 final  TmdbTvDetails details;
 final  int seasonNumber;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportTargetSingleTvSeasonCopyWith<ImportTargetSingleTvSeason> get copyWith => _$ImportTargetSingleTvSeasonCopyWithImpl<ImportTargetSingleTvSeason>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTargetSingleTvSeason&&(identical(other.series, series) || other.series == series)&&(identical(other.details, details) || other.details == details)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber));
}


@override
int get hashCode => Object.hash(runtimeType,series,details,seasonNumber);

@override
String toString() {
  return 'ImportTarget.singleTvSeason(series: $series, details: $details, seasonNumber: $seasonNumber)';
}


}

/// @nodoc
abstract mixin class $ImportTargetSingleTvSeasonCopyWith<$Res> implements $ImportTargetCopyWith<$Res> {
  factory $ImportTargetSingleTvSeasonCopyWith(ImportTargetSingleTvSeason value, $Res Function(ImportTargetSingleTvSeason) _then) = _$ImportTargetSingleTvSeasonCopyWithImpl;
@useResult
$Res call({
 TmdbTvSearchResult series, TmdbTvDetails details, int seasonNumber
});




}
/// @nodoc
class _$ImportTargetSingleTvSeasonCopyWithImpl<$Res>
    implements $ImportTargetSingleTvSeasonCopyWith<$Res> {
  _$ImportTargetSingleTvSeasonCopyWithImpl(this._self, this._then);

  final ImportTargetSingleTvSeason _self;
  final $Res Function(ImportTargetSingleTvSeason) _then;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? series = null,Object? details = null,Object? seasonNumber = null,}) {
  return _then(ImportTargetSingleTvSeason(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as TmdbTvSearchResult,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TmdbTvDetails,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ImportTargetTvSeasonBundle implements ImportTarget {
  const ImportTargetTvSeasonBundle({required this.series, required this.details, required final  List<int> selectedSeasonNumbers}): _selectedSeasonNumbers = selectedSeasonNumbers;
  

 final  TmdbTvSearchResult series;
 final  TmdbTvDetails details;
 final  List<int> _selectedSeasonNumbers;
 List<int> get selectedSeasonNumbers {
  if (_selectedSeasonNumbers is EqualUnmodifiableListView) return _selectedSeasonNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedSeasonNumbers);
}


/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportTargetTvSeasonBundleCopyWith<ImportTargetTvSeasonBundle> get copyWith => _$ImportTargetTvSeasonBundleCopyWithImpl<ImportTargetTvSeasonBundle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTargetTvSeasonBundle&&(identical(other.series, series) || other.series == series)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other._selectedSeasonNumbers, _selectedSeasonNumbers));
}


@override
int get hashCode => Object.hash(runtimeType,series,details,const DeepCollectionEquality().hash(_selectedSeasonNumbers));

@override
String toString() {
  return 'ImportTarget.tvSeasonBundle(series: $series, details: $details, selectedSeasonNumbers: $selectedSeasonNumbers)';
}


}

/// @nodoc
abstract mixin class $ImportTargetTvSeasonBundleCopyWith<$Res> implements $ImportTargetCopyWith<$Res> {
  factory $ImportTargetTvSeasonBundleCopyWith(ImportTargetTvSeasonBundle value, $Res Function(ImportTargetTvSeasonBundle) _then) = _$ImportTargetTvSeasonBundleCopyWithImpl;
@useResult
$Res call({
 TmdbTvSearchResult series, TmdbTvDetails details, List<int> selectedSeasonNumbers
});




}
/// @nodoc
class _$ImportTargetTvSeasonBundleCopyWithImpl<$Res>
    implements $ImportTargetTvSeasonBundleCopyWith<$Res> {
  _$ImportTargetTvSeasonBundleCopyWithImpl(this._self, this._then);

  final ImportTargetTvSeasonBundle _self;
  final $Res Function(ImportTargetTvSeasonBundle) _then;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? series = null,Object? details = null,Object? selectedSeasonNumbers = null,}) {
  return _then(ImportTargetTvSeasonBundle(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as TmdbTvSearchResult,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TmdbTvDetails,selectedSeasonNumbers: null == selectedSeasonNumbers ? _self._selectedSeasonNumbers : selectedSeasonNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class ImportTargetCompleteTvSeries implements ImportTarget {
  const ImportTargetCompleteTvSeries({required this.series, required this.details, required final  List<int> selectedSeasonNumbers}): _selectedSeasonNumbers = selectedSeasonNumbers;
  

 final  TmdbTvSearchResult series;
 final  TmdbTvDetails details;
 final  List<int> _selectedSeasonNumbers;
 List<int> get selectedSeasonNumbers {
  if (_selectedSeasonNumbers is EqualUnmodifiableListView) return _selectedSeasonNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedSeasonNumbers);
}


/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportTargetCompleteTvSeriesCopyWith<ImportTargetCompleteTvSeries> get copyWith => _$ImportTargetCompleteTvSeriesCopyWithImpl<ImportTargetCompleteTvSeries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTargetCompleteTvSeries&&(identical(other.series, series) || other.series == series)&&(identical(other.details, details) || other.details == details)&&const DeepCollectionEquality().equals(other._selectedSeasonNumbers, _selectedSeasonNumbers));
}


@override
int get hashCode => Object.hash(runtimeType,series,details,const DeepCollectionEquality().hash(_selectedSeasonNumbers));

@override
String toString() {
  return 'ImportTarget.completeTvSeries(series: $series, details: $details, selectedSeasonNumbers: $selectedSeasonNumbers)';
}


}

/// @nodoc
abstract mixin class $ImportTargetCompleteTvSeriesCopyWith<$Res> implements $ImportTargetCopyWith<$Res> {
  factory $ImportTargetCompleteTvSeriesCopyWith(ImportTargetCompleteTvSeries value, $Res Function(ImportTargetCompleteTvSeries) _then) = _$ImportTargetCompleteTvSeriesCopyWithImpl;
@useResult
$Res call({
 TmdbTvSearchResult series, TmdbTvDetails details, List<int> selectedSeasonNumbers
});




}
/// @nodoc
class _$ImportTargetCompleteTvSeriesCopyWithImpl<$Res>
    implements $ImportTargetCompleteTvSeriesCopyWith<$Res> {
  _$ImportTargetCompleteTvSeriesCopyWithImpl(this._self, this._then);

  final ImportTargetCompleteTvSeries _self;
  final $Res Function(ImportTargetCompleteTvSeries) _then;

/// Create a copy of ImportTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? series = null,Object? details = null,Object? selectedSeasonNumbers = null,}) {
  return _then(ImportTargetCompleteTvSeries(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as TmdbTvSearchResult,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as TmdbTvDetails,selectedSeasonNumbers: null == selectedSeasonNumbers ? _self._selectedSeasonNumbers : selectedSeasonNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class ImportTargetSkipped implements ImportTarget {
  const ImportTargetSkipped();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTargetSkipped);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ImportTarget.skipped()';
}


}




/// @nodoc
mixin _$ImportRow {

 int get index; String get rawLine; String get parsedTitle; int? get parsedYear; ImportRowStatus get status; MediaKindHint get kindHint; List<int> get parsedSeasonNumbers; List<MatchCandidate> get candidates; List<TvMatchCandidate> get tvCandidates; TmdbSearchResult? get selectedCandidate; ImportTarget? get target; Movie? get existingLocalMovie;
/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportRowCopyWith<ImportRow> get copyWith => _$ImportRowCopyWithImpl<ImportRow>(this as ImportRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportRow&&(identical(other.index, index) || other.index == index)&&(identical(other.rawLine, rawLine) || other.rawLine == rawLine)&&(identical(other.parsedTitle, parsedTitle) || other.parsedTitle == parsedTitle)&&(identical(other.parsedYear, parsedYear) || other.parsedYear == parsedYear)&&(identical(other.status, status) || other.status == status)&&(identical(other.kindHint, kindHint) || other.kindHint == kindHint)&&const DeepCollectionEquality().equals(other.parsedSeasonNumbers, parsedSeasonNumbers)&&const DeepCollectionEquality().equals(other.candidates, candidates)&&const DeepCollectionEquality().equals(other.tvCandidates, tvCandidates)&&(identical(other.selectedCandidate, selectedCandidate) || other.selectedCandidate == selectedCandidate)&&(identical(other.target, target) || other.target == target)&&(identical(other.existingLocalMovie, existingLocalMovie) || other.existingLocalMovie == existingLocalMovie));
}


@override
int get hashCode => Object.hash(runtimeType,index,rawLine,parsedTitle,parsedYear,status,kindHint,const DeepCollectionEquality().hash(parsedSeasonNumbers),const DeepCollectionEquality().hash(candidates),const DeepCollectionEquality().hash(tvCandidates),selectedCandidate,target,existingLocalMovie);

@override
String toString() {
  return 'ImportRow(index: $index, rawLine: $rawLine, parsedTitle: $parsedTitle, parsedYear: $parsedYear, status: $status, kindHint: $kindHint, parsedSeasonNumbers: $parsedSeasonNumbers, candidates: $candidates, tvCandidates: $tvCandidates, selectedCandidate: $selectedCandidate, target: $target, existingLocalMovie: $existingLocalMovie)';
}


}

/// @nodoc
abstract mixin class $ImportRowCopyWith<$Res>  {
  factory $ImportRowCopyWith(ImportRow value, $Res Function(ImportRow) _then) = _$ImportRowCopyWithImpl;
@useResult
$Res call({
 int index, String rawLine, String parsedTitle, int? parsedYear, ImportRowStatus status, MediaKindHint kindHint, List<int> parsedSeasonNumbers, List<MatchCandidate> candidates, List<TvMatchCandidate> tvCandidates, TmdbSearchResult? selectedCandidate, ImportTarget? target, Movie? existingLocalMovie
});


$ImportTargetCopyWith<$Res>? get target;$MovieCopyWith<$Res>? get existingLocalMovie;

}
/// @nodoc
class _$ImportRowCopyWithImpl<$Res>
    implements $ImportRowCopyWith<$Res> {
  _$ImportRowCopyWithImpl(this._self, this._then);

  final ImportRow _self;
  final $Res Function(ImportRow) _then;

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? rawLine = null,Object? parsedTitle = null,Object? parsedYear = freezed,Object? status = null,Object? kindHint = null,Object? parsedSeasonNumbers = null,Object? candidates = null,Object? tvCandidates = null,Object? selectedCandidate = freezed,Object? target = freezed,Object? existingLocalMovie = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,rawLine: null == rawLine ? _self.rawLine : rawLine // ignore: cast_nullable_to_non_nullable
as String,parsedTitle: null == parsedTitle ? _self.parsedTitle : parsedTitle // ignore: cast_nullable_to_non_nullable
as String,parsedYear: freezed == parsedYear ? _self.parsedYear : parsedYear // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportRowStatus,kindHint: null == kindHint ? _self.kindHint : kindHint // ignore: cast_nullable_to_non_nullable
as MediaKindHint,parsedSeasonNumbers: null == parsedSeasonNumbers ? _self.parsedSeasonNumbers : parsedSeasonNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<MatchCandidate>,tvCandidates: null == tvCandidates ? _self.tvCandidates : tvCandidates // ignore: cast_nullable_to_non_nullable
as List<TvMatchCandidate>,selectedCandidate: freezed == selectedCandidate ? _self.selectedCandidate : selectedCandidate // ignore: cast_nullable_to_non_nullable
as TmdbSearchResult?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ImportTarget?,existingLocalMovie: freezed == existingLocalMovie ? _self.existingLocalMovie : existingLocalMovie // ignore: cast_nullable_to_non_nullable
as Movie?,
  ));
}
/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportTargetCopyWith<$Res>? get target {
    if (_self.target == null) {
    return null;
  }

  return $ImportTargetCopyWith<$Res>(_self.target!, (value) {
    return _then(_self.copyWith(target: value));
  });
}/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res>? get existingLocalMovie {
    if (_self.existingLocalMovie == null) {
    return null;
  }

  return $MovieCopyWith<$Res>(_self.existingLocalMovie!, (value) {
    return _then(_self.copyWith(existingLocalMovie: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImportRow].
extension ImportRowPatterns on ImportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportRow value)  $default,){
final _that = this;
switch (_that) {
case _ImportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportRow value)?  $default,){
final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String rawLine,  String parsedTitle,  int? parsedYear,  ImportRowStatus status,  MediaKindHint kindHint,  List<int> parsedSeasonNumbers,  List<MatchCandidate> candidates,  List<TvMatchCandidate> tvCandidates,  TmdbSearchResult? selectedCandidate,  ImportTarget? target,  Movie? existingLocalMovie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
return $default(_that.index,_that.rawLine,_that.parsedTitle,_that.parsedYear,_that.status,_that.kindHint,_that.parsedSeasonNumbers,_that.candidates,_that.tvCandidates,_that.selectedCandidate,_that.target,_that.existingLocalMovie);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String rawLine,  String parsedTitle,  int? parsedYear,  ImportRowStatus status,  MediaKindHint kindHint,  List<int> parsedSeasonNumbers,  List<MatchCandidate> candidates,  List<TvMatchCandidate> tvCandidates,  TmdbSearchResult? selectedCandidate,  ImportTarget? target,  Movie? existingLocalMovie)  $default,) {final _that = this;
switch (_that) {
case _ImportRow():
return $default(_that.index,_that.rawLine,_that.parsedTitle,_that.parsedYear,_that.status,_that.kindHint,_that.parsedSeasonNumbers,_that.candidates,_that.tvCandidates,_that.selectedCandidate,_that.target,_that.existingLocalMovie);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String rawLine,  String parsedTitle,  int? parsedYear,  ImportRowStatus status,  MediaKindHint kindHint,  List<int> parsedSeasonNumbers,  List<MatchCandidate> candidates,  List<TvMatchCandidate> tvCandidates,  TmdbSearchResult? selectedCandidate,  ImportTarget? target,  Movie? existingLocalMovie)?  $default,) {final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
return $default(_that.index,_that.rawLine,_that.parsedTitle,_that.parsedYear,_that.status,_that.kindHint,_that.parsedSeasonNumbers,_that.candidates,_that.tvCandidates,_that.selectedCandidate,_that.target,_that.existingLocalMovie);case _:
  return null;

}
}

}

/// @nodoc


class _ImportRow implements ImportRow {
  const _ImportRow({required this.index, required this.rawLine, required this.parsedTitle, this.parsedYear, required this.status, this.kindHint = MediaKindHint.unknown, final  List<int> parsedSeasonNumbers = const <int>[], final  List<MatchCandidate> candidates = const <MatchCandidate>[], final  List<TvMatchCandidate> tvCandidates = const <TvMatchCandidate>[], this.selectedCandidate, this.target, this.existingLocalMovie}): _parsedSeasonNumbers = parsedSeasonNumbers,_candidates = candidates,_tvCandidates = tvCandidates;
  

@override final  int index;
@override final  String rawLine;
@override final  String parsedTitle;
@override final  int? parsedYear;
@override final  ImportRowStatus status;
@override@JsonKey() final  MediaKindHint kindHint;
 final  List<int> _parsedSeasonNumbers;
@override@JsonKey() List<int> get parsedSeasonNumbers {
  if (_parsedSeasonNumbers is EqualUnmodifiableListView) return _parsedSeasonNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parsedSeasonNumbers);
}

 final  List<MatchCandidate> _candidates;
@override@JsonKey() List<MatchCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}

 final  List<TvMatchCandidate> _tvCandidates;
@override@JsonKey() List<TvMatchCandidate> get tvCandidates {
  if (_tvCandidates is EqualUnmodifiableListView) return _tvCandidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tvCandidates);
}

@override final  TmdbSearchResult? selectedCandidate;
@override final  ImportTarget? target;
@override final  Movie? existingLocalMovie;

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportRowCopyWith<_ImportRow> get copyWith => __$ImportRowCopyWithImpl<_ImportRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportRow&&(identical(other.index, index) || other.index == index)&&(identical(other.rawLine, rawLine) || other.rawLine == rawLine)&&(identical(other.parsedTitle, parsedTitle) || other.parsedTitle == parsedTitle)&&(identical(other.parsedYear, parsedYear) || other.parsedYear == parsedYear)&&(identical(other.status, status) || other.status == status)&&(identical(other.kindHint, kindHint) || other.kindHint == kindHint)&&const DeepCollectionEquality().equals(other._parsedSeasonNumbers, _parsedSeasonNumbers)&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&const DeepCollectionEquality().equals(other._tvCandidates, _tvCandidates)&&(identical(other.selectedCandidate, selectedCandidate) || other.selectedCandidate == selectedCandidate)&&(identical(other.target, target) || other.target == target)&&(identical(other.existingLocalMovie, existingLocalMovie) || other.existingLocalMovie == existingLocalMovie));
}


@override
int get hashCode => Object.hash(runtimeType,index,rawLine,parsedTitle,parsedYear,status,kindHint,const DeepCollectionEquality().hash(_parsedSeasonNumbers),const DeepCollectionEquality().hash(_candidates),const DeepCollectionEquality().hash(_tvCandidates),selectedCandidate,target,existingLocalMovie);

@override
String toString() {
  return 'ImportRow(index: $index, rawLine: $rawLine, parsedTitle: $parsedTitle, parsedYear: $parsedYear, status: $status, kindHint: $kindHint, parsedSeasonNumbers: $parsedSeasonNumbers, candidates: $candidates, tvCandidates: $tvCandidates, selectedCandidate: $selectedCandidate, target: $target, existingLocalMovie: $existingLocalMovie)';
}


}

/// @nodoc
abstract mixin class _$ImportRowCopyWith<$Res> implements $ImportRowCopyWith<$Res> {
  factory _$ImportRowCopyWith(_ImportRow value, $Res Function(_ImportRow) _then) = __$ImportRowCopyWithImpl;
@override @useResult
$Res call({
 int index, String rawLine, String parsedTitle, int? parsedYear, ImportRowStatus status, MediaKindHint kindHint, List<int> parsedSeasonNumbers, List<MatchCandidate> candidates, List<TvMatchCandidate> tvCandidates, TmdbSearchResult? selectedCandidate, ImportTarget? target, Movie? existingLocalMovie
});


@override $ImportTargetCopyWith<$Res>? get target;@override $MovieCopyWith<$Res>? get existingLocalMovie;

}
/// @nodoc
class __$ImportRowCopyWithImpl<$Res>
    implements _$ImportRowCopyWith<$Res> {
  __$ImportRowCopyWithImpl(this._self, this._then);

  final _ImportRow _self;
  final $Res Function(_ImportRow) _then;

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? rawLine = null,Object? parsedTitle = null,Object? parsedYear = freezed,Object? status = null,Object? kindHint = null,Object? parsedSeasonNumbers = null,Object? candidates = null,Object? tvCandidates = null,Object? selectedCandidate = freezed,Object? target = freezed,Object? existingLocalMovie = freezed,}) {
  return _then(_ImportRow(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,rawLine: null == rawLine ? _self.rawLine : rawLine // ignore: cast_nullable_to_non_nullable
as String,parsedTitle: null == parsedTitle ? _self.parsedTitle : parsedTitle // ignore: cast_nullable_to_non_nullable
as String,parsedYear: freezed == parsedYear ? _self.parsedYear : parsedYear // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportRowStatus,kindHint: null == kindHint ? _self.kindHint : kindHint // ignore: cast_nullable_to_non_nullable
as MediaKindHint,parsedSeasonNumbers: null == parsedSeasonNumbers ? _self._parsedSeasonNumbers : parsedSeasonNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<MatchCandidate>,tvCandidates: null == tvCandidates ? _self._tvCandidates : tvCandidates // ignore: cast_nullable_to_non_nullable
as List<TvMatchCandidate>,selectedCandidate: freezed == selectedCandidate ? _self.selectedCandidate : selectedCandidate // ignore: cast_nullable_to_non_nullable
as TmdbSearchResult?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ImportTarget?,existingLocalMovie: freezed == existingLocalMovie ? _self.existingLocalMovie : existingLocalMovie // ignore: cast_nullable_to_non_nullable
as Movie?,
  ));
}

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportTargetCopyWith<$Res>? get target {
    if (_self.target == null) {
    return null;
  }

  return $ImportTargetCopyWith<$Res>(_self.target!, (value) {
    return _then(_self.copyWith(target: value));
  });
}/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MovieCopyWith<$Res>? get existingLocalMovie {
    if (_self.existingLocalMovie == null) {
    return null;
  }

  return $MovieCopyWith<$Res>(_self.existingLocalMovie!, (value) {
    return _then(_self.copyWith(existingLocalMovie: value));
  });
}
}

// dart format on
