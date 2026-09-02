import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/features/collections/data/collection_repository.dart';
import 'package:movie_shelf/features/editions/data/physical_edition_repository.dart';
import 'package:movie_shelf/features/import/data/import_repository.dart';
import 'package:movie_shelf/features/import/domain/import_models.dart';
import 'package:movie_shelf/features/movies/data/movie_repository.dart';
import 'package:movie_shelf/features/tv/data/tv_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

const _action = TmdbGenre(id: 28, name: 'Action');
const _comedy = TmdbGenre(id: 35, name: 'Komödie');
const _horror = TmdbGenre(id: 27, name: 'Horror');
const _sciFi = TmdbGenre(id: 878, name: 'Science Fiction');

const _residentEvilCollection = TmdbCollectionRef(
  id: 1570,
  name: 'Resident Evil Collection',
);
const _sharknadoCollection = TmdbCollectionRef(
  id: 86055,
  name: 'Sharknado Collection',
);

TmdbMovieDetails _details({
  required int id,
  required String title,
  List<TmdbGenre> genres = const [_action],
  TmdbCollectionRef? collection,
  String? posterPath = '/poster.jpg',
  String? overview = 'Beschreibung',
  String? certification = '16',
}) {
  return TmdbMovieDetails(
    id: id,
    title: title,
    genres: genres,
    collection: collection,
    posterPath: posterPath,
    overview: overview,
    certification: certification,
  );
}

final _fixtureMovies = <int, TmdbMovieDetails>{
  10200: _details(id: 10200, title: 'Mr. Bean macht Ferien', genres: [_comedy]),
  579: _details(id: 579, title: 'Piranha 2', genres: [_horror, _action]),
  82690: _details(
    id: 82690,
    title: "Ralph reicht's",
    genres: [_comedy, _action],
  ),
  2028: _details(id: 2028, title: 'Mr. Deeds', genres: [_comedy]),
  68726: _details(id: 68726, title: 'Pacific Rim', genres: [_action, _sciFi]),
  1885: _details(id: 1885, title: 'Karate Kid', genres: [_action]),
  198184: _details(id: 198184, title: 'Fack ju Göhte 1', genres: [_comedy]),
  7278: _details(
    id: 7278,
    title: 'The Day After Tomorrow',
    genres: [_action, _sciFi],
  ),
  277: _details(
    id: 277,
    title: 'Underworld: Evolution',
    genres: [_action, _horror],
  ),
  157350: _details(
    id: 157350,
    title: 'Resident Evil: Retribution',
    genres: [_action, _horror],
    collection: _residentEvilCollection,
  ),
  1576: _details(
    id: 1576,
    title: 'Resident Evil',
    genres: [_action, _horror],
    collection: _residentEvilCollection,
  ),
  30497: _details(
    id: 30497,
    title: 'Sharknado',
    genres: [_horror, _comedy, _action],
    collection: _sharknadoCollection,
  ),
  254472: _details(
    id: 254472,
    title: 'Sharknado 2',
    genres: [_horror, _comedy, _action],
    collection: _sharknadoCollection,
  ),
  277685: _details(
    id: 277685,
    title: 'Sharknado 3',
    genres: [_horror, _comedy, _action],
    collection: _sharknadoCollection,
  ),
  347375: _details(
    id: 347375,
    title: 'Sharknado 4',
    genres: [_horror, _comedy, _action],
    collection: _sharknadoCollection,
  ),
  382517: _details(
    id: 382517,
    title: 'Sharknado 5',
    genres: [_horror, _comedy, _action],
    collection: _sharknadoCollection,
  ),
  390054: _details(
    id: 390054,
    title: 'The Last Sharknado',
    genres: [_horror, _comedy, _action],
    collection: _sharknadoCollection,
  ),
  999001: const TmdbMovieDetails(id: 999001, title: 'Ohne Poster'),
};

const _sharknadoBundle = TmdbCollectionDetails(
  id: 86055,
  name: 'Sharknado Collection',
  parts: [
    TmdbCollectionMovieRef(id: 30497, title: 'Sharknado'),
    TmdbCollectionMovieRef(id: 254472, title: 'Sharknado 2'),
    TmdbCollectionMovieRef(id: 277685, title: 'Sharknado 3'),
    TmdbCollectionMovieRef(id: 347375, title: 'Sharknado 4'),
    TmdbCollectionMovieRef(id: 382517, title: 'Sharknado 5'),
    TmdbCollectionMovieRef(id: 390054, title: 'The Last Sharknado'),
  ],
);

class _FakeTmdb extends Fake implements TmdbApiClient {
  _FakeTmdb({Map<int, TmdbMovieDetails>? movies})
    : movies = movies ?? _fixtureMovies;

  final Map<int, TmdbMovieDetails> movies;
  Set<int> failDetails = {};

  @override
  Future<TmdbMovieDetails> getMovieDetails(int tmdbId) async {
    if (failDetails.contains(tmdbId)) {
      throw const ApiUnavailableException();
    }
    final details = movies[tmdbId];
    if (details == null) {
      throw StateError('No fixture for $tmdbId');
    }
    return details;
  }

  @override
  Future<TmdbCollectionDetails> getCollection(int collectionId) async {
    if (collectionId == 86055) return _sharknadoBundle;
    return TmdbCollectionDetails(
      id: collectionId,
      name: 'Collection $collectionId',
      parts: const [],
    );
  }
}

class _ThrowingMovieRepository extends MovieRepository {
  _ThrowingMovieRepository(
    super.db,
    super.tmdb,
    super.collectionRepository, {
    required this.throwOnTmdbId,
  });

  final int throwOnTmdbId;

  @override
  Future<MovieUpsertResult> upsertFromDetails(
    TmdbMovieDetails details, {
    required CollectionStatus status,
    bool syncCollection = true,
  }) {
    if (details.id == throwOnTmdbId) {
      throw StateError('forced persist failure');
    }
    return super.upsertFromDetails(
      details,
      status: status,
      syncCollection: syncCollection,
    );
  }
}

ImportRow _movieRow({
  required int index,
  required String title,
  required int tmdbId,
}) {
  return ImportRow(
    index: index,
    rawLine: title,
    parsedTitle: title,
    status: ImportRowStatus.matchedAutomatically,
    selectedCandidate: TmdbSearchResult(id: tmdbId, title: title),
    target: ImportTarget.singleMovie(
      movie: TmdbSearchResult(id: tmdbId, title: title),
    ),
  );
}

void main() {
  late AppDatabase db;
  late _FakeTmdb tmdb;
  late MovieRepository movies;
  late CollectionRepository collections;
  late TvRepository tv;
  late PhysicalEditionRepository editions;
  late ImportRepository importer;

  ImportRepository buildImporter({MovieRepository? movieRepository}) {
    return ImportRepository(
      tmdb,
      movieRepository ?? movies,
      database: db,
      collectionRepository: collections,
      tvRepository: tv,
      editionRepository: editions,
      wait: (_) async {},
    );
  }

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tmdb = _FakeTmdb();
    collections = CollectionRepository(db, tmdb);
    movies = MovieRepository(db, tmdb, collections);
    tv = TvRepository(db, tmdb);
    editions = PhysicalEditionRepository(db);
    importer = buildImporter();
  });

  tearDown(() => db.close());

  test('realistic import fixture persists every resolved title', () async {
    final rows = [
      _movieRow(index: 0, title: 'Mr. Bean macht Ferien', tmdbId: 10200),
      _movieRow(index: 1, title: 'Piranha 2', tmdbId: 579),
      _movieRow(index: 2, title: "Ralph reicht's", tmdbId: 82690),
      _movieRow(index: 3, title: 'Mr. Deeds', tmdbId: 2028),
      _movieRow(index: 4, title: 'Pacific Rim', tmdbId: 68726),
      _movieRow(index: 5, title: 'Karate Kid', tmdbId: 1885),
      _movieRow(index: 6, title: 'Fack ju Göhte 1', tmdbId: 198184),
      const ImportRow(
        index: 7,
        rawLine: 'Sharknado 1-6',
        parsedTitle: 'Sharknado',
        status: ImportRowStatus.matchedManually,
        target: ImportTarget.movieBundle(
          collection: _sharknadoBundle,
          selectedTmdbIds: [30497, 254472, 277685, 347375, 382517, 390054],
        ),
      ),
      _movieRow(index: 8, title: 'The Day after Tomorrow', tmdbId: 7278),
      _movieRow(index: 9, title: 'Underworld Evolution', tmdbId: 277),
      _movieRow(index: 10, title: 'Resident Evil Retribution', tmdbId: 157350),
      _movieRow(index: 11, title: 'Resident Evil 1', tmdbId: 1576),
      _movieRow(index: 12, title: 'Ohne Poster', tmdbId: 999001),
    ];

    final report = await importer.commit(rows, CollectionStatus.owned);

    expect(
      report.failed,
      0,
      reason: report.failures.map((f) => f.developerMessage).join('; '),
    );
    expect(report.processedSourceRows, 13);
    expect(report.importedMovies, 18);
    expect(report.successfulSourceRows, 13);

    final stored = await db.select(db.movies).get();
    expect(stored, hasLength(18));
    final genres = await db.select(db.genres).get();
    expect(genres.map((g) => g.tmdbId).toSet(), {28, 35, 27, 878});

    final bundleLinks = await db.select(db.physicalEditionMovies).get();
    final localIds = stored.map((m) => m.id).toSet();
    expect(
      bundleLinks.every((link) => localIds.contains(link.movieId)),
      isTrue,
    );
    expect(
      bundleLinks.every(
        (link) => const {
          30497,
          254472,
          277685,
          347375,
          382517,
          390054,
        }.contains(link.movieId),
      ),
      isFalse,
    );
  });

  test('twenty movies sharing a genre all persist', () async {
    tmdb = _FakeTmdb(
      movies: {
        for (var i = 1; i <= 20; i++)
          i: _details(id: i, title: 'Film $i', genres: [_action, _comedy]),
      },
    );
    collections = CollectionRepository(db, tmdb);
    movies = MovieRepository(db, tmdb, collections);
    importer = buildImporter();

    final rows = [
      for (var i = 1; i <= 20; i++)
        _movieRow(index: i - 1, title: 'Film $i', tmdbId: i),
    ];
    final report = await importer.commit(rows, CollectionStatus.owned);
    expect(report.failed, 0);
    expect(report.importedMovies, 20);
    expect(await db.select(db.movies).get(), hasLength(20));
    expect(await db.select(db.genres).get(), hasLength(2));
  });

  test('shared TMDB collection can be referenced by several movies', () async {
    final rows = [
      _movieRow(index: 0, title: 'Resident Evil 1', tmdbId: 1576),
      _movieRow(index: 1, title: 'Resident Evil Retribution', tmdbId: 157350),
    ];
    final report = await importer.commit(rows, CollectionStatus.owned);
    expect(report.failed, 0);
    final stored = await db.select(db.movies).get();
    expect(stored.every((m) => m.tmdbCollectionId == 1570), isTrue);
  });

  test(
    'importing an existing movie updates status instead of failing',
    () async {
      await movies.upsertFromDetails(
        _fixtureMovies[68726]!,
        status: CollectionStatus.wishlist,
        syncCollection: false,
      );

      final report = await importer.commit([
        _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
      ], CollectionStatus.owned);

      expect(report.failed, 0);
      expect(report.importedMovies, 0);
      expect(report.updated, 1);
      expect(await db.select(db.movies).get(), hasLength(1));
      expect(
        (await movies.getMovieByTmdbId(68726))!.status,
        CollectionStatus.owned,
      );
    },
  );

  test('owned movies are not downgraded by a weaker import status', () async {
    await movies.upsertFromDetails(
      _fixtureMovies[68726]!,
      status: CollectionStatus.owned,
      syncCollection: false,
    );

    final report = await importer.commit([
      _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
    ], CollectionStatus.wishlist);

    expect(report.alreadyExisted, 1);
    expect(report.updated, 0);
    expect(
      (await movies.getMovieByTmdbId(68726))!.status,
      CollectionStatus.owned,
    );
  });

  test('nullable TMDB metadata still persists', () async {
    final report = await importer.commit([
      _movieRow(index: 0, title: 'Ohne Poster', tmdbId: 999001),
    ], CollectionStatus.owned);
    expect(report.failed, 0);
    final row = (await db.select(db.movies).get()).single;
    expect(row.title, 'Ohne Poster');
    expect(row.posterPath, isNull);
    expect(row.certification, isNull);
    expect(row.overview, isNull);
    expect(row.tmdbCollectionId, isNull);
  });

  test('movie bundle saves atomically with local movie ids', () async {
    final report = await importer.commit([
      const ImportRow(
        index: 0,
        rawLine: 'Sharknado 1-6',
        parsedTitle: 'Sharknado',
        status: ImportRowStatus.matchedManually,
        target: ImportTarget.movieBundle(
          collection: _sharknadoBundle,
          selectedTmdbIds: [30497, 254472, 277685, 347375, 382517, 390054],
        ),
      ),
    ], CollectionStatus.owned);

    expect(report.failed, 0);
    expect(report.importedMovies, 6);
    expect(report.processedSourceRows, 1);
    final editionMovies = await db.select(db.physicalEditionMovies).get();
    expect(editionMovies, hasLength(6));
    final localIds = (await db.select(db.movies).get())
        .map((m) => m.id)
        .toSet();
    expect(
      editionMovies.every((row) => localIds.contains(row.movieId)),
      isTrue,
    );
  });

  test('partial duplicate bundle only adds missing movies', () async {
    await movies.upsertFromDetails(
      _fixtureMovies[30497]!,
      status: CollectionStatus.owned,
      syncCollection: false,
    );
    await movies.upsertFromDetails(
      _fixtureMovies[254472]!,
      status: CollectionStatus.owned,
      syncCollection: false,
    );

    final report = await importer.commit([
      const ImportRow(
        index: 0,
        rawLine: 'Sharknado 1-6',
        parsedTitle: 'Sharknado',
        status: ImportRowStatus.matchedManually,
        target: ImportTarget.movieBundle(
          collection: _sharknadoBundle,
          selectedTmdbIds: [30497, 254472, 277685, 347375, 382517, 390054],
        ),
      ),
    ], CollectionStatus.owned);

    expect(report.failed, 0);
    expect(report.importedMovies, 4);
    expect(report.alreadyExisted, 2);
    expect(await db.select(db.movies).get(), hasLength(6));
  });

  test(
    'a failed source row rolls back that row and leaves others intact',
    () async {
      final throwing = _ThrowingMovieRepository(
        db,
        tmdb,
        collections,
        throwOnTmdbId: 30497,
      );
      importer = buildImporter(movieRepository: throwing);

      final report = await importer.commit([
        _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
        const ImportRow(
          index: 1,
          rawLine: 'Sharknado 1-6',
          parsedTitle: 'Sharknado',
          status: ImportRowStatus.matchedManually,
          target: ImportTarget.movieBundle(
            collection: _sharknadoBundle,
            selectedTmdbIds: [30497, 254472, 277685],
          ),
        ),
        _movieRow(index: 2, title: 'Karate Kid', tmdbId: 1885),
      ], CollectionStatus.owned);

    expect(report.failedSourceRows, 1);
    expect(report.successfulSourceRows, 2);
    expect(report.importedMovies, 2);
    final stored = await db.select(db.movies).get();
    expect(stored.map((m) => m.tmdbId), unorderedEquals([68726, 1885]));
    final editionRows = await db.select(db.physicalEditions).get();
    expect(editionRows.every((row) => row.mediaKind != 'movieBundle'), isTrue);
    },
  );

  test('failure isolation continues after a failed middle row', () async {
    tmdb.failDetails = {2028};
    final rows = [
      _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
      _movieRow(index: 1, title: 'Karate Kid', tmdbId: 1885),
      _movieRow(index: 2, title: 'Mr. Deeds', tmdbId: 2028),
      _movieRow(index: 3, title: 'Piranha 2', tmdbId: 579),
      _movieRow(index: 4, title: "Ralph reicht's", tmdbId: 82690),
    ];
    final report = await importer.commit(rows, CollectionStatus.owned);
    expect(report.failed, 1);
    expect(report.importedMovies, 4);
    expect(report.outcomes[2].kind, ImportRowOutcomeKind.failed);
    expect(await db.select(db.movies).get(), hasLength(4));
  });

  test('retry only failed rows and does not duplicate successes', () async {
    tmdb.failDetails = {2028};
    final rows = [
      _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
      _movieRow(index: 1, title: 'Mr. Deeds', tmdbId: 2028),
      _movieRow(index: 2, title: 'Karate Kid', tmdbId: 1885),
    ];
    final first = await importer.commit(rows, CollectionStatus.owned);
    expect(first.failed, 1);
    expect(first.importedMovies, 2);

    tmdb.failDetails = {};
    final retry = await importer.commit(
      rows,
      CollectionStatus.owned,
      onlyIndexes: first.failedRowIndexes.toSet(),
    );
    final merged = first.mergeRetry(retry);
    expect(merged.failed, 0);
    expect(merged.importedMovies, 3);
    expect(await db.select(db.movies).get(), hasLength(3));
  });

  test('progress increments once per source row', () async {
    final snapshots = <ImportSaveProgress>[];
    await importer.commit(
      [
        _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
        _movieRow(index: 1, title: 'Karate Kid', tmdbId: 1885),
      ],
      CollectionStatus.owned,
      onProgress: snapshots.add,
    );
    expect(snapshots, isNotEmpty);
    expect(snapshots.last.processed, 2);
    expect(snapshots.last.total, 2);
    expect(snapshots.last.moviesAdded, 2);
  });

  test('source-entry counts stay separate from logical movie counts', () async {
    final report = await importer.commit([
      _movieRow(index: 0, title: 'Pacific Rim', tmdbId: 68726),
      const ImportRow(
        index: 1,
        rawLine: 'Sharknado 1-6',
        parsedTitle: 'Sharknado',
        status: ImportRowStatus.matchedManually,
        target: ImportTarget.movieBundle(
          collection: _sharknadoBundle,
          selectedTmdbIds: [30497, 254472, 277685],
        ),
      ),
    ], CollectionStatus.owned);
    expect(report.processedSourceRows, 2);
    expect(report.importedMovies, 4);
  });

  test(
    'sqlite unique genre failures are classified as database constraints',
    () {
      final failure = importSaveFailureFrom(
        Exception(
          'SqliteException(2067): UNIQUE constraint failed: genres.tmdb_id',
        ),
        sourceText: 'Pacific Rim',
        targetType: 'SingleMovie',
      );
      expect(failure.category, ImportSaveFailureCategory.databaseConstraint);
      expect(failure.userMessage, contains('Datenbankkonflikt'));
      expect(failure.developerMessage, contains('UNIQUE constraint failed'));
    },
  );
}
