import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/network/dio_client.dart';
import 'package:movie_shelf/core/network/network_info.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/features/collections/data/collection_repository.dart';

void main() {
  late AppDatabase db;
  late _ScriptedTmdb tmdb;
  late CollectionRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tmdb = _ScriptedTmdb();
    repository = CollectionRepository(db, tmdb);
  });

  tearDown(() => db.close());

  test('a movie without belongs_to_collection has no franchise', () async {
    tmdb.details = const TmdbMovieDetails(id: 8, title: 'Heat');

    expect(await repository.resolveFranchiseId(8), isNull);
    expect(await repository.resolveFranchiseId(8), isNull);

    expect(tmdb.detailCalls, 1);
    expect(tmdb.collectionCalls, 0);
  });

  test('loads collection parts and reuses them for the next film', () async {
    tmdb.details = const TmdbMovieDetails(
      id: 3,
      title: "At World's End",
      collection: TmdbCollectionRef(id: 295, name: 'Pirates of the Caribbean'),
    );
    tmdb.collection = TmdbCollectionDetails(
      id: 295,
      name: 'Pirates of the Caribbean',
      parts: [
        TmdbCollectionMovieRef(
          id: 5,
          title: 'Dead Men Tell No Tales',
          releaseDate: DateTime(2017, 5, 26),
        ),
        TmdbCollectionMovieRef(
          id: 1,
          title: 'The Curse of the Black Pearl',
          releaseDate: DateTime(2003, 7, 9),
        ),
        const TmdbCollectionMovieRef(id: 4, title: 'On Stranger Tides'),
        TmdbCollectionMovieRef(
          id: 3,
          title: "At World's End",
          releaseDate: DateTime(2007, 5, 19),
        ),
      ],
    );

    expect(await repository.resolveFranchiseId(3), 295);
    final info = await repository.watchFranchise(295, 3).first;

    expect(info!.name, 'Pirates of the Caribbean');
    expect(
      info.parts.map((part) => part.tmdbMovieId),
      [1, 3, 5, 4],
    );
    expect(info.parts[1].isCurrent, isTrue);

    expect(await repository.resolveFranchiseId(1), 295);
    expect(tmdb.detailCalls, 1);
    expect(tmdb.collectionCalls, 1);
  });

  test('a collection request failure does not throw', () async {
    tmdb.failDetails = true;
    expect(await repository.resolveFranchiseId(3), isNull);

    tmdb.failDetails = false;
    tmdb.failCollection = true;
    tmdb.details = const TmdbMovieDetails(
      id: 3,
      title: "At World's End",
      collection: TmdbCollectionRef(id: 295, name: 'Pirates of the Caribbean'),
    );
    expect(await repository.resolveFranchiseId(3), 295);
    expect(await repository.watchFranchise(295, 3).first, isNull);
  });
}

class _ScriptedTmdb extends TmdbApiClient {
  _ScriptedTmdb() : super(DioClient(dio: Dio(), networkInfo: _Offline()));

  TmdbMovieDetails details = const TmdbMovieDetails(id: 0, title: '');
  TmdbCollectionDetails collection = const TmdbCollectionDetails(
    id: 0,
    name: '',
  );
  bool failDetails = false;
  bool failCollection = false;
  int detailCalls = 0;
  int collectionCalls = 0;

  @override
  Future<TmdbMovieDetails> getMovieDetails(int tmdbId) async {
    detailCalls += 1;
    if (failDetails) throw Exception('details down');
    return details;
  }

  @override
  Future<TmdbCollectionDetails> getCollection(int collectionId) async {
    collectionCalls += 1;
    if (failCollection) throw Exception('collection down');
    return collection;
  }
}

class _Offline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}
