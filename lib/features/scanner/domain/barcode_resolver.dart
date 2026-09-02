import '../../../core/errors/app_exception.dart';
import '../../../core/matching/media_title_parser.dart';
import '../../../core/matching/movie_matcher.dart';
import '../../../core/network/network_info.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/network/upcitemdb/upcitemdb_client.dart';
import '../../editions/data/physical_edition_repository.dart';
import '../data/barcode_repository.dart';
import 'barcode_lookup_result.dart';

class BarcodeResolver {
  BarcodeResolver({
    required BarcodeRepository barcodeRepository,
    required BarcodeProvider barcodeProvider,
    required TmdbApiClient tmdbApiClient,
    required NetworkInfo networkInfo,
    PhysicalEditionRepository? editionRepository,
    MovieMatcher matcher = const MovieMatcher(),
    MediaTitleParser mediaParser = const MediaTitleParser(),
  }) : _barcodeRepository = barcodeRepository,
       _barcodeProvider = barcodeProvider,
       _tmdb = tmdbApiClient,
       _networkInfo = networkInfo,
       _editionRepository = editionRepository,
       _matcher = matcher,
       _mediaParser = mediaParser;

  final BarcodeRepository _barcodeRepository;
  final BarcodeProvider _barcodeProvider;
  final TmdbApiClient _tmdb;
  final NetworkInfo _networkInfo;
  final PhysicalEditionRepository? _editionRepository;
  final MovieMatcher _matcher;
  final MediaTitleParser _mediaParser;

  Future<BarcodeLookupResult> resolve(String barcode) async {
    final localMovie = await _barcodeRepository.resolveMovie(barcode);
    if (localMovie != null) return BarcodeKnownMovie(localMovie);

    final edition = await _editionRepository?.getByBarcode(barcode);
    if (edition != null && edition.itemCount > 0) {
      if (edition.movies.length == 1 && edition.seasons.isEmpty) {
        return BarcodeKnownMovie(edition.movies.first);
      }
      return BarcodeKnownEdition(edition);
    }

    if (!await _networkInfo.isConnected) {
      return BarcodeUnresolvedOffline(barcode);
    }

    final lookup = await _lookupProduct(barcode);
    if (lookup == null) return BarcodeNoMatch(barcode: barcode);

    final parsed = _mediaParser.parse(lookup);
    if (parsed.isTv) {
      return _resolveTv(barcode, lookup, parsed);
    }
    if (parsed.isMovieBox) {
      final bundle = await _resolveMovieBox(
        barcode,
        lookup,
        parsed.cleanedTitle,
      );
      if (bundle != null) return bundle;
    }
    return _resolveMovies(barcode, lookup);
  }

  Future<BarcodeLookupResult> _resolveTv(
    String barcode,
    String productTitle,
    MediaParseResult parsed,
  ) async {
    final results = await _tmdb.searchTv(parsed.cleanedTitle);
    if (results.isEmpty) {
      if (parsed.kind == MediaKindHint.completeTvSeries) {
        final bundle = await _resolveMovieBox(
          barcode,
          productTitle,
          parsed.cleanedTitle,
        );
        if (bundle != null) return bundle;
        return _resolveMovies(barcode, productTitle);
      }
      return BarcodeNoMatch(barcode: barcode, productTitle: productTitle);
    }

    final ranked = _matcher.rankTv(parsed.cleanedTitle, results);
    final best = ranked.first;
    TmdbTvDetails? details;
    try {
      details = await _tmdb.getTvDetails(best.result.id);
    } catch (_) {}

    final selected = _selectedSeasons(parsed, details);
    return BarcodeNeedsTvConfirmation(
      barcode: barcode,
      productTitle: productTitle,
      candidates: ranked,
      kindHint: parsed.kind,
      parsedSeasonNumbers: parsed.seasonNumbers,
      details: details,
      selectedSeasonNumbers: selected,
    );
  }

  List<int> _selectedSeasons(MediaParseResult parsed, TmdbTvDetails? details) {
    final regular =
        details?.regularSeasons.map((s) => s.seasonNumber).toList() ?? const [];
    if (parsed.kind == MediaKindHint.completeTvSeries) return regular;
    if (parsed.kind == MediaKindHint.multiSeasonTvBox) {
      final selected = parsed.seasonNumbers
          .where((n) => n > 0 && (regular.isEmpty || regular.contains(n)))
          .toList();
      return selected.isEmpty ? regular : selected;
    }
    if (parsed.seasonNumbers.isNotEmpty) return parsed.seasonNumbers;
    return regular.isEmpty ? const [] : [regular.first];
  }

  Future<BarcodeLookupResult?> _resolveMovieBox(
    String barcode,
    String productTitle,
    String title,
  ) async {
    try {
      final collections = await _tmdb.searchCollections(title);
      if (collections.isEmpty) return null;
      final details = await _tmdb.getCollection(collections.first.id);
      if (details.parts.isEmpty) return null;
      return BarcodeNeedsMovieBundleConfirmation(
        barcode: barcode,
        productTitle: productTitle,
        collection: details,
        selectedTmdbIds: details.parts.map((p) => p.id).toList(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<BarcodeLookupResult> _resolveMovies(
    String barcode,
    String productTitle,
  ) async {
    final searchResults = await _tmdb.searchMovies(productTitle);
    if (searchResults.isEmpty) {
      return BarcodeNoMatch(barcode: barcode, productTitle: productTitle);
    }
    final candidates = _matcher.rank(productTitle, searchResults);
    return BarcodeNeedsConfirmation(
      barcode: barcode,
      productTitle: productTitle,
      candidates: candidates,
    );
  }

  Future<String?> _lookupProduct(String barcode) async {
    try {
      final result = await _barcodeProvider.lookup(barcode);
      if (!result.found) return null;
      return result.items.first.title;
    } on BarcodeNotFoundException {
      return null;
    }
  }
}
