import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/movie.dart';

final allMoviesProvider = StreamProvider<List<Movie>>((ref) {
  return ref.watch(movieRepositoryProvider).watchAllMovies();
});

final movieByIdProvider = StreamProvider.family<Movie?, int>((ref, id) {
  return ref.watch(movieRepositoryProvider).watchMovie(id);
});

final collectionCountsProvider =
    Provider<AsyncValue<Map<CollectionStatus, int>>>((ref) {
      final movies = ref.watch(allMoviesProvider);
      return movies.whenData((list) {
        final counts = {
          for (final status in CollectionStatus.values) status: 0,
        };
        for (final movie in list) {
          counts[movie.status] = (counts[movie.status] ?? 0) + 1;
        }
        return counts;
      });
    });

final recentlyAddedMoviesProvider = Provider<AsyncValue<List<Movie>>>((ref) {
  final movies = ref.watch(allMoviesProvider);
  return movies.whenData((list) => list.take(6).toList());
});

final movieByTmdbIdProvider = FutureProvider.autoDispose.family<Movie?, int>((
  ref,
  tmdbId,
) {
  return ref.watch(movieRepositoryProvider).getMovieByTmdbId(tmdbId);
});
