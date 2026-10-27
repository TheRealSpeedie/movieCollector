import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/matching/movie_matcher.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/physical_edition_kind.dart';
import '../../editions/data/physical_edition_repository.dart';
import '../../movies/data/movie_repository.dart';
import '../../tv/data/tv_repository.dart';
import '../data/barcode_repository.dart';
import '../data/scan_log_repository.dart';
import 'scan_providers.dart';
import '../domain/scan_assessment.dart';
import '../domain/barcode_lookup_result.dart';
import '../domain/barcode_resolver.dart';
import '../domain/scan_trace.dart';

class FundstueckController
    extends StateNotifier<AsyncValue<BarcodeLookupResult?>> {
  FundstueckController({
    required BarcodeResolver resolver,
    required TmdbApiClient tmdbApiClient,
    required MovieRepository movieRepository,
    required BarcodeRepository barcodeRepository,
    required TvRepository tvRepository,
    required PhysicalEditionRepository editionRepository,
    this.scanLog,
    this.assessor,
    this.onTrace,
    this.onPhase,
  }) : _resolver = resolver,
       _tmdb = tmdbApiClient,
       _movieRepository = movieRepository,
       _barcodeRepository = barcodeRepository,
       _tvRepository = tvRepository,
       _editionRepository = editionRepository,
       super(const AsyncValue.data(null));

  final BarcodeResolver _resolver;
  final TmdbApiClient _tmdb;
  final MovieRepository _movieRepository;
  final BarcodeRepository _barcodeRepository;
  final TvRepository _tvRepository;
  final PhysicalEditionRepository _editionRepository;
  final MovieMatcher _matcher = const MovieMatcher();
  final void Function(String text)? onTrace;
  final void Function(String message)? onPhase;
  final ScanLogRepository? scanLog;
  final ScanAssessor? assessor;

  Future<void> scanBarcode(String barcode, {String? formatName}) async {
    if (!mounted) return;
    onPhase?.call('Barcode wird geprüft …');
    state = const AsyncValue.loading();
    final trace = ScanTrace();
    final result = await AsyncValue.guard(
      () => _resolver.resolve(
        barcode,
        formatName: formatName,
        trace: trace,
        onProgress: onPhase,
      ),
    );
    onTrace?.call(trace.text);
    if (kDebugMode) debugPrint(trace.text);
    final value = result.valueOrNull;
    if (value != null) await _remember(barcode, value);
    if (!mounted) return;
    state = result;
  }

  Future<void> _remember(String barcode, BarcodeLookupResult result) async {
    final log = scanLog;
    if (log == null || result is BarcodeNotAProductCode) return;
    try {
      if (result is BarcodeUnresolvedOffline) {
        await log.queue(barcode);
        await log.record(code: barcode, verdict: 'pending');
        return;
      }
      final verdict = switch (result) {
        BarcodeKnownEdition(:final edition) when edition.id != 0 =>
          (await assessor?.forEdition(edition.id))?.primary.name,
        BarcodeKnownMovie(:final movie) when movie.tmdbId != null =>
          (await assessor?.forTitle(
            tmdbId: movie.tmdbId!,
            tmdbCollectionId: movie.tmdbCollectionId,
            confidence: MatchConfidence.exact,
          ))?.primary.name,
        BarcodeNeedsConfirmation() => 'probable',
        _ => 'unknown',
      };
      await log.record(
        code: barcode,
        verdict: verdict ?? 'unknown',
        title: scanTitle(result),
        movieId: result is BarcodeKnownMovie ? result.movie.id : null,
      );
    } catch (e) {
      // The history is a convenience; a failure must not hide the result.
      if (kDebugMode) debugPrint('Scan history: $e');
    }
  }

  Future<void> searchTitleFallback(String title) async {
    if (!mounted) return;
    onPhase?.call('Film oder Serie wird zugeordnet …');
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final results = await _tmdb.searchMovies(title);
      if (results.isEmpty) {
        return BarcodeNoMatch(barcode: '', productTitle: title);
      }
      final existing = await _movieRepository.getMovieByTmdbId(
        results.first.id,
      );
      if (existing != null) return BarcodeKnownMovie(existing);
      return BarcodeNeedsConfirmation(
        barcode: '',
        productTitle: title,
        candidates: _matcher.rank(title, results),
      );
    });
    if (!mounted) return;
    state = result;
  }

  Future<Movie> confirmAndSave({
    required TmdbSearchResult candidate,
    required CollectionStatus status,
    String? barcode,
    String barcodeType = 'EAN',
    String? physicalFormat,
    String? imdbId,
    String? edition,
    String? region,
  }) async {
    final hasBarcode = barcode != null && barcode.isNotEmpty;
    var movie = await _movieRepository.getMovieByTmdbId(candidate.id);
    // With a barcode the copy belongs to the scanned edition, which exists
    // only after the mapping is saved.
    movie ??= await _movieRepository.addFromTmdb(
      candidate.id,
      status: hasBarcode ? CollectionStatus.open : status,
    );

    int? editionId;
    if (hasBarcode) {
      editionId = await _barcodeRepository.saveMapping(
        barcode: barcode,
        barcodeType: barcodeType,
        movieId: movie.id,
        productTitle: candidate.title,
        editionName: edition,
        physicalFormat: physicalFormat,
        imdbId: imdbId,
        region: region,
        allowRemap: true,
      );
    }
    if (hasBarcode || movie.status != status) {
      await _movieRepository.updateStatus(
        movie.id,
        status,
        editionId: status == CollectionStatus.owned ? editionId : null,
      );
      movie = (await _movieRepository.getMovieByTmdbId(candidate.id))!;
    }

    if (mounted) state = AsyncValue.data(BarcodeKnownMovie(movie));
    return movie;
  }

  Future<void> confirmMovieBundle({
    required TmdbCollectionDetails collection,
    required List<int> selectedTmdbIds,
    required CollectionStatus status,
    required String productTitle,
    String? barcode,
    String barcodeType = 'EAN',
  }) async {
    // An owned box set is one copy of the set, not one copy per film.
    final owned = status == CollectionStatus.owned;
    final localIds = <int>[];
    for (final tmdbId in selectedTmdbIds.toSet()) {
      var movie = await _movieRepository.getMovieByTmdbId(tmdbId);
      movie ??= await _movieRepository.addFromTmdb(
        tmdbId,
        status: owned ? CollectionStatus.open : status,
      );
      if (!owned && movie.status == CollectionStatus.open) {
        await _movieRepository.updateStatus(movie.id, status);
      }
      localIds.add(movie.id);
    }

    final edition = await _editionRepository.createEdition(
      kind: PhysicalEditionKind.movieBundle,
      productTitle: productTitle,
      tmdbCollectionId: collection.id,
      movieIds: localIds,
    );
    if (owned) {
      for (final movieId in localIds) {
        await _movieRepository.updateStatus(
          movieId,
          CollectionStatus.owned,
          editionId: edition.id,
        );
      }
    }
    if (barcode != null && barcode.isNotEmpty) {
      await _barcodeRepository.saveEditionMapping(
        barcode: barcode,
        barcodeType: barcodeType,
        physicalEditionId: edition.id,
        movieId: localIds.length == 1 ? localIds.first : null,
        productTitle: productTitle,
        allowRemap: true,
      );
    }
    if (mounted) state = AsyncValue.data(BarcodeKnownEdition(edition));
  }

  Future<void> confirmTvSeasons({
    required TmdbTvDetails details,
    required List<int> selectedSeasonNumbers,
    required CollectionStatus status,
    required String productTitle,
    required PhysicalEditionKind kind,
    String? barcode,
    String barcodeType = 'EAN',
  }) async {
    final owned = status == CollectionStatus.owned;
    final statuses = {
      for (final n in selectedSeasonNumbers)
        n: owned ? CollectionStatus.open : status,
    };
    final saved = await _tvRepository.addOrUpdateFromTmdb(
      details.id,
      seasonStatuses: statuses,
    );
    final seasonIds = saved.seasons
        .where((s) => selectedSeasonNumbers.contains(s.seasonNumber))
        .map((s) => s.id)
        .toList();
    final edition = await _editionRepository.createEdition(
      kind: kind,
      productTitle: productTitle,
      tmdbTvSeriesId: details.id,
      seasonIds: seasonIds,
    );
    if (owned) {
      for (final seasonId in seasonIds) {
        await _tvRepository.setSeasonStatus(
          seasonId,
          CollectionStatus.owned,
          editionId: edition.id,
        );
      }
    }
    if (barcode != null && barcode.isNotEmpty) {
      await _barcodeRepository.saveEditionMapping(
        barcode: barcode,
        barcodeType: barcodeType,
        physicalEditionId: edition.id,
        productTitle: productTitle,
        allowRemap: true,
      );
    }
    if (mounted) state = AsyncValue.data(BarcodeKnownEdition(edition));
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final scanTraceProvider = StateProvider<String?>((ref) => null);

final lookupStatusProvider = StateProvider<String>(
  (ref) => 'Veröffentlichung wird gesucht …',
);

final fundstueckControllerProvider =
    StateNotifierProvider.autoDispose<
      FundstueckController,
      AsyncValue<BarcodeLookupResult?>
    >((ref) {
      return FundstueckController(
        resolver: ref.watch(barcodeResolverProvider),
        tmdbApiClient: ref.watch(tmdbApiClientProvider),
        movieRepository: ref.watch(movieRepositoryProvider),
        barcodeRepository: ref.watch(barcodeRepositoryProvider),
        tvRepository: ref.watch(tvRepositoryProvider),
        editionRepository: ref.watch(physicalEditionRepositoryProvider),
        scanLog: ref.watch(scanLogRepositoryProvider),
        assessor: ref.watch(scanAssessorProvider),
        onTrace: (text) => ref.read(scanTraceProvider.notifier).state = text,
        onPhase: (message) =>
            ref.read(lookupStatusProvider.notifier).state = message,
      );
    });
