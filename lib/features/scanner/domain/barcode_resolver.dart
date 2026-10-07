import '../../../core/constants/app_constants.dart';
import '../../../core/matching/media_title_parser.dart';
import '../../../core/matching/movie_matcher.dart';
import '../../../core/network/network_info.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/network/upcitemdb/upcitemdb_client.dart';
import '../../../core/utils/title_normalizer.dart';
import '../../../shared/models/match_candidate.dart';
import '../../editions/data/physical_edition_repository.dart';
import '../data/barcode_repository.dart';
import 'barcode_lookup_result.dart';
import 'barcode_lookup_service.dart';
import 'physical_product.dart';
import 'scan_trace.dart';
import 'scanned_code.dart';

class BarcodeResolver {
  BarcodeResolver({
    required BarcodeRepository barcodeRepository,
    required BarcodeProvider barcodeProvider,
    required TmdbApiClient tmdbApiClient,
    required NetworkInfo networkInfo,
    PhysicalEditionRepository? editionRepository,
    BarcodeLookupService? lookupService,
    MovieMatcher matcher = const MovieMatcher(),
    MediaTitleParser mediaParser = const MediaTitleParser(),
  }) : _barcodeRepository = barcodeRepository,
       _tmdb = tmdbApiClient,
       _networkInfo = networkInfo,
       _editionRepository = editionRepository,
       _lookup = lookupService ?? BarcodeLookupService(upcItemDb: barcodeProvider),
       _matcher = matcher,
       _mediaParser = mediaParser;

  final BarcodeRepository _barcodeRepository;
  final TmdbApiClient _tmdb;
  final NetworkInfo _networkInfo;
  final PhysicalEditionRepository? _editionRepository;
  final BarcodeLookupService _lookup;
  final MovieMatcher _matcher;
  final MediaTitleParser _mediaParser;

  Future<BarcodeLookupResult> resolve(
    String raw, {
    String? formatName,
    ScanTrace? trace,
    void Function(String message)? onProgress,
  }) async {
    final log = trace ?? ScanTrace();
    final scanned = ScannedCode.parse(raw, formatName: formatName);
    log.add('raw=${scanned.raw}');
    log.add('kind=${scanned.kind.name}');
    log.add('gtin=${scanned.canonicalGtin ?? '-'}');

    for (final key in scanned.lookupKeys) {
      final localMovie = await _barcodeRepository.resolveMovie(key);
      if (localMovie != null) {
        log.add('local=hit');
        return BarcodeKnownMovie(localMovie);
      }
      final edition = await _editionRepository?.getByBarcode(key);
      if (edition != null && edition.itemCount > 0) {
        log.add('local=edition');
        if (edition.movies.length == 1 && edition.seasons.isEmpty) {
          return BarcodeKnownMovie(edition.movies.first);
        }
        return BarcodeKnownEdition(edition);
      }
    }
    log.add('local=miss');

    if (!scanned.isProductCode) {
      log.add('path=not-a-product-code');
      return BarcodeNotAProductCode(scanned.raw);
    }

    final gtin = scanned.canonicalGtin!;
    if (!await _networkInfo.isConnected) {
      log.add('path=offline');
      return BarcodeUnresolvedOffline(gtin);
    }

    onProgress?.call('Veröffentlichung wird gesucht …');
    final external = await _lookup.lookup(gtin, log);
    switch (external) {
      case ExternalLookupFailed(:final message):
        log.add('path=provider-failure');
        return BarcodeLookupFailed(barcode: gtin, message: message);
      case ExternalLookupMiss():
        log.add('path=unknown-product');
        return BarcodeProductUnknown(gtin);
      case ExternalLookupHit(:final product):
        onProgress?.call('Film oder Serie wird zugeordnet …');
        return _resolveProduct(gtin, product, log);
    }
  }

  Future<BarcodeLookupResult> _resolveProduct(
    String barcode,
    PhysicalProduct product,
    ScanTrace log,
  ) async {
    final described = TitleNormalizer.describe(
      product.displayTitle,
      publisher: product.publisher,
    );
    final parsed = _mediaParser.parse(product.displayTitle);
    final searchTitle = _searchable(
      parsed.kind == MediaKindHint.unknown
          ? product.displayTitle
          : parsed.cleanedTitle,
      publisher: product.publisher,
    );
    final year = product.year ?? parsed.parsedYear ?? described.year;
    final format = product.physicalFormat ?? described.physicalFormat;
    log.add('product=${product.displayTitle}');
    log.add('search=$searchTitle');
    log.add('publisher=${product.publisher ?? described.publisher ?? '-'}');
    log.add('imdb=${product.imdbId ?? '-'}');
    log.add('format=${format ?? '-'}');
    log.add('year=${year ?? '-'}');

    if (parsed.isTv) {
      log.add('path=tv');
      return _resolveTv(barcode, product, parsed, log);
    }
    if (parsed.isMovieBox) {
      final bundle = await _resolveMovieBox(
        barcode,
        product.displayTitle,
        searchTitle,
      );
      if (bundle != null) {
        log.add('path=movie-box');
        return bundle;
      }
      log.add('path=ambiguous-box');
      return _weak(barcode, product, searchTitle, format);
    }

    if (product.imdbId != null) {
      try {
        final found = await _tmdb.findByImdbId(product.imdbId!);
        log.add('tmdb-find movie=${found.movie?.id ?? '-'} tv=${found.tv?.id ?? '-'}');
        if (product.mediaType == 'tv' && found.tv != null) {
          log.add('path=imdb-tv');
          return _tvFromImdb(barcode, product, found.tv!);
        }
        if (product.mediaType != 'tv' && found.movie != null) {
          log.add('path=imdb-movie confidence=0.99');
          return BarcodeNeedsConfirmation(
            barcode: barcode,
            productTitle: product.displayTitle,
            candidates: [
              MatchCandidate(result: found.movie!, confidence: 0.99),
            ],
            physicalFormat: format,
            imdbId: product.imdbId,
            edition: product.edition,
            source: product.source,
            searchTitle: searchTitle,
          );
        }
        if (found.tv != null) {
          log.add('path=imdb-tv');
          return _tvFromImdb(barcode, product, found.tv!);
        }
      } catch (error) {
        log.add('tmdb-find-error=$error');
      }
    }

    if (product.mediaType == 'tv') {
      log.add('path=tv-hint');
      return _resolveTv(
        barcode,
        product,
        MediaParseResult(
          cleanedTitle: searchTitle,
          kind: MediaKindHint.unknown,
          parsedYear: year,
        ),
        log,
      );
    }

    log.add('path=title-search');
    return _resolveMovies(
      barcode,
      product,
      searchTitle,
      year,
      format,
      log,
    );
  }

  BarcodeWeakMatch _weak(
    String barcode,
    PhysicalProduct product,
    String searchTitle,
    String? format,
  ) {
    return BarcodeWeakMatch(
      barcode: barcode,
      productTitle: product.displayTitle,
      searchTitle: searchTitle,
      physicalFormat: format,
      imdbId: product.imdbId,
      edition: product.edition,
    );
  }

  Future<BarcodeNeedsTvConfirmation> _tvFromImdb(
    String barcode,
    PhysicalProduct product,
    TmdbTvSearchResult show,
  ) async {
    TmdbTvDetails? details;
    try {
      details = await _tmdb.getTvDetails(show.id);
    } catch (_) {}
    return BarcodeNeedsTvConfirmation(
      barcode: barcode,
      productTitle: product.displayTitle,
      candidates: [TvMatchCandidate(result: show, confidence: 0.99)],
      kindHint: MediaKindHint.unknown,
      details: details,
    );
  }

  Future<BarcodeLookupResult> _resolveTv(
    String barcode,
    PhysicalProduct product,
    MediaParseResult parsed,
    ScanTrace log,
  ) async {
    final productTitle = product.displayTitle;
    final query = _searchable(
      parsed.cleanedTitle,
      publisher: product.publisher,
    );
    final results = await _tmdb.searchTv(query, year: parsed.parsedYear);
    if (results.isEmpty) {
      if (parsed.kind == MediaKindHint.completeTvSeries) {
        final bundle = await _resolveMovieBox(
          barcode,
          productTitle,
          query,
        );
        if (bundle != null) return bundle;
        return _resolveMovies(
          barcode,
          product,
          query,
          product.year ?? parsed.parsedYear,
          product.physicalFormat,
          log,
        );
      }
      return BarcodeNoMatch(barcode: barcode, productTitle: productTitle);
    }

    final ranked = _matcher.rankTv(query, results, year: parsed.parsedYear);
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

  String _searchable(String raw, {String? publisher}) {
    final described = TitleNormalizer.describe(
      raw,
      publisher: publisher,
    ).searchTitle.trim();
    return described.isEmpty ? raw.trim() : described;
  }

  String? _coreTitle(String title) {
    final match = RegExp(r'^(.+?)\s[-–—:]\s+.+$').firstMatch(title.trim());
    final core = match?.group(1)?.trim();
    if (core == null || core.length < 3 || core == title.trim()) return null;
    return core;
  }

  bool _accept(List<MatchCandidate> ranked) {
    if (ranked.isEmpty) return false;
    final best = ranked.first.confidence;
    if (best >= AppConstants.minAcceptableConfidence) return true;
    return ranked.length == 1 && best >= 0.45;
  }

  void _logCandidates(ScanTrace log, List<MatchCandidate> ranked) {
    final best = ranked.first;
    log.add('confidence=${best.confidence.toStringAsFixed(2)}');
    log.add('sole=${ranked.length == 1}');
    log.add(
      'candidates=${ranked.take(3).map((c) {
        final movie = c.result;
        return '${movie.id}:${movie.title}|${movie.originalTitle ?? '-'}:${c.confidence.toStringAsFixed(2)}';
      }).join(',')}',
    );
  }

  BarcodeNeedsConfirmation _confirmation(
    String barcode,
    PhysicalProduct product,
    String searchTitle,
    String? format,
    List<MatchCandidate> candidates,
  ) {
    return BarcodeNeedsConfirmation(
      barcode: barcode,
      productTitle: product.displayTitle,
      candidates: candidates,
      physicalFormat: format,
      imdbId: product.imdbId,
      edition: product.edition,
      source: product.source,
      searchTitle: searchTitle,
    );
  }

  Future<List<TmdbSearchResult>> _searchMovies(
    String query,
    int? year,
    ScanTrace log,
  ) async {
    log.add('tmdb-query=$query');
    log.add('tmdb-year=${year ?? '-'}');
    final found = await _tmdb.searchMovies(query, year: year);
    if (found.isEmpty) log.add('tmdb-search=empty');
    return found;
  }

  Future<BarcodeLookupResult> _resolveMovies(
    String barcode,
    PhysicalProduct product,
    String searchTitle,
    int? year,
    String? format,
    ScanTrace log,
  ) async {
    final attempts = <({String query, int? year})>[];
    void add(String query, int? releaseYear) {
      final trimmed = query.trim();
      if (trimmed.isEmpty) return;
      if (attempts.any((item) => item.query == trimmed && item.year == releaseYear)) {
        return;
      }
      attempts.add((query: trimmed, year: releaseYear));
    }

    add(searchTitle, year);
    if (year != null) add(searchTitle, null);

    var sawResults = false;
    for (final attempt in attempts) {
      final found = await _searchMovies(attempt.query, attempt.year, log);
      if (found.isEmpty) continue;
      sawResults = true;
      final ranked = _matcher.rank(searchTitle, found, year: year);
      _logCandidates(log, ranked);
      if (_accept(ranked)) {
        log.add('decision=confirm');
        return _confirmation(barcode, product, searchTitle, format, ranked);
      }
    }

    if (!sawResults) {
      final core = _coreTitle(searchTitle);
      if (core != null) {
        final found = await _searchMovies(core, null, log);
        if (found.isNotEmpty) {
          final ranked = _matcher.rank(searchTitle, found, year: year);
          _logCandidates(log, ranked);
          if (_accept(ranked)) {
            log.add('decision=confirm-core');
            return _confirmation(barcode, product, searchTitle, format, ranked);
          }
        }
      }
    }

    log.add('decision=weak');
    return _weak(barcode, product, searchTitle, format);
  }
}
