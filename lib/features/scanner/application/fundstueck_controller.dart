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
import '../domain/barcode_lookup_result.dart';
import '../domain/barcode_resolver.dart';

class FundstueckController
    extends StateNotifier<AsyncValue<BarcodeLookupResult?>> {
  FundstueckController({
    required BarcodeResolver resolver,
    required TmdbApiClient tmdbApiClient,
    required MovieRepository movieRepository,
    required BarcodeRepository barcodeRepository,
    required TvRepository tvRepository,
    required PhysicalEditionRepository editionRepository,
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

  Future<void> scanBarcode(String barcode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _resolver.resolve(barcode));
  }

  Future<void> searchTitleFallback(String title) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
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
  }

  Future<Movie> confirmAndSave({
    required TmdbSearchResult candidate,
    required CollectionStatus status,
    String? barcode,
    String barcodeType = 'EAN',
  }) async {
    var movie = await _movieRepository.getMovieByTmdbId(candidate.id);
    if (movie == null) {
      movie = await _movieRepository.addFromTmdb(candidate.id, status: status);
    } else if (movie.status != status) {
      await _movieRepository.updateStatus(movie.id, status);
      movie = movie.copyWith(status: status);
    }

    if (barcode != null && barcode.isNotEmpty) {
      await _barcodeRepository.saveMapping(
        barcode: barcode,
        barcodeType: barcodeType,
        movieId: movie.id,
        productTitle: candidate.title,
        allowRemap: true,
      );
    }

    state = AsyncValue.data(BarcodeKnownMovie(movie));
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
    final localIds = <int>[];
    for (final tmdbId in selectedTmdbIds.toSet()) {
      var movie = await _movieRepository.getMovieByTmdbId(tmdbId);
      if (movie == null) {
        movie = await _movieRepository.addFromTmdb(tmdbId, status: status);
      } else if (movie.status != CollectionStatus.owned &&
          status == CollectionStatus.owned) {
        await _movieRepository.updateStatus(movie.id, status);
        movie = movie.copyWith(status: status);
      }
      localIds.add(movie.id);
    }

    final edition = await _editionRepository.createEdition(
      kind: PhysicalEditionKind.movieBundle,
      productTitle: productTitle,
      tmdbCollectionId: collection.id,
      movieIds: localIds,
    );
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
    state = AsyncValue.data(BarcodeKnownEdition(edition));
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
    final statuses = {for (final n in selectedSeasonNumbers) n: status};
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
    if (barcode != null && barcode.isNotEmpty) {
      await _barcodeRepository.saveEditionMapping(
        barcode: barcode,
        barcodeType: barcodeType,
        physicalEditionId: edition.id,
        productTitle: productTitle,
        allowRemap: true,
      );
    }
    state = AsyncValue.data(BarcodeKnownEdition(edition));
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

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
      );
    });
