import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/network/dio_client.dart';
import 'package:movie_shelf/core/network/network_info.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/core/providers/core_providers.dart';
import 'package:movie_shelf/features/collections/data/collection_repository.dart';
import 'package:movie_shelf/features/collections/presentation/franchise_section.dart';
import 'package:movie_shelf/features/movies/data/movie_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

void main() {
  late AppDatabase db;
  late _DetailsById tmdb;
  late MovieRepository movies;
  late CollectionRepository collections;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmdb = _DetailsById();
    collections = CollectionRepository(db, tmdb);
    movies = MovieRepository(db, tmdb, collections);
    tmdb.collection = TmdbCollectionDetails(
      id: 295,
      name: 'Pirates of the Caribbean',
      parts: [
        for (final film in _films)
          TmdbCollectionMovieRef(
            id: film.$1,
            title: film.$2,
            releaseDate: film.$3,
          ),
      ],
    );
    await collections.syncCollection(295);
  });

  tearDown(() => db.close());

  test('marking a film open keeps its physical edition', () async {
    await movies.setCollectionStatus(1, CollectionStatus.owned);
    final movie = await movies.getMovieByTmdbId(1);
    final editionId = await db
        .into(db.physicalEditions)
        .insert(PhysicalEditionsCompanion.insert(mediaKind: 'movie'));
    await db
        .into(db.physicalEditionMovies)
        .insert(
          PhysicalEditionMoviesCompanion.insert(
            editionId: editionId,
            movieId: movie!.id,
          ),
        );
    await db
        .into(db.barcodes)
        .insert(
          BarcodesCompanion.insert(
            movieId: Value(movie.id),
            physicalEditionId: Value(editionId),
            barcode: '012345678905',
            barcodeType: 'UPC-A',
          ),
        );

    await movies.setCollectionStatus(1, CollectionStatus.open);

    final updated = await movies.getMovieByTmdbId(1);
    expect(updated!.status, CollectionStatus.open);
    // The edition created when the film was owned and the scanned one both stay.
    expect(await db.select(db.physicalEditions).get(), hasLength(2));
    expect(await db.select(db.physicalEditionMovies).get(), hasLength(2));
    expect(await db.select(db.ownedCopies).get(), isEmpty);
    expect(await db.select(db.barcodes).get(), hasLength(1));
    expect((await db.select(db.movies).get()).length, 1);
  });

  test(
    'open does not create a movie row for a film that is not saved',
    () async {
      await movies.setCollectionStatus(4, CollectionStatus.open);
      expect(await movies.getMovieByTmdbId(4), isNull);
      expect(await db.select(db.physicalEditions).get(), isEmpty);
    },
  );

  testWidgets('dropdown edits stay draft until save', (tester) async {
    await _pump(tester, db, tmdb);

    expect(find.text('0 von 5 gesammelt'), findsOneWidget);
    expect(find.text('5 Filme fehlen'), findsOneWidget);
    expect(find.text('Aktuell gescannt'), findsOneWidget);
    expect(_saveEnabled(tester), isFalse);
    expect(await db.select(db.movies).get(), isEmpty);

    await _choose(tester, 3, CollectionStatus.owned);

    expect(find.text('1 von 5 gesammelt'), findsOneWidget);
    expect(find.text('4 Filme fehlen'), findsOneWidget);
    expect(find.text('Aktuell gescannt'), findsOneWidget);
    expect(_status(tester, 3), CollectionStatus.owned);
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.ensureVisible(find.byKey(const Key('franchise-save')));
    await tester.tap(find.byKey(const Key('franchise-save')));
    await tester.pumpAndSettle();

    expect(find.text('1 von 5 gesammelt'), findsOneWidget);
    expect(find.text('Aktuell gescannt'), findsOneWidget);
    expect(_saveEnabled(tester), isFalse);
    final saved = await db.select(db.movies).get();
    expect(saved, hasLength(1));
    expect(saved.single.tmdbId, 3);
    expect(saved.single.userStatus, CollectionStatus.owned);
    expect(await db.select(db.physicalEditions).get(), hasLength(1));
    expect(await db.select(db.ownedCopies).get(), hasLength(1));

    await _close(tester);
  });

  testWidgets('bulk actions draft every film including the scanned one', (
    tester,
  ) async {
    await _pump(tester, db, tmdb);

    await tester.ensureVisible(find.byKey(const Key('franchise-all-owned')));
    await tester.tap(find.byKey(const Key('franchise-all-owned')));
    await tester.pumpAndSettle();

    expect(find.text('5 von 5 gesammelt'), findsOneWidget);
    expect(find.text('Filmreihe komplett'), findsOneWidget);
    for (final film in _films) {
      expect(_status(tester, film.$1), CollectionStatus.owned);
    }
    expect(find.text('Aktuell gescannt'), findsOneWidget);
    expect(await db.select(db.movies).get(), isEmpty);

    await _choose(tester, 4, CollectionStatus.wishlist);

    expect(find.text('4 von 5 gesammelt'), findsOneWidget);
    expect(find.text('1 Wunschliste'), findsOneWidget);
    expect(_status(tester, 3), CollectionStatus.owned);
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.ensureVisible(find.byKey(const Key('franchise-all-wishlist')));
    await tester.tap(find.byKey(const Key('franchise-all-wishlist')));
    await tester.pumpAndSettle();

    expect(find.text('0 von 5 gesammelt'), findsOneWidget);
    expect(find.text('5 Wunschliste'), findsOneWidget);
    for (final film in _films) {
      expect(_status(tester, film.$1), CollectionStatus.wishlist);
    }
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.ensureVisible(find.byKey(const Key('franchise-save')));
    await tester.tap(find.byKey(const Key('franchise-save')));
    await tester.pumpAndSettle();

    final saved = await db.select(db.movies).get();
    expect(saved, hasLength(5));
    expect(
      saved.every((row) => row.userStatus == CollectionStatus.wishlist),
      isTrue,
    );
    expect(saved.map((row) => row.tmdbId), contains(3));
    expect(find.text('Aktuell gescannt'), findsOneWidget);
    expect(await db.select(db.physicalEditions).get(), isEmpty);

    await _close(tester);
  });

  testWidgets('leaving discards unsaved franchise edits', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          tmdbApiClientProvider.overrideWithValue(tmdb),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: const Text('Reihe')),
                          body: const SingleChildScrollView(
                            child: FranchiseSection(
                              tmdbMovieId: 3,
                              pendingConfirmation: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Reihe öffnen'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Reihe öffnen'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('franchise-all-owned')));
    await tester.tap(find.byKey(const Key('franchise-all-owned')));
    await tester.pumpAndSettle();
    expect(find.text('5 von 5 gesammelt'), findsOneWidget);
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Änderungen verwerfen?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('franchise-discard-cancel')));
    await tester.pumpAndSettle();
    expect(find.text('5 von 5 gesammelt'), findsOneWidget);
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('franchise-discard-confirm')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.text('Reihe öffnen'), findsOneWidget);
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.tap(find.text('Reihe öffnen'));
    await tester.pumpAndSettle();
    expect(find.text('0 von 5 gesammelt'), findsOneWidget);
    expect(find.text('5 Filme fehlen'), findsOneWidget);

    await _close(tester);
  });

  testWidgets('scan save commits the scanned film with the other drafts', (
    tester,
  ) async {
    final committed = <CollectionStatus>[];
    await _pump(
      tester,
      db,
      tmdb,
      onCommitScanned: (status) async {
        committed.add(status);
      },
    );

    expect(_saveEnabled(tester), isTrue);
    expect(committed, isEmpty);
    expect(await db.select(db.movies).get(), isEmpty);

    await tester.ensureVisible(find.byKey(const Key('franchise-all-owned')));
    await tester.tap(find.byKey(const Key('franchise-all-owned')));
    await tester.pumpAndSettle();
    expect(committed, isEmpty);
    expect(_status(tester, 3), CollectionStatus.owned);

    await tester.ensureVisible(find.byKey(const Key('franchise-save')));
    await tester.tap(find.byKey(const Key('franchise-save')));
    await tester.pumpAndSettle();

    expect(committed, [CollectionStatus.owned]);
    final saved = await db.select(db.movies).get();
    expect(saved.map((row) => row.tmdbId).toSet(), {1, 2, 4, 5});
    expect(
      saved.every((row) => row.userStatus == CollectionStatus.owned),
      isTrue,
    );
    expect(await db.select(db.ownedCopies).get(), hasLength(4));

    await _close(tester);
  });

  testWidgets('saving open keeps the physical edition', (tester) async {
    await movies.setCollectionStatus(1, CollectionStatus.owned);
    final movie = await movies.getMovieByTmdbId(1);
    final editionId = await db
        .into(db.physicalEditions)
        .insert(PhysicalEditionsCompanion.insert(mediaKind: 'movie'));
    await db
        .into(db.physicalEditionMovies)
        .insert(
          PhysicalEditionMoviesCompanion.insert(
            editionId: editionId,
            movieId: movie!.id,
          ),
        );
    await db
        .into(db.barcodes)
        .insert(
          BarcodesCompanion.insert(
            movieId: Value(movie.id),
            physicalEditionId: Value(editionId),
            barcode: '012345678905',
            barcodeType: 'UPC-A',
          ),
        );

    await _pump(tester, db, tmdb);
    expect(_status(tester, 1), CollectionStatus.owned);

    await _choose(tester, 1, CollectionStatus.open);
    expect(find.text('0 von 5 gesammelt'), findsOneWidget);
    expect((await movies.getMovieByTmdbId(1))!.status, CollectionStatus.owned);

    await tester.ensureVisible(find.byKey(const Key('franchise-save')));
    await tester.tap(find.byKey(const Key('franchise-save')));
    await tester.pumpAndSettle();

    expect((await movies.getMovieByTmdbId(1))!.status, CollectionStatus.open);
    expect(await db.select(db.physicalEditions).get(), hasLength(2));
    expect(await db.select(db.physicalEditionMovies).get(), hasLength(2));
    expect(await db.select(db.ownedCopies).get(), isEmpty);
    expect(await db.select(db.barcodes).get(), hasLength(1));

    await _close(tester);
  });
}

CollectionStatus _status(WidgetTester tester, int tmdbId) {
  return tester
      .widget<DropdownButton<CollectionStatus>>(
        find.byKey(Key('franchise-status-$tmdbId')),
      )
      .value!;
}

bool _saveEnabled(WidgetTester tester) {
  return tester
          .widget<FilledButton>(find.byKey(const Key('franchise-save')))
          .onPressed !=
      null;
}

Future<void> _choose(
  WidgetTester tester,
  int tmdbId,
  CollectionStatus status,
) async {
  final button = find.byKey(Key('franchise-status-$tmdbId'));
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
  await tester.tap(find.text(status.germanLabel).last);
  await tester.pumpAndSettle();
}

Future<void> _close(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> _pump(
  WidgetTester tester,
  AppDatabase db,
  TmdbApiClient tmdb, {
  Future<void> Function(CollectionStatus status)? onCommitScanned,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        tmdbApiClientProvider.overrideWithValue(tmdb),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FranchiseSection(
              tmdbMovieId: 3,
              pendingConfirmation: true,
              onCommitScanned: onCommitScanned,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

final _films = <(int, String, DateTime)>[
  (1, 'The Curse of the Black Pearl', DateTime(2003, 7, 9)),
  (2, "Dead Man's Chest", DateTime(2006, 7, 7)),
  (3, "At World's End", DateTime(2007, 5, 19)),
  (4, 'On Stranger Tides', DateTime(2011, 5, 20)),
  (5, 'Dead Men Tell No Tales', DateTime(2017, 5, 26)),
];

class _DetailsById extends TmdbApiClient {
  _DetailsById() : super(DioClient(dio: Dio(), networkInfo: _Offline()));

  TmdbCollectionDetails collection = const TmdbCollectionDetails(
    id: 295,
    name: 'Pirates of the Caribbean',
  );

  @override
  Future<TmdbMovieDetails> getMovieDetails(int tmdbId) async {
    final known = _films.where((film) => film.$1 == tmdbId);
    final title = known.isEmpty ? 'Film $tmdbId' : known.first.$2;
    final date = known.isEmpty ? null : known.first.$3;
    return TmdbMovieDetails(
      id: tmdbId,
      title: title,
      releaseDate: date,
      collection: TmdbCollectionRef(id: collection.id, name: collection.name),
    );
  }

  @override
  Future<TmdbCollectionDetails> getCollection(int collectionId) async {
    return collection;
  }
}

class _Offline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}
