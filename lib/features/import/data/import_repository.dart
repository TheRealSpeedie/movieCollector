import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/matching/media_title_parser.dart';
import '../../../core/matching/movie_matcher.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/utils/debug_log.dart';
import '../../../core/utils/title_normalizer.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/match_candidate.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/physical_edition_kind.dart';
import '../../collections/data/collection_repository.dart';
import '../../editions/data/physical_edition_repository.dart';
import '../../movies/data/movie_repository.dart';
import '../../tv/data/tv_repository.dart';
import '../domain/import_models.dart';

class ImportRepository {
  ImportRepository(
    this._tmdb,
    this._movieRepository, {
    AppDatabase? database,
    CollectionRepository? collectionRepository,
    TvRepository? tvRepository,
    PhysicalEditionRepository? editionRepository,
    MovieMatcher matcher = const MovieMatcher(),
    MediaTitleParser mediaParser = const MediaTitleParser(),
    Future<void> Function(Duration duration) wait = _defaultWait,
  }) : _db = database,
       _collectionRepository = collectionRepository,
       _tvRepository = tvRepository,
       _editionRepository = editionRepository,
       _matcher = matcher,
       _mediaParser = mediaParser,
       _wait = wait;

  final TmdbApiClient _tmdb;
  final MovieRepository _movieRepository;
  final AppDatabase? _db;
  final CollectionRepository? _collectionRepository;
  final TvRepository? _tvRepository;
  final PhysicalEditionRepository? _editionRepository;
  final MovieMatcher _matcher;
  final MediaTitleParser _mediaParser;
  final Future<void> Function(Duration duration) _wait;

  static Future<void> _defaultWait(Duration duration) =>
      Future<void>.delayed(duration);

  Future<List<ImportRow>> buildRows(List<String> rawLines) async {
    final rows = <ImportRow>[];
    for (var i = 0; i < rawLines.length; i++) {
      rows.add(await _buildRow(i, rawLines[i]));
    }
    return rows;
  }

  Future<ImportRow> _buildRow(int index, String rawLine) async {
    final parsed = _mediaParser.parse(rawLine);
    final title = parsed.cleanedTitle.isNotEmpty
        ? parsed.cleanedTitle
        : TitleNormalizer.stripListArtifacts(rawLine);
    final year = parsed.parsedYear ?? TitleNormalizer.extractYear(rawLine);

    if (parsed.isTv) {
      return _buildTvRow(
        index: index,
        rawLine: rawLine,
        title: title,
        year: year,
        parsed: parsed,
      );
    }
    if (parsed.isMovieBox) {
      return _buildMovieBoxRow(
        index: index,
        rawLine: rawLine,
        title: title,
        year: year,
        parsed: parsed,
      );
    }
    return _buildMovieRow(
      index: index,
      rawLine: rawLine,
      title: title,
      year: year,
      parsed: parsed,
    );
  }

  Future<ImportRow> _buildMovieRow({
    required int index,
    required String rawLine,
    required String title,
    required int? year,
    required MediaParseResult parsed,
  }) async {
    List<TmdbSearchResult> results;
    try {
      results = await _tmdb.searchMovies(title);
    } catch (_) {
      results = const [];
    }

    if (results.isEmpty) {
      return ImportRow(
        index: index,
        rawLine: rawLine,
        parsedTitle: title,
        parsedYear: year,
        status: ImportRowStatus.notFound,
        kindHint: parsed.kind,
      );
    }

    final ranked = _matcher.rank(title, results, year: year);
    final best = ranked.first;
    final second = ranked.length > 1 ? ranked[1] : null;

    final existingLocal = await _movieRepository.getMovieByTmdbId(
      best.result.id,
    );
    if (existingLocal != null) {
      return ImportRow(
        index: index,
        rawLine: rawLine,
        parsedTitle: title,
        parsedYear: year,
        status: ImportRowStatus.duplicate,
        kindHint: parsed.kind,
        candidates: ranked,
        selectedCandidate: best.result,
        target: ImportTarget.singleMovie(movie: best.result),
        existingLocalMovie: existingLocal,
      );
    }

    final isConfident =
        best.confidence >= AppConstants.defaultMatchConfidenceThreshold &&
        (second == null || best.confidence - second.confidence >= 0.1);

    if (isConfident) {
      return ImportRow(
        index: index,
        rawLine: rawLine,
        parsedTitle: title,
        parsedYear: year,
        status: ImportRowStatus.matchedAutomatically,
        kindHint: parsed.kind,
        candidates: ranked,
        selectedCandidate: best.result,
        target: ImportTarget.singleMovie(movie: best.result),
      );
    }

    if (best.confidence >= AppConstants.minAcceptableConfidence) {
      return ImportRow(
        index: index,
        rawLine: rawLine,
        parsedTitle: title,
        parsedYear: year,
        status: ImportRowStatus.ambiguous,
        kindHint: parsed.kind,
        candidates: ranked,
      );
    }

    return ImportRow(
      index: index,
      rawLine: rawLine,
      parsedTitle: title,
      parsedYear: year,
      status: ImportRowStatus.notFound,
      kindHint: parsed.kind,
      candidates: ranked,
    );
  }

  Future<ImportRow> _buildMovieBoxRow({
    required int index,
    required String rawLine,
    required String title,
    required int? year,
    required MediaParseResult parsed,
  }) async {
    try {
      final collections = await _tmdb.searchCollections(title);
      if (collections.isNotEmpty) {
        final best = collections.first;
        final details = await _tmdb.getCollection(best.id);
        if (details.parts.isNotEmpty) {
          return ImportRow(
            index: index,
            rawLine: rawLine,
            parsedTitle: title,
            parsedYear: year,
            status: ImportRowStatus.ambiguous,
            kindHint: parsed.kind,
            target: ImportTarget.movieBundle(
              collection: details,
              selectedTmdbIds: details.parts.map((p) => p.id).toList(),
            ),
          );
        }
      }
    } catch (_) {}
    return _buildMovieRow(
      index: index,
      rawLine: rawLine,
      title: title,
      year: year,
      parsed: parsed,
    );
  }

  Future<ImportRow> _buildTvRow({
    required int index,
    required String rawLine,
    required String title,
    required int? year,
    required MediaParseResult parsed,
  }) async {
    List<TmdbTvSearchResult> results;
    try {
      results = await _tmdb.searchTv(title);
    } catch (_) {
      results = const [];
    }
    if (results.isEmpty) {
      if (parsed.kind == MediaKindHint.completeTvSeries) {
        return _buildMovieBoxRow(
          index: index,
          rawLine: rawLine,
          title: title,
          year: year,
          parsed: parsed,
        );
      }
      return ImportRow(
        index: index,
        rawLine: rawLine,
        parsedTitle: title,
        parsedYear: year,
        status: ImportRowStatus.notFound,
        kindHint: parsed.kind,
        parsedSeasonNumbers: parsed.seasonNumbers,
      );
    }

    final ranked = _matcher.rankTv(title, results, year: year);
    final best = ranked.first;
    final second = ranked.length > 1 ? ranked[1] : null;
    final isConfident =
        best.confidence >= AppConstants.defaultMatchConfidenceThreshold &&
        (second == null || best.confidence - second.confidence >= 0.1);

    TmdbTvDetails? details;
    if (isConfident ||
        best.confidence >= AppConstants.minAcceptableConfidence) {
      try {
        details = await _tmdb.getTvDetails(best.result.id);
      } catch (_) {}
    }

    if (details != null && isConfident) {
      return _tvRowFromDetails(
        index: index,
        rawLine: rawLine,
        title: title,
        year: year,
        parsed: parsed,
        series: best.result,
        details: details,
        tvCandidates: ranked,
        automatic: parsed.kind == MediaKindHint.singleTvSeason,
      );
    }

    return ImportRow(
      index: index,
      rawLine: rawLine,
      parsedTitle: title,
      parsedYear: year,
      status: ImportRowStatus.ambiguous,
      kindHint: parsed.kind,
      parsedSeasonNumbers: parsed.seasonNumbers,
      tvCandidates: ranked,
    );
  }

  ImportRow _tvRowFromDetails({
    required int index,
    required String rawLine,
    required String title,
    required int? year,
    required MediaParseResult parsed,
    required TmdbTvSearchResult series,
    required TmdbTvDetails details,
    required List<TvMatchCandidate> tvCandidates,
    required bool automatic,
  }) {
    final regular = details.regularSeasons.map((s) => s.seasonNumber).toList();
    late ImportTarget target;
    if (parsed.kind == MediaKindHint.completeTvSeries) {
      target = ImportTarget.completeTvSeries(
        series: series,
        details: details,
        selectedSeasonNumbers: regular,
      );
    } else if (parsed.kind == MediaKindHint.multiSeasonTvBox) {
      final selected = parsed.seasonNumbers
          .where((n) => n > 0 && regular.contains(n))
          .toList();
      target = ImportTarget.tvSeasonBundle(
        series: series,
        details: details,
        selectedSeasonNumbers: selected.isEmpty ? regular : selected,
      );
    } else {
      final number = parsed.seasonNumbers.isNotEmpty
          ? parsed.seasonNumbers.first
          : (regular.isNotEmpty ? regular.first : 1);
      target = ImportTarget.singleTvSeason(
        series: series,
        details: details,
        seasonNumber: number,
      );
    }

    return ImportRow(
      index: index,
      rawLine: rawLine,
      parsedTitle: title,
      parsedYear: year,
      status: automatic
          ? ImportRowStatus.matchedAutomatically
          : ImportRowStatus.ambiguous,
      kindHint: parsed.kind,
      parsedSeasonNumbers: parsed.seasonNumbers,
      tvCandidates: tvCandidates,
      target: target,
    );
  }

  Future<ImportCommitReport> commit(
    List<ImportRow> rows,
    CollectionStatus defaultStatus, {
    void Function(ImportSaveProgress progress)? onProgress,
    Set<int>? onlyIndexes,
  }) async {
    final pending = [
      for (final row in rows)
        if (onlyIndexes == null || onlyIndexes.contains(row.index)) row,
    ];
    final outcomes = <ImportRowOutcome>[];
    final collectionIds = <int>{};
    var moviesAdded = 0;
    var seasonsAdded = 0;
    var updated = 0;
    var alreadyExisted = 0;
    var skipped = 0;
    var failed = 0;

    void emit({String? currentTitle, int processed = 0}) {
      onProgress?.call(
        ImportSaveProgress(
          processed: processed,
          total: pending.length,
          currentTitle: currentTitle,
          moviesAdded: moviesAdded,
          seasonsAdded: seasonsAdded,
          updated: updated,
          alreadyExisted: alreadyExisted,
          skipped: skipped,
          failed: failed,
        ),
      );
    }

    emit();

    for (var i = 0; i < pending.length; i++) {
      final row = pending[i];
      emit(currentTitle: row.rawLine, processed: i);
      await _wait(Duration.zero);

      if (row.status == ImportRowStatus.skipped ||
          row.target is ImportTargetSkipped) {
        skipped++;
        outcomes.add(
          ImportRowOutcome(
            rowIndex: row.index,
            sourceText: row.rawLine,
            kind: ImportRowOutcomeKind.skipped,
            targetType: 'Skipped',
          ),
        );
        emit(currentTitle: row.rawLine, processed: i + 1);
        continue;
      }

      final target =
          row.target ??
          (row.selectedCandidate == null
              ? null
              : ImportTarget.singleMovie(movie: row.selectedCandidate!));
      if (target == null) {
        skipped++;
        outcomes.add(
          ImportRowOutcome(
            rowIndex: row.index,
            sourceText: row.rawLine,
            kind: ImportRowOutcomeKind.skipped,
          ),
        );
        emit(currentTitle: row.rawLine, processed: i + 1);
        continue;
      }

      try {
        final result = await _commitTarget(target, defaultStatus, row.rawLine);
        collectionIds.addAll(result.collectionIds);
        moviesAdded += result.moviesAdded;
        seasonsAdded += result.seasonsAdded;
        updated += result.moviesUpdated + result.seasonsUpdated;
        alreadyExisted +=
            result.moviesAlreadyExisting + result.seasonsAlreadyExisting;
        outcomes.add(
          ImportRowOutcome(
            rowIndex: row.index,
            sourceText: row.rawLine,
            kind: _sourceKind(result),
            targetType: target.debugTypeName,
            moviesAdded: result.moviesAdded,
            moviesUpdated: result.moviesUpdated,
            moviesAlreadyExisting: result.moviesAlreadyExisting,
            seasonsAdded: result.seasonsAdded,
            seasonsUpdated: result.seasonsUpdated,
            seasonsAlreadyExisting: result.seasonsAlreadyExisting,
          ),
        );
      } on RateLimitException catch (error, stack) {
        final failure = _failureFor(row, target, error, stack);
        failed++;
        outcomes.add(
          ImportRowOutcome(
            rowIndex: row.index,
            sourceText: row.rawLine,
            kind: ImportRowOutcomeKind.failed,
            targetType: target.debugTypeName,
            failure: failure,
          ),
        );
        for (var j = i + 1; j < pending.length; j++) {
          final remaining = pending[j];
          if (remaining.status == ImportRowStatus.skipped ||
              remaining.target is ImportTargetSkipped) {
            skipped++;
            outcomes.add(
              ImportRowOutcome(
                rowIndex: remaining.index,
                sourceText: remaining.rawLine,
                kind: ImportRowOutcomeKind.skipped,
                targetType: 'Skipped',
              ),
            );
            continue;
          }
          if (remaining.target == null && remaining.selectedCandidate == null) {
            skipped++;
            outcomes.add(
              ImportRowOutcome(
                rowIndex: remaining.index,
                sourceText: remaining.rawLine,
                kind: ImportRowOutcomeKind.skipped,
              ),
            );
            continue;
          }
          failed++;
          debugLog(
            'Import: "${remaining.parsedTitle}" not saved after TMDB rate limit.',
          );
          outcomes.add(
            ImportRowOutcome(
              rowIndex: remaining.index,
              sourceText: remaining.rawLine,
              kind: ImportRowOutcomeKind.failed,
              targetType: remaining.target?.debugTypeName,
              failure: importSaveFailureFrom(
                error,
                sourceText: remaining.rawLine,
                targetType: remaining.target?.debugTypeName ?? 'Unknown',
              ),
            ),
          );
        }
        emit(currentTitle: row.rawLine, processed: pending.length);
        break;
      } catch (error, stack) {
        final failure = _failureFor(row, target, error, stack);
        failed++;
        outcomes.add(
          ImportRowOutcome(
            rowIndex: row.index,
            sourceText: row.rawLine,
            kind: ImportRowOutcomeKind.failed,
            targetType: target.debugTypeName,
            failure: failure,
          ),
        );
      }
      emit(currentTitle: row.rawLine, processed: i + 1);
    }

    await _syncCollections(collectionIds);
    return ImportCommitReport.fromOutcomes(outcomes);
  }

  ImportRowOutcomeKind _sourceKind(_SourcePersistResult result) {
    if (result.moviesAdded + result.seasonsAdded > 0) {
      return ImportRowOutcomeKind.added;
    }
    if (result.moviesUpdated + result.seasonsUpdated > 0) {
      return ImportRowOutcomeKind.updated;
    }
    if (result.moviesAlreadyExisting + result.seasonsAlreadyExisting > 0) {
      return ImportRowOutcomeKind.alreadyExists;
    }
    return ImportRowOutcomeKind.skipped;
  }

  ImportSaveFailure _failureFor(
    ImportRow row,
    ImportTarget target,
    Object error,
    StackTrace stack,
  ) {
    final failure = importSaveFailureFrom(
      error,
      sourceText: row.rawLine,
      targetType: target.debugTypeName,
    );
    debugLog(
      'Import save failed\n'
      'Source: "${row.rawLine}"\n'
      'Target: ${target.debugTypeName}\n'
      'TMDB ID: ${target.debugTmdbId ?? '–'}\n'
      'Exception: ${failure.developerMessage}\n'
      'StackTrace: $stack',
    );
    return failure;
  }

  Future<_SourcePersistResult> _commitTarget(
    ImportTarget target,
    CollectionStatus status,
    String productTitle,
  ) async {
    return switch (target) {
      ImportTargetSkipped() => const _SourcePersistResult(),
      ImportTargetSingleMovie(:final movie) => await _commitMovies(
        [movie.id],
        status,
        productTitle,
        PhysicalEditionKind.singleMovie,
      ),
      ImportTargetMovieBundle(:final collection, :final selectedTmdbIds) =>
        await _commitMovies(
          selectedTmdbIds,
          status,
          productTitle,
          PhysicalEditionKind.movieBundle,
          tmdbCollectionId: collection.id,
        ),
      ImportTargetSingleTvSeason(:final details, :final seasonNumber) =>
        await _commitSeasons(
          details,
          [seasonNumber],
          status,
          productTitle,
          PhysicalEditionKind.singleTvSeason,
        ),
      ImportTargetTvSeasonBundle(
        :final details,
        :final selectedSeasonNumbers,
      ) =>
        await _commitSeasons(
          details,
          selectedSeasonNumbers,
          status,
          productTitle,
          PhysicalEditionKind.tvSeasonBundle,
        ),
      ImportTargetCompleteTvSeries(
        :final details,
        :final selectedSeasonNumbers,
      ) =>
        await _commitSeasons(
          details,
          selectedSeasonNumbers,
          status,
          productTitle,
          PhysicalEditionKind.completeTvSeries,
        ),
    };
  }

  Future<_SourcePersistResult> _commitMovies(
    List<int> tmdbIds,
    CollectionStatus status,
    String productTitle,
    PhysicalEditionKind kind, {
    int? tmdbCollectionId,
  }) async {
    final uniqueIds = tmdbIds.toSet().toList();
    final detailsById = <int, TmdbMovieDetails>{};
    final existingById = <int, Movie>{};
    var fetched = 0;

    for (final tmdbId in uniqueIds) {
      final already = await _movieRepository.getMovieByTmdbId(tmdbId);
      if (already != null) {
        existingById[tmdbId] = already;
      } else {
        if (fetched > 0) {
          await _wait(const Duration(milliseconds: 250));
        }
        detailsById[tmdbId] = await _fetchMovieDetails(tmdbId, productTitle);
        fetched++;
      }
    }

    return _inSourceRowTransaction(() async {
      var moviesAdded = 0;
      var moviesUpdated = 0;
      var moviesAlreadyExisting = 0;
      final localIds = <int>[];
      final collectionIds = <int>{};
      if (tmdbCollectionId != null) collectionIds.add(tmdbCollectionId);

      for (final tmdbId in uniqueIds) {
        final details = detailsById[tmdbId];
        final MovieUpsertResult result;
        if (details != null) {
          result = await _movieRepository.upsertFromDetails(
            details,
            status: status,
            syncCollection: false,
          );
        } else {
          result = await _movieRepository.applyImportedStatus(
            existingById[tmdbId]!,
            status,
          );
        }
        localIds.add(result.movie.id);
        if (result.movie.tmdbCollectionId != null) {
          collectionIds.add(result.movie.tmdbCollectionId!);
        }
        switch (result.kind) {
          case MoviePersistKind.added:
            moviesAdded++;
          case MoviePersistKind.updated:
            moviesUpdated++;
          case MoviePersistKind.alreadyExists:
            moviesAlreadyExisting++;
        }
      }

      final createEdition =
          kind != PhysicalEditionKind.singleMovie || moviesAdded > 0;
      if (createEdition && localIds.isNotEmpty) {
        await _editionRepository?.createEdition(
          kind: kind,
          productTitle: productTitle,
          tmdbCollectionId: tmdbCollectionId,
          movieIds: localIds,
        );
      }

      return _SourcePersistResult(
        moviesAdded: moviesAdded,
        moviesUpdated: moviesUpdated,
        moviesAlreadyExisting: moviesAlreadyExisting,
        collectionIds: collectionIds,
      );
    });
  }

  Future<_SourcePersistResult> _commitSeasons(
    TmdbTvDetails details,
    List<int> seasonNumbers,
    CollectionStatus status,
    String productTitle,
    PhysicalEditionKind kind,
  ) async {
    final tv = _tvRepository;
    if (tv == null) {
      throw const UnknownAppException('TV-Import ist nicht verfügbar.');
    }
    final selected = seasonNumbers.toSet();
    final statuses = {for (final n in selected) n: status};

    return _inSourceRowTransaction(() async {
      final saved = await tv.upsertFromDetails(
        details,
        seasonStatuses: statuses,
      );
      final seasonIds = saved.saved.seasons
          .where((s) => selected.contains(s.seasonNumber))
          .map((s) => s.id)
          .toList();

      if (seasonIds.isNotEmpty) {
        await _editionRepository?.createEdition(
          kind: kind,
          productTitle: productTitle,
          tmdbTvSeriesId: details.id,
          seasonIds: seasonIds,
        );
      }

      return _SourcePersistResult(
        seasonsAdded: saved.seasonsAdded,
        seasonsUpdated: saved.seasonsUpdated,
        seasonsAlreadyExisting: saved.seasonsAlreadyExisting,
      );
    });
  }

  Future<TmdbMovieDetails> _fetchMovieDetails(int tmdbId, String title) async {
    try {
      return await _tmdb.getMovieDetails(tmdbId);
    } on RateLimitException catch (error) {
      final waitFor = error.retryAfter ?? const Duration(seconds: 5);
      debugLog(
        'Import: TMDB rate limit while saving "$title". '
        'Waiting ${waitFor.inSeconds}s, then retrying.',
      );
      await _wait(waitFor);
      return _tmdb.getMovieDetails(tmdbId);
    }
  }

  Future<T> _inSourceRowTransaction<T>(Future<T> Function() action) {
    final db = _db;
    if (db == null) return action();
    return db.transaction(action);
  }

  Future<void> _syncCollections(Set<int> collectionIds) async {
    final collections = _collectionRepository;
    if (collections == null) return;
    for (final id in collectionIds) {
      try {
        await collections.syncCollection(id);
      } catch (error, stack) {
        debugLog('Import: collection $id sync failed: $error');
        debugLog('$stack');
      }
    }
  }
}

class _SourcePersistResult {
  const _SourcePersistResult({
    this.moviesAdded = 0,
    this.moviesUpdated = 0,
    this.moviesAlreadyExisting = 0,
    this.seasonsAdded = 0,
    this.seasonsUpdated = 0,
    this.seasonsAlreadyExisting = 0,
    this.collectionIds = const {},
  });

  final int moviesAdded;
  final int moviesUpdated;
  final int moviesAlreadyExisting;
  final int seasonsAdded;
  final int seasonsUpdated;
  final int seasonsAlreadyExisting;
  final Set<int> collectionIds;
}
