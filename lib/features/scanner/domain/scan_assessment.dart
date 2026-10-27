import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/media_format.dart';

/// What a scan means for the collection. Several can apply at once.
enum ScanVerdict {
  alreadyOwnedExact,
  otherEditionOwned,
  upgrade,
  wishlistMatch,
  collectionGap,
  missingSeason,
  digitalDuplicate,
  newDiscovery,
}

/// Whether the scan identified the exact edition (its barcode is known) or
/// only a probable title.
enum MatchConfidence { exact, probable }

class ScanInsight {
  const ScanInsight(this.verdict, this.message);

  final ScanVerdict verdict;
  final String message;

  /// Good news for the collector: something worth buying.
  bool get isOpportunity => const {
    ScanVerdict.upgrade,
    ScanVerdict.wishlistMatch,
    ScanVerdict.collectionGap,
    ScanVerdict.missingSeason,
  }.contains(verdict);
}

class ScanAssessment {
  const ScanAssessment({
    required this.confidence,
    required this.insights,
    this.maxPrice,
  });

  final MatchConfidence confidence;
  final List<ScanInsight> insights;

  /// The price limit the user set on the wishlist, if any.
  final double? maxPrice;

  ScanVerdict get primary => insights.first.verdict;
}

/// Compares a scan with the local collection. Works fully offline.
class ScanAssessor {
  ScanAssessor(this._db);

  final AppDatabase _db;

  /// A scan whose barcode resolved to a known edition.
  Future<ScanAssessment> forEdition(
    int editionId, {
    Set<int> digitalTmdbIds = const {},
  }) async {
    final edition = await (_db.select(
      _db.physicalEditions,
    )..where((t) => t.id.equals(editionId))).getSingle();
    final format = MediaFormat.fromName(edition.format);
    final movieIds = [
      for (final link in await (_db.select(
        _db.physicalEditionMovies,
      )..where((t) => t.editionId.equals(editionId))).get())
        link.movieId,
    ];
    final seasonIds = [
      for (final link in await (_db.select(
        _db.physicalEditionTvSeasons,
      )..where((t) => t.editionId.equals(editionId))).get())
        link.seasonId,
    ];
    final ownedHere = await (_db.select(
      _db.ownedCopies,
    )..where((t) => t.editionId.equals(editionId))).get();

    final insights = <ScanInsight>[];
    double? maxPrice;
    if (ownedHere.isNotEmpty) {
      insights.add(
        ScanInsight(
          ScanVerdict.alreadyOwnedExact,
          'Du hast genau diese ${_formatName(format)} bereits.',
        ),
      );
    } else {
      for (final movieId in movieIds) {
        final movie = await (_db.select(
          _db.movies,
        )..where((t) => t.id.equals(movieId))).getSingle();
        final result = await _movieInsights(
          movie: movie,
          scannedFormat: format,
          scannedEditionUuid: edition.uuid,
          digitalTmdbIds: digitalTmdbIds,
          inBundle: movieIds.length > 1,
        );
        insights.addAll(result.insights);
        maxPrice ??= result.maxPrice;
      }
      if (seasonIds.isNotEmpty) {
        insights.addAll(await _seasonInsights(seasonIds));
      }
    }
    return ScanAssessment(
      confidence: MatchConfidence.exact,
      insights: _ordered(insights),
      maxPrice: maxPrice,
    );
  }

  /// A scan that matched a title, either one in the collection or a
  /// candidate from TMDB ([tmdbCollectionId] for franchise gaps).
  Future<ScanAssessment> forTitle({
    required int tmdbId,
    int? tmdbCollectionId,
    String? scannedFormat,
    Set<int> digitalTmdbIds = const {},
    MatchConfidence confidence = MatchConfidence.probable,
  }) async {
    final movie = await (_db.select(
      _db.movies,
    )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();
    final format = MediaFormat.parse(scannedFormat);
    if (movie == null) {
      final insights = <ScanInsight>[
        if (tmdbCollectionId != null)
          ...await _collectionGap(tmdbCollectionId, tmdbId),
        if (digitalTmdbIds.contains(tmdbId))
          const ScanInsight(
            ScanVerdict.digitalDuplicate,
            'Du hast diesen Film digital auf deinem Server, aber noch nicht als Disc.',
          ),
      ];
      return ScanAssessment(
        confidence: confidence,
        insights: _ordered(insights),
      );
    }
    final result = await _movieInsights(
      movie: movie,
      scannedFormat: format,
      digitalTmdbIds: digitalTmdbIds,
    );
    return ScanAssessment(
      confidence: confidence,
      insights: _ordered(result.insights),
      maxPrice: result.maxPrice,
    );
  }

  Future<({List<ScanInsight> insights, double? maxPrice})> _movieInsights({
    required MovieRow movie,
    required MediaFormat scannedFormat,
    String? scannedEditionUuid,
    Set<int> digitalTmdbIds = const {},
    bool inBundle = false,
  }) async {
    final insights = <ScanInsight>[];
    final prefix = inBundle ? '${movie.title}: ' : '';
    final owned = await _ownedFormats(movie.id);
    if (owned.isNotEmpty) {
      final best = owned.reduce((a, b) => a.rank >= b.rank ? a : b);
      if (scannedFormat != MediaFormat.unknown &&
          best != MediaFormat.unknown &&
          scannedFormat.rank > best.rank) {
        insights.add(
          ScanInsight(
            ScanVerdict.upgrade,
            '${prefix}Du hast die ${_formatName(best)}. '
            'Das hier ist ein Upgrade auf ${scannedFormat.label}.',
          ),
        );
      } else {
        insights.add(
          ScanInsight(
            ScanVerdict.otherEditionOwned,
            best == MediaFormat.unknown
                ? '${prefix}Du besitzt diesen Film bereits in einer anderen Ausgabe.'
                : '${prefix}Du besitzt diesen Film bereits als ${best.label}.',
          ),
        );
      }
    }

    final state = await (_db.select(
      _db.personalStates,
    )..where((t) => t.movieId.equals(movie.id))).getSingleOrNull();
    if (state?.onWishlist ?? false) {
      final exact =
          scannedEditionUuid != null &&
          state!.preferredEditionUuid == scannedEditionUuid;
      insights.add(
        ScanInsight(
          ScanVerdict.wishlistMatch,
          exact
              ? '${prefix}Genau diese Edition steht auf deiner Wunschliste.'
              : '${prefix}Dieser Film steht auf deiner Wunschliste.',
        ),
      );
    }

    if (owned.isEmpty && movie.tmdbCollectionId != null) {
      insights.addAll(
        await _collectionGap(movie.tmdbCollectionId!, movie.tmdbId),
      );
    }
    if (owned.isEmpty &&
        movie.tmdbId != null &&
        digitalTmdbIds.contains(movie.tmdbId)) {
      insights.add(
        ScanInsight(
          ScanVerdict.digitalDuplicate,
          '${prefix}Du hast diesen Film digital auf deinem Server, aber noch nicht als Disc.',
        ),
      );
    }
    return (insights: insights, maxPrice: state?.maxPrice);
  }

  Future<List<MediaFormat>> _ownedFormats(int movieId) async {
    final rows = await _db
        .customSelect(
          'SELECT DISTINCT e.format FROM owned_copies c '
          'JOIN physical_editions e ON e.id = c.edition_id '
          'JOIN physical_edition_movies em ON em.edition_id = e.id '
          'WHERE em.movie_id = ?',
          variables: [Variable.withInt(movieId)],
        )
        .get();
    return [
      for (final r in rows) MediaFormat.fromName(r.read<String>('format')),
    ];
  }

  /// "Du hast Teil 1 und 3. Das vervollständigt deine Reihe."
  Future<List<ScanInsight>> _collectionGap(
    int tmdbCollectionId,
    int? tmdbId,
  ) async {
    final collection =
        await (_db.select(_db.collections)
              ..where((t) => t.tmdbCollectionId.equals(tmdbCollectionId)))
            .getSingleOrNull();
    if (collection == null) return const [];
    final parts =
        await (_db.select(_db.collectionMovies)
              ..where((t) => t.collectionId.equals(collection.id))
              ..orderBy([(t) => OrderingTerm.asc(t.releaseDate)]))
            .get();
    if (parts.length < 2) return const [];
    final ownedTmdb = {
      for (final m
          in await (_db.select(_db.movies)..where(
                (t) =>
                    t.tmdbId.isIn([for (final p in parts) p.tmdbMovieId]) &
                    t.userStatus.equals('owned'),
              ))
              .get())
        m.tmdbId!,
    };
    if (ownedTmdb.isEmpty || ownedTmdb.contains(tmdbId)) return const [];
    final ownedNumbers = [
      for (var i = 0; i < parts.length; i++)
        if (ownedTmdb.contains(parts[i].tmdbMovieId)) i + 1,
    ];
    final missingAfter = parts
        .where(
          (p) => !ownedTmdb.contains(p.tmdbMovieId) && p.tmdbMovieId != tmdbId,
        )
        .length;
    return [
      ScanInsight(
        ScanVerdict.collectionGap,
        'Du hast Teil ${_list(ownedNumbers)} von „${collection.name}“. '
        '${missingAfter == 0 ? 'Das vervollständigt deine Reihe.' : 'Danach fehlen noch $missingAfter.'}',
      ),
    ];
  }

  /// "Du hast Staffel 1, 2 und 4. Das hier ist die fehlende Staffel 3."
  Future<List<ScanInsight>> _seasonInsights(List<int> seasonIds) async {
    final scanned = await (_db.select(
      _db.tvSeasonsTable,
    )..where((t) => t.id.isIn(seasonIds))).get();
    if (scanned.isEmpty) return const [];
    final all = await (_db.select(
      _db.tvSeasonsTable,
    )..where((t) => t.seriesId.equals(scanned.first.seriesId))).get();
    final owned = [
      for (final s in all)
        if (s.userStatus?.name == 'owned' && s.seasonNumber > 0) s.seasonNumber,
    ]..sort();
    final missing = [
      for (final s in scanned)
        if (s.userStatus?.name != 'owned' && s.seasonNumber > 0) s.seasonNumber,
    ]..sort();
    if (missing.isEmpty) {
      return const [
        ScanInsight(
          ScanVerdict.otherEditionOwned,
          'Du besitzt diese Staffeln bereits in einer anderen Ausgabe.',
        ),
      ];
    }
    if (owned.isEmpty) return const [];
    return [
      ScanInsight(
        ScanVerdict.missingSeason,
        'Du hast Staffel ${_list(owned)}. Das hier ist die fehlende '
        'Staffel ${_list(missing)}.',
      ),
    ];
  }

  static List<ScanInsight> _ordered(List<ScanInsight> insights) {
    if (insights.isEmpty) {
      return const [
        ScanInsight(
          ScanVerdict.newDiscovery,
          'Dieser Titel ist noch nicht in deiner Sammlung.',
        ),
      ];
    }
    return [...insights]
      ..sort((a, b) => a.verdict.index.compareTo(b.verdict.index));
  }

  static String _formatName(MediaFormat format) =>
      format == MediaFormat.unknown ? 'Ausgabe' : format.label;

  static String _list(List<int> numbers) => numbers.length == 1
      ? '${numbers.single}'
      : '${numbers.take(numbers.length - 1).join(', ')} und ${numbers.last}';
}
