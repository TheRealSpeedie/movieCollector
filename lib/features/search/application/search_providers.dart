import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/core_providers.dart';

class MovieSearchController
    extends StateNotifier<AsyncValue<List<TmdbSearchResult>>> {
  MovieSearchController(this._tmdb)
    : super(const AsyncValue.data(<TmdbSearchResult>[]));

  final TmdbApiClient _tmdb;
  String _lastQuery = '';

  String get lastQuery => _lastQuery;

  Future<void> search(String query) async {
    final trimmed = query.trim();
    _lastQuery = trimmed;
    if (trimmed.isEmpty) {
      state = const AsyncValue.data(<TmdbSearchResult>[]);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _tmdb.searchMovies(trimmed));
  }
}

final movieSearchControllerProvider =
    StateNotifierProvider.autoDispose<
      MovieSearchController,
      AsyncValue<List<TmdbSearchResult>>
    >((ref) {
      return MovieSearchController(ref.watch(tmdbApiClientProvider));
    });

final tmdbMovieDetailsProvider = FutureProvider.autoDispose
    .family<TmdbMovieDetails, int>((ref, tmdbId) {
      return ref.watch(tmdbApiClientProvider).getMovieDetails(tmdbId);
    });
