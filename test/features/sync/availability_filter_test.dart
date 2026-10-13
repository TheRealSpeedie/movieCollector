import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/providers/shared_preferences_provider.dart';
import 'package:movie_shelf/features/collection/application/collection_filter_controller.dart';
import 'package:movie_shelf/features/movies/application/movie_providers.dart';
import 'package:movie_shelf/features/server/application/server_providers.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/server/domain/server_models.dart';
import 'package:movie_shelf/features/sync/application/sync_providers.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../server/support/fakes.dart';

Movie movie(int id, int? tmdbId) => Movie(
  id: id,
  tmdbId: tmdbId,
  title: 'Film $id',
  status: CollectionStatus.owned,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

ServerTitle title(int id, int tmdbId) => ServerTitle(
  id: id,
  isSeries: false,
  tmdbId: tmdbId,
  name: 'Server $id',
  year: 2020,
  posterUrl: null,
  runtimeMinutes: 100,
  genres: const [],
  rating: null,
  qualities: const ['1080p'],
  favorite: false,
  watched: false,
  fraction: 0,
  watchedEpisodes: 0,
  totalEpisodes: 0,
);

Future<ProviderContainer> container({required bool connected}) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      allMoviesProvider.overrideWith(
        (ref) => Stream.value([movie(1, 100), movie(2, 200), movie(3, null)]),
      ),
      serverClientProvider.overrideWith(
        (ref) => connected
            ? ServerClient(
                credentials: sampleCredentials(),
                store: MemoryStore(),
                discovery: FakeDiscovery(),
                onRevoked: () {},
              )
            : null,
      ),
      serverMoviesProvider.overrideWith(
        (ref) async => [title(10, 100), title(11, 999)],
      ),
    ],
  );
  addTearDown(container.dispose);
  await container.read(allMoviesProvider.future);
  await container.read(serverMoviesProvider.future);
  return container;
}

List<int> ids(ProviderContainer container) =>
    [for (final m in container.read(filteredMoviesProvider).value!) m.id]
      ..sort();

void main() {
  test('physical keeps only movies without a server copy', () async {
    final c = await container(connected: true);
    c
        .read(collectionFilterControllerProvider.notifier)
        .setAvailability(Availability.physical);

    expect(ids(c), [2, 3]);
  });

  test('both keeps only movies with the same tmdb id on the server', () async {
    final c = await container(connected: true);
    c
        .read(collectionFilterControllerProvider.notifier)
        .setAvailability(Availability.both);

    expect(ids(c), [1]);
  });

  test('all and digital leave the collection list untouched', () async {
    final c = await container(connected: true);
    final notifier = c.read(collectionFilterControllerProvider.notifier);

    expect(ids(c), [1, 2, 3]);
    notifier.setAvailability(Availability.digital);
    expect(ids(c), [1, 2, 3]);
  });

  test('without a server connection the filter has no effect', () async {
    final c = await container(connected: false);
    c
        .read(collectionFilterControllerProvider.notifier)
        .setAvailability(Availability.both);

    expect(ids(c), [1, 2, 3]);
  });

  test('server titles are matched to movies by tmdb id', () async {
    final c = await container(connected: true);

    expect(c.read(serverMovieByTmdbIdProvider(100))?.id, 10);
    expect(c.read(serverMovieByTmdbIdProvider(200)), isNull);
    expect(c.read(serverTmdbIdsProvider), {100, 999});
  });
}
