import '../../../shared/models/collection_status.dart';
import '../../../shared/models/collection_with_entries.dart';

class MovieCollectionPart {
  const MovieCollectionPart({
    required this.tmdbMovieId,
    required this.title,
    this.originalTitle,
    this.year,
    this.posterPath,
    this.releaseDate,
    this.status,
    this.localMovieId,
    required this.isCurrent,
  });

  final int tmdbMovieId;
  final String title;
  final String? originalTitle;
  final int? year;
  final String? posterPath;
  final DateTime? releaseDate;
  final CollectionStatus? status;
  final int? localMovieId;
  final bool isCurrent;

  bool get isOwned => status == CollectionStatus.owned;

  String get ownershipLabel => switch (status) {
    CollectionStatus.owned => 'Gekauft',
    CollectionStatus.wishlist => 'Wunschliste',
    CollectionStatus.open => 'Offen',
    null => 'Fehlt',
  };
}

class MovieCollectionInfo {
  const MovieCollectionInfo({
    required this.localId,
    required this.tmdbCollectionId,
    required this.name,
    this.posterPath,
    this.backdropPath,
    required this.parts,
    required this.currentTmdbMovieId,
  });

  final int localId;
  final int tmdbCollectionId;
  final String name;
  final String? posterPath;
  final String? backdropPath;
  final List<MovieCollectionPart> parts;
  final int currentTmdbMovieId;

  int get totalCount => parts.length;

  int get ownedCount => parts.where((part) => part.isOwned).length;

  int get wishlistCount =>
      parts.where((part) => part.status == CollectionStatus.wishlist).length;

  int get openCount => parts.where((part) {
    return part.status == null || part.status == CollectionStatus.open;
  }).length;

  String get progressLabel => '$ownedCount von $totalCount gesammelt';

  MovieCollectionInfo withStatuses(Map<int, CollectionStatus> overrides) {
    if (overrides.isEmpty) return this;
    return MovieCollectionInfo(
      localId: localId,
      tmdbCollectionId: tmdbCollectionId,
      name: name,
      posterPath: posterPath,
      backdropPath: backdropPath,
      parts: [
        for (final part in parts)
          MovieCollectionPart(
            tmdbMovieId: part.tmdbMovieId,
            title: part.title,
            originalTitle: part.originalTitle,
            year: part.year,
            posterPath: part.posterPath,
            releaseDate: part.releaseDate,
            status: overrides[part.tmdbMovieId] ?? part.status,
            localMovieId: part.localMovieId,
            isCurrent: part.isCurrent,
          ),
      ],
      currentTmdbMovieId: currentTmdbMovieId,
    );
  }

  String? get bucketLabel {
    if (parts.isEmpty) return null;
    if (ownedCount == totalCount) return 'Filmreihe komplett';
    if (wishlistCount == 0) {
      if (openCount == 1) return '1 Film fehlt';
      if (openCount > 1) return '$openCount Filme fehlen';
      return null;
    }
    final bits = <String>[
      wishlistCount == 1 ? '1 Wunschliste' : '$wishlistCount Wunschliste',
      if (openCount == 1) '1 offen',
      if (openCount > 1) '$openCount offen',
    ];
    return bits.join(' · ');
  }

  factory MovieCollectionInfo.fromCollection(
    CollectionWithEntries collection, {
    required int currentTmdbMovieId,
  }) {
    final parts = [
      for (final entry in collection.entries)
        MovieCollectionPart(
          tmdbMovieId: entry.tmdbMovieId,
          title: entry.title,
          originalTitle: entry.originalTitle,
          year: entry.releaseDate?.year,
          posterPath: entry.posterPath,
          releaseDate: entry.releaseDate,
          status: entry.localMovie?.status,
          localMovieId: entry.localMovie?.id,
          isCurrent: entry.tmdbMovieId == currentTmdbMovieId,
        ),
    ]..sort(compareCollectionParts);
    return MovieCollectionInfo(
      localId: collection.id,
      tmdbCollectionId: collection.tmdbCollectionId ?? 0,
      name: collection.name,
      posterPath: collection.posterPath,
      backdropPath: collection.backdropPath,
      parts: parts,
      currentTmdbMovieId: currentTmdbMovieId,
    );
  }
}

int compareCollectionParts(MovieCollectionPart a, MovieCollectionPart b) {
  return compareReleaseDates(a.releaseDate, b.releaseDate, a.title, b.title);
}

int compareReleaseDates(
  DateTime? a,
  DateTime? b,
  String titleA,
  String titleB,
) {
  if (a == null && b == null) return titleA.compareTo(titleB);
  if (a == null) return 1;
  if (b == null) return -1;
  final byDate = a.compareTo(b);
  if (byDate != 0) return byDate;
  return titleA.compareTo(titleB);
}
