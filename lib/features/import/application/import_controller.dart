import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/utils/debug_log.dart';
import '../../../shared/models/collection_status.dart';
import '../data/import_repository.dart';
import '../domain/import_models.dart';
import '../domain/import_text_parser.dart';

enum ImportPhase { input, analyzing, review, committing, done, error }

class ImportState {
  const ImportState({
    this.phase = ImportPhase.input,
    this.rows = const [],
    this.defaultStatus = CollectionStatus.owned,
    this.errorMessage,
    this.commitReport,
    this.progress,
  });

  final ImportPhase phase;
  final List<ImportRow> rows;
  final CollectionStatus defaultStatus;
  final String? errorMessage;
  final ImportCommitReport? commitReport;
  final ImportSaveProgress? progress;

  ImportSummary get summary => ImportSummary(
    totalLines: rows.length,
    matchedAutomatically: rows
        .where((r) => r.status == ImportRowStatus.matchedAutomatically)
        .length,
    matchedManually: rows
        .where((r) => r.status == ImportRowStatus.matchedManually)
        .length,
    ambiguous: rows.where((r) => r.status == ImportRowStatus.ambiguous).length,
    notFound: rows.where((r) => r.status == ImportRowStatus.notFound).length,
    duplicates: rows.where((r) => r.status == ImportRowStatus.duplicate).length,
    skipped: rows.where((r) => r.status == ImportRowStatus.skipped).length,
  );

  ImportState copyWith({
    ImportPhase? phase,
    List<ImportRow>? rows,
    CollectionStatus? defaultStatus,
    String? errorMessage,
    ImportCommitReport? commitReport,
    ImportSaveProgress? progress,
  }) {
    return ImportState(
      phase: phase ?? this.phase,
      rows: rows ?? this.rows,
      defaultStatus: defaultStatus ?? this.defaultStatus,
      errorMessage: errorMessage,
      commitReport: commitReport ?? this.commitReport,
      progress: progress ?? this.progress,
    );
  }
}

class ImportController extends StateNotifier<ImportState> {
  ImportController(this._repository) : super(const ImportState());

  final ImportRepository _repository;
  final ImportTextParser _parser = const ImportTextParser();

  Future<void> analyzePlainText(String raw) =>
      _analyze(_parser.parsePlainText(raw));

  Future<void> analyzeCsv(String raw) => _analyze(_parser.parseCsv(raw));

  Future<void> _analyze(List<String> lines) async {
    if (lines.isEmpty) {
      state = state.copyWith(
        phase: ImportPhase.error,
        errorMessage: 'Es wurden keine Titel erkannt.',
      );
      return;
    }
    state = ImportState(
      phase: ImportPhase.analyzing,
      defaultStatus: state.defaultStatus,
    );
    try {
      final rows = await _repository.buildRows(lines);
      state = state.copyWith(phase: ImportPhase.review, rows: rows);
    } catch (error, stack) {
      debugLog('Import analysis failed: $error\n$stack');
      state = state.copyWith(
        phase: ImportPhase.error,
        errorMessage: 'Beim Abgleich mit TMDB ist ein Fehler aufgetreten.',
      );
    }
  }

  void setDefaultStatus(CollectionStatus status) {
    state = state.copyWith(defaultStatus: status);
  }

  void selectCandidate(int index, TmdbSearchResult candidate) {
    applyTarget(index, ImportTarget.singleMovie(movie: candidate));
  }

  void applyTarget(int index, ImportTarget target) {
    final updated = state.rows.map((row) {
      if (row.index != index) return row;
      final movie = target is ImportTargetSingleMovie ? target.movie : null;
      return row.copyWith(
        status: ImportRowStatus.matchedManually,
        selectedCandidate: movie,
        target: target,
      );
    }).toList();
    state = state.copyWith(rows: updated);
  }

  void skipRow(int index) {
    final updated = state.rows.map((row) {
      if (row.index != index) return row;
      return row.copyWith(
        status: ImportRowStatus.skipped,
        selectedCandidate: null,
        target: const ImportTarget.skipped(),
      );
    }).toList();
    state = state.copyWith(rows: updated);
  }

  Future<void> commit() async {
    await _persist(onlyIndexes: null, previous: null);
  }

  Future<void> retryFailed() async {
    final report = state.commitReport;
    if (report == null || !report.hasRetryableFailures) return;
    await _persist(
      onlyIndexes: report.failedRowIndexes.toSet(),
      previous: report,
    );
  }

  Future<void> _persist({
    required Set<int>? onlyIndexes,
    required ImportCommitReport? previous,
  }) async {
    state = state.copyWith(
      phase: ImportPhase.committing,
      progress: ImportSaveProgress(
        processed: 0,
        total: onlyIndexes?.length ?? state.rows.length,
      ),
    );
    try {
      final report = await _repository.commit(
        state.rows,
        state.defaultStatus,
        onlyIndexes: onlyIndexes,
        onProgress: (progress) {
          state = state.copyWith(
            phase: ImportPhase.committing,
            progress: progress,
          );
        },
      );
      final merged = previous == null ? report : previous.mergeRetry(report);
      state = state.copyWith(phase: ImportPhase.done, commitReport: merged);
    } catch (error, stack) {
      debugLog('Import commit failed: $error\n$stack');
      state = state.copyWith(
        phase: ImportPhase.error,
        errorMessage: 'Beim Speichern ist ein Fehler aufgetreten.',
      );
    }
  }

  void reset() {
    state = ImportState(defaultStatus: state.defaultStatus);
  }
}

final importControllerProvider =
    StateNotifierProvider.autoDispose<ImportController, ImportState>((ref) {
      return ImportController(ref.watch(importRepositoryProvider));
    });
