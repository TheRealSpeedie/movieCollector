import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/collections/domain/movie_collection_info.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/collection_with_entries.dart';

import '../../fixtures/movie_fixtures.dart';

void main() {
  CollectionEntry part({
    required int id,
    required String title,
    DateTime? releaseDate,
    CollectionStatus? status,
    int? localId,
  }) {
    return CollectionEntry(
      tmdbMovieId: id,
      title: title,
      originalTitle: title,
      releaseDate: releaseDate,
      localMovie: status == null
          ? null
          : buildMovie(id: localId ?? id, tmdbId: id, status: status),
    );
  }

  MovieCollectionInfo series({
    required int currentId,
    required List<CollectionEntry> entries,
  }) {
    return MovieCollectionInfo.fromCollection(
      CollectionWithEntries(
        id: 7,
        tmdbCollectionId: 295,
        name: 'Pirates of the Caribbean',
        entries: entries,
      ),
      currentTmdbMovieId: currentId,
    );
  }

  List<CollectionEntry> pirates({CollectionStatus? currentStatus}) {
    return [
      part(
        id: 1,
        title: 'The Curse of the Black Pearl',
        releaseDate: DateTime(2003, 7, 9),
      ),
      part(
        id: 2,
        title: "Dead Man's Chest",
        releaseDate: DateTime(2006, 7, 7),
      ),
      part(
        id: 3,
        title: "At World's End",
        releaseDate: DateTime(2007, 5, 19),
        status: currentStatus,
        localId: currentStatus == null ? null : 13,
      ),
      part(
        id: 4,
        title: 'On Stranger Tides',
        releaseDate: DateTime(2011, 5, 20),
      ),
      part(
        id: 5,
        title: 'Dead Men Tell No Tales',
        releaseDate: DateTime(2017, 5, 26),
      ),
    ];
  }

  test('sorts parts by release date and leaves undated parts last', () {
    final info = series(
      currentId: 3,
      entries: [
        part(id: 5, title: 'Dead Men Tell No Tales', releaseDate: DateTime(2017)),
        part(id: 1, title: 'The Curse of the Black Pearl', releaseDate: DateTime(2003)),
        part(id: 4, title: 'On Stranger Tides'),
        part(id: 2, title: "Dead Man's Chest", releaseDate: DateTime(2006)),
        part(id: 3, title: "At World's End", releaseDate: DateTime(2007)),
      ],
    );
    expect(info.parts.map((part) => part.title), [
      'The Curse of the Black Pearl',
      "Dead Man's Chest",
      "At World's End",
      'Dead Men Tell No Tales',
      'On Stranger Tides',
    ]);
  });

  test('a scanned movie still counts as missing until it is owned', () {
    final scanned = series(currentId: 3, entries: pirates());
    final current = scanned.parts.singleWhere((part) => part.isCurrent);

    expect(current.title, "At World's End");
    expect(current.status, isNull);
    expect(current.isCurrent, isTrue);
    expect(current.ownershipLabel, 'Fehlt');
    expect(scanned.ownedCount, 0);
    expect(scanned.wishlistCount, 0);
    expect(scanned.openCount, 5);
    expect(scanned.progressLabel, '0 von 5 gesammelt');
    expect(scanned.bucketLabel, '5 Filme fehlen');

    final owned = series(
      currentId: 3,
      entries: pirates(currentStatus: CollectionStatus.owned),
    );
    final stillCurrent = owned.parts.singleWhere((part) => part.isCurrent);
    expect(stillCurrent.isCurrent, isTrue);
    expect(stillCurrent.ownershipLabel, 'Gekauft');
    expect(owned.ownedCount, 1);
    expect(owned.openCount, 4);
    expect(owned.progressLabel, '1 von 5 gesammelt');
    expect(owned.bucketLabel, '4 Filme fehlen');
  });

  test('the scanned flag does not change ownership buckets', () {
    final entries = pirates();
    final highlighted = series(currentId: 3, entries: entries);
    final other = series(currentId: 99, entries: entries);

    expect(highlighted.ownedCount, other.ownedCount);
    expect(highlighted.wishlistCount, other.wishlistCount);
    expect(highlighted.openCount, other.openCount);
    expect(highlighted.parts.singleWhere((part) => part.tmdbMovieId == 3).isCurrent, isTrue);
    expect(other.parts.every((part) => !part.isCurrent), isTrue);
  });

  test('owned, wishlist, and open are separate buckets', () {
    final info = series(
      currentId: 3,
      entries: [
        part(
          id: 1,
          title: 'Eins',
          releaseDate: DateTime(2001),
          status: CollectionStatus.owned,
        ),
        part(
          id: 2,
          title: 'Zwei',
          releaseDate: DateTime(2002),
          status: CollectionStatus.owned,
        ),
        part(
          id: 3,
          title: 'Drei',
          releaseDate: DateTime(2003),
          status: CollectionStatus.owned,
        ),
        part(
          id: 4,
          title: 'Vier',
          releaseDate: DateTime(2004),
          status: CollectionStatus.wishlist,
        ),
        part(
          id: 5,
          title: 'Fünf',
          releaseDate: DateTime(2005),
          status: CollectionStatus.open,
        ),
      ],
    );

    expect(info.ownedCount, 3);
    expect(info.wishlistCount, 1);
    expect(info.openCount, 1);
    expect(info.totalCount, 5);
    expect(info.progressLabel, '3 von 5 gesammelt');
    expect(info.bucketLabel, '1 Wunschliste · 1 offen');
  });

  test('wishlist does not count as collected', () {
    final info = series(
      currentId: 1,
      entries: [
        part(
          id: 1,
          title: 'Eins',
          releaseDate: DateTime(2001),
          status: CollectionStatus.wishlist,
        ),
      ],
    );
    expect(info.ownedCount, 0);
    expect(info.wishlistCount, 1);
    expect(info.openCount, 0);
    expect(info.progressLabel, '0 von 1 gesammelt');
    expect(info.bucketLabel, '1 Wunschliste');
  });

  test('a complete collection says the series is complete', () {
    final info = series(
      currentId: 2,
      entries: [
        part(
          id: 1,
          title: 'Eins',
          releaseDate: DateTime(2001),
          status: CollectionStatus.owned,
        ),
        part(
          id: 2,
          title: 'Zwei',
          releaseDate: DateTime(2002),
          status: CollectionStatus.owned,
        ),
      ],
    );
    expect(info.bucketLabel, 'Filmreihe komplett');
    expect(info.progressLabel, '2 von 2 gesammelt');
  });
}
