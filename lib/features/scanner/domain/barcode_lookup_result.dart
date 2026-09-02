import '../../../shared/models/match_candidate.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/physical_edition.dart';
import '../../../core/matching/media_title_parser.dart';
import '../../../core/network/tmdb/tmdb_models.dart';

sealed class BarcodeLookupResult {
  const BarcodeLookupResult();
}

class BarcodeKnownMovie extends BarcodeLookupResult {
  const BarcodeKnownMovie(this.movie);

  final Movie movie;
}

class BarcodeKnownEdition extends BarcodeLookupResult {
  const BarcodeKnownEdition(this.edition);

  final PhysicalEditionContents edition;
}

class BarcodeNeedsConfirmation extends BarcodeLookupResult {
  const BarcodeNeedsConfirmation({
    required this.barcode,
    required this.productTitle,
    required this.candidates,
  });

  final String barcode;
  final String productTitle;
  final List<MatchCandidate> candidates;
}

class BarcodeNeedsTvConfirmation extends BarcodeLookupResult {
  const BarcodeNeedsTvConfirmation({
    required this.barcode,
    required this.productTitle,
    required this.candidates,
    required this.kindHint,
    this.parsedSeasonNumbers = const [],
    this.details,
    this.selectedSeasonNumbers = const [],
  });

  final String barcode;
  final String productTitle;
  final List<TvMatchCandidate> candidates;
  final MediaKindHint kindHint;
  final List<int> parsedSeasonNumbers;
  final TmdbTvDetails? details;
  final List<int> selectedSeasonNumbers;
}

class BarcodeNeedsMovieBundleConfirmation extends BarcodeLookupResult {
  const BarcodeNeedsMovieBundleConfirmation({
    required this.barcode,
    required this.productTitle,
    required this.collection,
    required this.selectedTmdbIds,
  });

  final String barcode;
  final String productTitle;
  final TmdbCollectionDetails collection;
  final List<int> selectedTmdbIds;
}

class BarcodeNoMatch extends BarcodeLookupResult {
  const BarcodeNoMatch({required this.barcode, this.productTitle});

  final String barcode;
  final String? productTitle;
}

class BarcodeUnresolvedOffline extends BarcodeLookupResult {
  const BarcodeUnresolvedOffline(this.barcode);

  final String barcode;
}
