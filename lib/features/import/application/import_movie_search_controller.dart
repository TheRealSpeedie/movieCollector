import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/core_providers.dart';

const _resultsPerPage = 20;

enum ImportSearchMedia { movie, tv }

class ImportMovieSearchState {
  const ImportMovieSearchState({
    this.query = '',
    this.media = ImportSearchMedia.movie,
    this.results = const [],
    this.tvResults = const [],
    this.page = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final String query;
  final ImportSearchMedia media;
  final List<TmdbSearchResult> results;
  final List<TmdbTvSearchResult> tvResults;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  ImportMovieSearchState copyWith({
    String? query,
    ImportSearchMedia? media,
    List<TmdbSearchResult>? results,
    List<TmdbTvSearchResult>? tvResults,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ImportMovieSearchState(
      query: query ?? this.query,
      media: media ?? this.media,
      results: results ?? this.results,
      tvResults: tvResults ?? this.tvResults,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ImportMovieSearchController
    extends StateNotifier<AsyncValue<ImportMovieSearchState>> {
  ImportMovieSearchController(this._tmdb)
    : super(const AsyncValue.data(ImportMovieSearchState()));

  final TmdbApiClient _tmdb;

  Future<void> setMedia(ImportSearchMedia media) async {
    final current = state.valueOrNull;
    final query = current?.query ?? '';
    state = AsyncValue.data(ImportMovieSearchState(media: media, query: query));
    if (query.trim().isNotEmpty) await search(query);
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    final media = state.valueOrNull?.media ?? ImportSearchMedia.movie;
    if (trimmed.isEmpty) {
      state = AsyncValue.data(ImportMovieSearchState(media: media));
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (media == ImportSearchMedia.tv) {
        final results = await _tmdb.searchTv(trimmed, page: 1);
        return ImportMovieSearchState(
          query: trimmed,
          media: media,
          tvResults: results,
          page: 1,
          hasMore: results.length >= _resultsPerPage,
        );
      }
      final results = await _tmdb.searchMovies(trimmed, page: 1);
      return ImportMovieSearchState(
        query: trimmed,
        media: media,
        results: results,
        page: 1,
        hasMore: results.length >= _resultsPerPage,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    final nextPage = current.page + 1;
    try {
      if (current.media == ImportSearchMedia.tv) {
        final more = await _tmdb.searchTv(current.query, page: nextPage);
        state = AsyncValue.data(
          current.copyWith(
            tvResults: [...current.tvResults, ...more],
            page: nextPage,
            hasMore: more.length >= _resultsPerPage,
            isLoadingMore: false,
          ),
        );
        return;
      }
      final more = await _tmdb.searchMovies(current.query, page: nextPage);
      state = AsyncValue.data(
        current.copyWith(
          results: [...current.results, ...more],
          page: nextPage,
          hasMore: more.length >= _resultsPerPage,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }
}

final importMovieSearchControllerProvider =
    StateNotifierProvider.autoDispose<
      ImportMovieSearchController,
      AsyncValue<ImportMovieSearchState>
    >((ref) {
      return ImportMovieSearchController(ref.watch(tmdbApiClientProvider));
    });
