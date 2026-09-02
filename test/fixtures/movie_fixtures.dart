import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/collection_with_entries.dart';
import 'package:movie_shelf/shared/models/movie.dart';

Movie buildMovie({
  int id = 1,
  int? tmdbId = 100,
  String title = 'Ein Standalone-Film',
  CollectionStatus status = CollectionStatus.owned,
  int? tmdbCollectionId,
  List<String> genres = const ['Drama'],
  int? releaseYear = 2015,
}) {
  final now = DateTime(2024, 1, 1);
  return Movie(
    id: id,
    tmdbId: tmdbId,
    title: title,
    originalTitle: title,
    overview: 'Eine kurze Beschreibung des Films.',
    releaseDate: releaseYear == null ? null : DateTime(releaseYear, 5, 1),
    releaseYear: releaseYear,
    runtime: 118,
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    certification: '12',
    originalLanguage: 'en',
    tmdbCollectionId: tmdbCollectionId,
    status: status,
    genres: genres,
    createdAt: now,
    updatedAt: now,
    lastMetadataSyncAt: now,
  );
}

Movie ownedMovieFixture() => buildMovie(
  id: 1,
  tmdbId: 100,
  title: 'Gekaufter Film',
  status: CollectionStatus.owned,
);

Movie wishlistMovieFixture() => buildMovie(
  id: 2,
  tmdbId: 200,
  title: 'Wunschlisten-Film',
  status: CollectionStatus.wishlist,
);

Movie openMovieFixture() => buildMovie(
  id: 3,
  tmdbId: 300,
  title: 'Offener Film',
  status: CollectionStatus.open,
);

Movie standaloneMovieFixture() => buildMovie(
  id: 4,
  tmdbId: 400,
  title: 'Ein Film ohne Reihe',
  tmdbCollectionId: null,
);

Movie collectionMovieFixture() => buildMovie(
  id: 5,
  tmdbId: 500,
  title: 'Harry Potter und der Stein der Weisen',
  tmdbCollectionId: 999,
);

CollectionWithEntries incompleteCollectionFixture() {
  return CollectionWithEntries(
    id: 1,
    tmdbCollectionId: 999,
    name: 'Harry Potter Collection',
    overview: 'Die Harry-Potter-Filmreihe.',
    posterPath: '/hp-poster.jpg',
    entries: [
      CollectionEntry(
        tmdbMovieId: 500,
        title: 'Harry Potter und der Stein der Weisen',
        releaseDate: DateTime(2001, 11, 16),
        localMovie: collectionMovieFixture(),
      ),
      CollectionEntry(
        tmdbMovieId: 501,
        title: 'Harry Potter und die Kammer des Schreckens',
        releaseDate: DateTime(2002, 11, 15),
        localMovie: buildMovie(
          id: 6,
          tmdbId: 501,
          tmdbCollectionId: 999,
          status: CollectionStatus.wishlist,
        ),
      ),
      CollectionEntry(
        tmdbMovieId: 502,
        title: 'Harry Potter und der Gefangene von Askaban',
        releaseDate: DateTime(2004, 6, 3),
      ),
      CollectionEntry(
        tmdbMovieId: 503,
        title: 'Harry Potter und der Feuerkelch',
        releaseDate: DateTime(2005, 11, 18),
      ),
    ],
  );
}
