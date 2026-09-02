import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/features/import/application/import_controller.dart';
import 'package:movie_shelf/features/import/data/import_repository.dart';
import 'package:movie_shelf/features/import/domain/import_models.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/match_candidate.dart';

import 'import_controller_test.mocks.dart';

const _goblet = TmdbSearchResult(
  id: 673,
  title: 'Harry Potter und der Feuerkelch',
);

@GenerateMocks([ImportRepository])
void main() {
  late MockImportRepository repository;
  late ImportController controller;

  final ambiguousRow = ImportRow(
    index: 0,
    rawLine: 'Harry Potter 4',
    parsedTitle: 'Harry Potter 4',
    status: ImportRowStatus.ambiguous,
    candidates: const [MatchCandidate(result: _goblet, confidence: 0.7)],
  );
  final notFoundRow = ImportRow(
    index: 1,
    rawLine: 'Some weird title',
    parsedTitle: 'Some weird title',
    status: ImportRowStatus.notFound,
  );
  final matchedRow = ImportRow(
    index: 2,
    rawLine: 'Twilight',
    parsedTitle: 'Twilight',
    status: ImportRowStatus.matchedAutomatically,
    selectedCandidate: const TmdbSearchResult(id: 1, title: 'Twilight'),
  );

  setUp(() {
    repository = MockImportRepository();
    controller = ImportController(repository);
  });

  Future<void> seedRows(List<ImportRow> rows) async {
    when(repository.buildRows(any)).thenAnswer((_) async => rows);
    await controller.analyzePlainText(rows.map((r) => r.rawLine).join('\n'));
  }

  test(
    'selecting a candidate marks the row as manually matched and preserves other rows',
    () async {
      await seedRows([ambiguousRow, notFoundRow, matchedRow]);

      controller.selectCandidate(0, _goblet);

      final updated = controller.state.rows.firstWhere((r) => r.index == 0);
      expect(updated.status, ImportRowStatus.matchedManually);
      expect(updated.selectedCandidate, _goblet);
      expect(
        controller.state.rows.firstWhere((r) => r.index == 1).status,
        ImportRowStatus.notFound,
      );
      expect(
        controller.state.rows.firstWhere((r) => r.index == 2).status,
        ImportRowStatus.matchedAutomatically,
      );
    },
  );

  test(
    'skipping a not-found row marks it skipped, distinct from notFound',
    () async {
      await seedRows([notFoundRow]);

      controller.skipRow(1);

      final updated = controller.state.rows.single;
      expect(updated.status, ImportRowStatus.skipped);
      expect(updated.status, isNot(ImportRowStatus.notFound));
      expect(updated.selectedCandidate, isNull);
    },
  );

  test(
    'a zero-result row starts as notFound and can be manually resolved',
    () async {
      await seedRows([notFoundRow]);
      expect(controller.state.rows.single.status, ImportRowStatus.notFound);

      controller.selectCandidate(1, _goblet);

      expect(
        controller.state.rows.single.status,
        ImportRowStatus.matchedManually,
      );
      expect(controller.state.rows.single.selectedCandidate, _goblet);
    },
  );

  test(
    'a row is left completely unchanged unless selectCandidate or skipRow is called '
    '(simulates opening the manual search screen and pressing back)',
    () async {
      await seedRows([ambiguousRow]);

      final row = controller.state.rows.single;
      expect(row.status, ImportRowStatus.ambiguous);
      expect(row.selectedCandidate, isNull);
      expect(row.rawLine, 'Harry Potter 4');
      expect(row.candidates, hasLength(1));
    },
  );

  test('summary counts reflect each distinct row state', () async {
    await seedRows([ambiguousRow, notFoundRow, matchedRow]);

    controller.selectCandidate(0, _goblet);
    controller.skipRow(1);

    final summary = controller.state.summary;
    expect(summary.matchedManually, 1);
    expect(summary.skipped, 1);
    expect(summary.matchedAutomatically, 1);
    expect(summary.ambiguous, 0);
    expect(summary.notFound, 0);
  });

  test(
    'commit passes every row (including skipped ones) to the repository, which '
    'excludes them, and stores the resulting report',
    () async {
      await seedRows([ambiguousRow, notFoundRow, matchedRow]);
      controller.selectCandidate(0, _goblet);
      controller.skipRow(1);

      when(
        repository.commit(
          any,
          any,
          onlyIndexes: anyNamed('onlyIndexes'),
          onProgress: anyNamed('onProgress'),
        ),
      ).thenAnswer((invocation) async {
        final onProgress =
            invocation.namedArguments[#onProgress]
                as void Function(ImportSaveProgress)?;
        onProgress?.call(
          const ImportSaveProgress(
            processed: 2,
            total: 3,
            currentTitle: 'Twilight',
            moviesAdded: 2,
          ),
        );
        return const ImportCommitReport(imported: 2, failed: 0, skipped: 1);
      });

      await controller.commit();

      final captured = verify(
        repository.commit(
          captureAny,
          captureAny,
          onlyIndexes: anyNamed('onlyIndexes'),
          onProgress: anyNamed('onProgress'),
        ),
      ).captured;
      final committedRows = captured.first as List<ImportRow>;
      expect(committedRows.map((r) => r.status).toSet(), {
        ImportRowStatus.matchedManually,
        ImportRowStatus.skipped,
        ImportRowStatus.matchedAutomatically,
      });
      expect(captured[1], CollectionStatus.owned);
      expect(controller.state.commitReport?.imported, 2);
      expect(controller.state.commitReport?.skipped, 1);
      expect(controller.state.phase, ImportPhase.done);
    },
  );

  test('commit progress is stored on the controller while saving', () async {
    await seedRows([matchedRow]);
    ImportSaveProgress? seen;
    when(
      repository.commit(
        any,
        any,
        onlyIndexes: anyNamed('onlyIndexes'),
        onProgress: anyNamed('onProgress'),
      ),
    ).thenAnswer((invocation) async {
      final onProgress =
          invocation.namedArguments[#onProgress]
              as void Function(ImportSaveProgress)?;
      const progress = ImportSaveProgress(
        processed: 1,
        total: 1,
        currentTitle: 'Twilight',
        moviesAdded: 1,
      );
      onProgress?.call(progress);
      seen = progress;
      return ImportCommitReport.fromOutcomes(const [
        ImportRowOutcome(
          rowIndex: 2,
          sourceText: 'Twilight',
          kind: ImportRowOutcomeKind.added,
          moviesAdded: 1,
        ),
      ]);
    });

    await controller.commit();

    expect(seen?.processed, 1);
    expect(controller.state.phase, ImportPhase.done);
    expect(controller.state.commitReport?.importedMovies, 1);
  });

  test('retryFailed persists only previously failed rows', () async {
    await seedRows([matchedRow, notFoundRow]);
    when(
      repository.commit(
        any,
        any,
        onlyIndexes: anyNamed('onlyIndexes'),
        onProgress: anyNamed('onProgress'),
      ),
    ).thenAnswer((invocation) async {
      final only = invocation.namedArguments[#onlyIndexes] as Set<int>?;
      if (only == null) {
        return ImportCommitReport.fromOutcomes(const [
          ImportRowOutcome(
            rowIndex: 2,
            sourceText: 'Twilight',
            kind: ImportRowOutcomeKind.added,
            moviesAdded: 1,
          ),
          ImportRowOutcome(
            rowIndex: 1,
            sourceText: 'Some weird title',
            kind: ImportRowOutcomeKind.failed,
            failure: ImportSaveFailure(
              sourceText: 'Some weird title',
              targetType: 'SingleMovie',
              category: ImportSaveFailureCategory.network,
              developerMessage: 'network',
              userMessage: 'Netzwerkfehler',
            ),
          ),
        ]);
      }
      expect(only, {1});
      return ImportCommitReport.fromOutcomes(const [
        ImportRowOutcome(
          rowIndex: 1,
          sourceText: 'Some weird title',
          kind: ImportRowOutcomeKind.added,
          moviesAdded: 1,
        ),
      ]);
    });

    await controller.commit();
    expect(controller.state.commitReport?.failed, 1);

    await controller.retryFailed();

    expect(controller.state.commitReport?.failed, 0);
    expect(controller.state.commitReport?.importedMovies, 2);
    expect(controller.state.rows, hasLength(2));
  });
}
