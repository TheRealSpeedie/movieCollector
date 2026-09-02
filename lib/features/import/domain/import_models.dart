import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/matching/media_title_parser.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../shared/models/match_candidate.dart';
import '../../../shared/models/movie.dart';

part 'import_models.freezed.dart';

enum ImportRowStatus {
  matchedAutomatically,
  ambiguous,
  notFound,
  matchedManually,
  duplicate,
  skipped,
}

@freezed
sealed class ImportTarget with _$ImportTarget {
  const factory ImportTarget.singleMovie({required TmdbSearchResult movie}) =
      ImportTargetSingleMovie;

  const factory ImportTarget.movieBundle({
    required TmdbCollectionDetails collection,
    required List<int> selectedTmdbIds,
  }) = ImportTargetMovieBundle;

  const factory ImportTarget.singleTvSeason({
    required TmdbTvSearchResult series,
    required TmdbTvDetails details,
    required int seasonNumber,
  }) = ImportTargetSingleTvSeason;

  const factory ImportTarget.tvSeasonBundle({
    required TmdbTvSearchResult series,
    required TmdbTvDetails details,
    required List<int> selectedSeasonNumbers,
  }) = ImportTargetTvSeasonBundle;

  const factory ImportTarget.completeTvSeries({
    required TmdbTvSearchResult series,
    required TmdbTvDetails details,
    required List<int> selectedSeasonNumbers,
  }) = ImportTargetCompleteTvSeries;

  const factory ImportTarget.skipped() = ImportTargetSkipped;
}

@freezed
abstract class ImportRow with _$ImportRow {
  const factory ImportRow({
    required int index,
    required String rawLine,
    required String parsedTitle,
    int? parsedYear,
    required ImportRowStatus status,
    @Default(MediaKindHint.unknown) MediaKindHint kindHint,
    @Default(<int>[]) List<int> parsedSeasonNumbers,
    @Default(<MatchCandidate>[]) List<MatchCandidate> candidates,
    @Default(<TvMatchCandidate>[]) List<TvMatchCandidate> tvCandidates,
    TmdbSearchResult? selectedCandidate,
    ImportTarget? target,
    Movie? existingLocalMovie,
  }) = _ImportRow;
}

class ImportSummary {
  const ImportSummary({
    required this.totalLines,
    required this.matchedAutomatically,
    required this.matchedManually,
    required this.ambiguous,
    required this.notFound,
    required this.duplicates,
    required this.skipped,
  });

  final int totalLines;
  final int matchedAutomatically;
  final int matchedManually;
  final int ambiguous;
  final int notFound;
  final int duplicates;
  final int skipped;

  int get recognizedTotal => matchedAutomatically + matchedManually;
}

enum ImportSaveFailureCategory {
  duplicate,
  databaseConstraint,
  databaseMigration,
  invalidData,
  network,
  metadata,
  unknown,
}

enum ImportRowOutcomeKind { added, updated, alreadyExists, skipped, failed }

class ImportSaveFailure {
  const ImportSaveFailure({
    required this.sourceText,
    required this.targetType,
    required this.category,
    required this.developerMessage,
    required this.userMessage,
  });

  final String sourceText;
  final String targetType;
  final ImportSaveFailureCategory category;
  final String developerMessage;
  final String userMessage;

  String get title => sourceText;
  String get reason => userMessage;

  String get categoryLabel => switch (category) {
    ImportSaveFailureCategory.duplicate => 'Bereits vorhanden',
    ImportSaveFailureCategory.databaseConstraint => 'Datenbankfehler',
    ImportSaveFailureCategory.databaseMigration => 'Datenbankversion',
    ImportSaveFailureCategory.invalidData => 'Ungültige Daten',
    ImportSaveFailureCategory.network => 'Netzwerkfehler',
    ImportSaveFailureCategory.metadata => 'API-Daten unvollständig',
    ImportSaveFailureCategory.unknown => 'Unerwarteter Fehler',
  };

  String get detailMessage => switch (category) {
    ImportSaveFailureCategory.duplicate =>
      'Dieser Titel ist bereits in der Sammlung.',
    ImportSaveFailureCategory.databaseConstraint =>
      'Der Eintrag konnte aufgrund eines Datenbankkonflikts nicht gespeichert werden.',
    ImportSaveFailureCategory.databaseMigration =>
      'Die lokale Datenbank konnte nicht aktualisiert werden. Bitte starte die App neu.',
    ImportSaveFailureCategory.invalidData =>
      'Die gespeicherten Daten für diesen Titel sind unvollständig oder ungültig.',
    ImportSaveFailureCategory.network => userMessage,
    ImportSaveFailureCategory.metadata =>
      'Die Filmdaten von TMDB waren unvollständig oder konnten nicht geladen werden.',
    ImportSaveFailureCategory.unknown =>
      'Der Eintrag konnte nicht gespeichert werden.',
  };
}

typedef ImportFailure = ImportSaveFailure;

class ImportRowOutcome {
  const ImportRowOutcome({
    required this.rowIndex,
    required this.sourceText,
    required this.kind,
    this.targetType,
    this.moviesAdded = 0,
    this.moviesUpdated = 0,
    this.moviesAlreadyExisting = 0,
    this.seasonsAdded = 0,
    this.seasonsUpdated = 0,
    this.seasonsAlreadyExisting = 0,
    this.failure,
  });

  final int rowIndex;
  final String sourceText;
  final ImportRowOutcomeKind kind;
  final String? targetType;
  final int moviesAdded;
  final int moviesUpdated;
  final int moviesAlreadyExisting;
  final int seasonsAdded;
  final int seasonsUpdated;
  final int seasonsAlreadyExisting;
  final ImportSaveFailure? failure;

  bool get isSuccess => kind != ImportRowOutcomeKind.failed;
}

class ImportSaveProgress {
  const ImportSaveProgress({
    required this.processed,
    required this.total,
    this.currentTitle,
    this.moviesAdded = 0,
    this.seasonsAdded = 0,
    this.updated = 0,
    this.alreadyExisted = 0,
    this.skipped = 0,
    this.failed = 0,
  });

  final int processed;
  final int total;
  final String? currentTitle;
  final int moviesAdded;
  final int seasonsAdded;
  final int updated;
  final int alreadyExisted;
  final int skipped;
  final int failed;

  double get fraction => total == 0 ? 0 : processed / total;
}

class ImportCommitReport {
  const ImportCommitReport({
    required this.imported,
    required this.failed,
    required this.skipped,
    this.importedMovies = 0,
    this.importedSeasons = 0,
    this.moviesUpdated = 0,
    this.seasonsUpdated = 0,
    this.alreadyExisted = 0,
    this.failures = const [],
    this.outcomes = const [],
  });

  factory ImportCommitReport.fromOutcomes(List<ImportRowOutcome> outcomes) {
    var importedMovies = 0;
    var importedSeasons = 0;
    var moviesUpdated = 0;
    var seasonsUpdated = 0;
    var alreadyExisted = 0;
    var skipped = 0;
    var failed = 0;
    final failures = <ImportSaveFailure>[];
    for (final outcome in outcomes) {
      importedMovies += outcome.moviesAdded;
      importedSeasons += outcome.seasonsAdded;
      moviesUpdated += outcome.moviesUpdated;
      seasonsUpdated += outcome.seasonsUpdated;
      alreadyExisted +=
          outcome.moviesAlreadyExisting + outcome.seasonsAlreadyExisting;
      switch (outcome.kind) {
        case ImportRowOutcomeKind.skipped:
          skipped++;
        case ImportRowOutcomeKind.failed:
          failed++;
          if (outcome.failure != null) failures.add(outcome.failure!);
        case ImportRowOutcomeKind.added:
        case ImportRowOutcomeKind.updated:
        case ImportRowOutcomeKind.alreadyExists:
          break;
      }
    }
    return ImportCommitReport(
      imported: importedMovies + importedSeasons,
      importedMovies: importedMovies,
      importedSeasons: importedSeasons,
      moviesUpdated: moviesUpdated,
      seasonsUpdated: seasonsUpdated,
      failed: failed,
      skipped: skipped,
      alreadyExisted: alreadyExisted,
      failures: failures,
      outcomes: outcomes,
    );
  }

  final int imported;
  final int failed;
  final int skipped;
  final int importedMovies;
  final int importedSeasons;
  final int moviesUpdated;
  final int seasonsUpdated;
  final int alreadyExisted;
  final List<ImportSaveFailure> failures;
  final List<ImportRowOutcome> outcomes;

  int get processedSourceRows => outcomes.length;
  int get successfulSourceRows => outcomes.where((o) => o.isSuccess).length;
  int get failedSourceRows => failed;
  int get updated => moviesUpdated + seasonsUpdated;

  bool get isCompleteSuccess => failedSourceRows == 0;
  bool get isPartialSuccess => failedSourceRows > 0 && successfulSourceRows > 0;
  bool get hasRetryableFailures => failedSourceRows > 0;

  List<int> get failedRowIndexes => outcomes
      .where((o) => o.kind == ImportRowOutcomeKind.failed)
      .map((o) => o.rowIndex)
      .toList();

  Map<ImportSaveFailureCategory, List<ImportRowOutcome>>
  get failedOutcomesByCategory {
    final grouped = <ImportSaveFailureCategory, List<ImportRowOutcome>>{};
    for (final outcome in outcomes) {
      if (outcome.kind != ImportRowOutcomeKind.failed) continue;
      final category =
          outcome.failure?.category ?? ImportSaveFailureCategory.unknown;
      grouped.putIfAbsent(category, () => []).add(outcome);
    }
    return grouped;
  }

  ImportCommitReport mergeRetry(ImportCommitReport retry) {
    final byIndex = {for (final outcome in outcomes) outcome.rowIndex: outcome};
    for (final outcome in retry.outcomes) {
      byIndex[outcome.rowIndex] = outcome;
    }
    final merged = byIndex.values.toList()
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));
    return ImportCommitReport.fromOutcomes(merged);
  }
}

ImportSaveFailure importSaveFailureFrom(
  Object error, {
  required String sourceText,
  required String targetType,
}) {
  final developerMessage = '${error.runtimeType}: $error';
  if (error is AppException) {
    final category = switch (error) {
      RateLimitException() ||
      NoInternetException() ||
      ApiUnavailableException() ||
      InvalidApiConfigException() => ImportSaveFailureCategory.network,
      MovieNotFoundException() => ImportSaveFailureCategory.metadata,
      DuplicateMovieException() => ImportSaveFailureCategory.duplicate,
      _ => ImportSaveFailureCategory.unknown,
    };
    return ImportSaveFailure(
      sourceText: sourceText,
      targetType: targetType,
      category: category,
      developerMessage: developerMessage,
      userMessage: error.message,
    );
  }
  final text = error.toString().toLowerCase();
  if (text.contains('unique constraint') ||
      text.contains('foreign key') ||
      text.contains('constraint failed')) {
    return ImportSaveFailure(
      sourceText: sourceText,
      targetType: targetType,
      category: ImportSaveFailureCategory.databaseConstraint,
      developerMessage: developerMessage,
      userMessage:
          'Der Eintrag konnte aufgrund eines Datenbankkonflikts nicht gespeichert werden.',
    );
  }
  if (text.contains('no such table') ||
      text.contains('no such column') ||
      text.contains('schema')) {
    return ImportSaveFailure(
      sourceText: sourceText,
      targetType: targetType,
      category: ImportSaveFailureCategory.databaseMigration,
      developerMessage: developerMessage,
      userMessage:
          'Die lokale Datenbank konnte nicht aktualisiert werden. Bitte starte die App neu.',
    );
  }
  if (error is ArgumentError ||
      error is FormatException ||
      text.contains('invaliddata')) {
    return ImportSaveFailure(
      sourceText: sourceText,
      targetType: targetType,
      category: ImportSaveFailureCategory.invalidData,
      developerMessage: developerMessage,
      userMessage:
          'Die gespeicherten Daten für diesen Titel sind unvollständig oder ungültig.',
    );
  }
  return ImportSaveFailure(
    sourceText: sourceText,
    targetType: targetType,
    category: ImportSaveFailureCategory.unknown,
    developerMessage: developerMessage,
    userMessage: 'Es ist ein unerwarteter Fehler aufgetreten.',
  );
}

extension ImportTargetLabels on ImportTarget {
  String get kindLabel => switch (this) {
    ImportTargetSingleMovie() => 'Film',
    ImportTargetMovieBundle() => 'Filmreihe erkannt',
    ImportTargetSingleTvSeason() => 'Staffel erkannt',
    ImportTargetTvSeasonBundle() => 'Staffelbox erkannt',
    ImportTargetCompleteTvSeries() => 'Komplette Serie erkannt',
    ImportTargetSkipped() => 'Ohne Zuordnung',
  };

  bool get isBundle => switch (this) {
    ImportTargetMovieBundle() ||
    ImportTargetTvSeasonBundle() ||
    ImportTargetCompleteTvSeries() ||
    ImportTargetSingleTvSeason() => true,
    _ => false,
  };

  String get debugTypeName => switch (this) {
    ImportTargetSingleMovie() => 'SingleMovie',
    ImportTargetMovieBundle() => 'MovieBundle',
    ImportTargetSingleTvSeason() => 'SingleTvSeason',
    ImportTargetTvSeasonBundle() => 'TvSeasonBundle',
    ImportTargetCompleteTvSeries() => 'CompleteTvSeries',
    ImportTargetSkipped() => 'Skipped',
  };

  int? get debugTmdbId => switch (this) {
    ImportTargetSingleMovie(:final movie) => movie.id,
    ImportTargetMovieBundle(:final collection) => collection.id,
    ImportTargetSingleTvSeason(:final series) => series.id,
    ImportTargetTvSeasonBundle(:final series) => series.id,
    ImportTargetCompleteTvSeries(:final series) => series.id,
    ImportTargetSkipped() => null,
  };
}
