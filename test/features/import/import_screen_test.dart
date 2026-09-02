import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/core/providers/repository_providers.dart';
import 'package:movie_shelf/features/import/application/import_controller.dart';
import 'package:movie_shelf/features/import/data/import_repository.dart';
import 'package:movie_shelf/features/import/domain/import_models.dart';
import 'package:movie_shelf/features/import/presentation/import_movie_search_screen.dart';
import 'package:movie_shelf/features/import/presentation/import_screen.dart';
import 'package:movie_shelf/shared/models/match_candidate.dart';
import 'package:movie_shelf/shared/widgets/movie_search_result_tile.dart';

import 'import_screen_test.mocks.dart';

const _candidates = [
  TmdbSearchResult(id: 1, title: 'Kandidat 1'),
  TmdbSearchResult(id: 2, title: 'Kandidat 2'),
  TmdbSearchResult(id: 3, title: 'Kandidat 3'),
  TmdbSearchResult(id: 4, title: 'Kandidat 4'),
  TmdbSearchResult(id: 5, title: 'Kandidat 5'),
  TmdbSearchResult(id: 6, title: 'Kandidat 6'),
];

@GenerateMocks([ImportRepository])
void main() {
  late MockImportRepository repository;
  late ProviderContainer container;

  ImportRow ambiguousRow() => ImportRow(
    index: 0,
    rawLine: 'Harry Potter 4',
    parsedTitle: 'Harry Potter 4',
    status: ImportRowStatus.ambiguous,
    candidates: [
      for (var i = 0; i < _candidates.length; i++)
        MatchCandidate(result: _candidates[i], confidence: 0.7 - i * 0.01),
    ],
  );

  ImportRow notFoundRow() => const ImportRow(
    index: 0,
    rawLine: 'Some completely unknown title',
    parsedTitle: 'Some completely unknown title',
    status: ImportRowStatus.notFound,
  );

  setUp(() {
    repository = MockImportRepository();
    container = ProviderContainer(
      overrides: [importRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> pumpImportScreen(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/import',
      routes: [
        GoRoute(path: '/import', builder: (_, __) => const ImportScreen()),
        GoRoute(
          path: '/collection',
          builder: (_, __) => const Scaffold(body: Text('Sammlung')),
        ),
        GoRoute(
          path: '/import/movie-search/:index',
          builder: (context, state) => ImportMovieSearchScreen(
            rowIndex: int.parse(state.pathParameters['index']!),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> analyze(List<ImportRow> rows) async {
    when(repository.buildRows(any)).thenAnswer((_) async => rows);
    await container
        .read(importControllerProvider.notifier)
        .analyzePlainText(rows.map((r) => r.rawLine).join('\n'));
  }

  testWidgets(
    'an ambiguous row shows only the first 4 candidates and a Weitere Ergebnisse button',
    (tester) async {
      await pumpImportScreen(tester);
      await analyze([ambiguousRow()]);
      await tester.pumpAndSettle();

      expect(find.text('Nicht eindeutig erkannt'), findsOneWidget);
      expect(find.byType(MovieSearchResultTile), findsNWidgets(4));
      expect(find.text('Kandidat 1'), findsOneWidget);
      expect(find.text('Kandidat 4'), findsOneWidget);
      expect(find.text('Kandidat 5'), findsNothing);
      expect(find.text('Weitere Ergebnisse'), findsOneWidget);
      expect(find.text('Ohne Zuordnung fortfahren'), findsOneWidget);
    },
  );

  testWidgets('a not-found row shows the manual search action', (tester) async {
    await pumpImportScreen(tester);
    await analyze([notFoundRow()]);
    await tester.pumpAndSettle();

    expect(find.text('Kein passender Titel erkannt'), findsOneWidget);
    expect(find.text('Film suchen'), findsOneWidget);
    expect(find.text('Ohne Zuordnung fortfahren'), findsOneWidget);
  });

  testWidgets(
    'tapping a candidate resolves the ambiguous row as manually matched',
    (tester) async {
      await pumpImportScreen(tester);
      await analyze([ambiguousRow()]);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kandidat 1'));
      await tester.pumpAndSettle();

      expect(find.text('Manuell zugeordnet'), findsOneWidget);
      expect(find.textContaining('Kandidat 1'), findsOneWidget);
    },
  );

  testWidgets(
    '"Ohne Zuordnung fortfahren" marks the ambiguous row as skipped',
    (tester) async {
      await pumpImportScreen(tester);
      await analyze([ambiguousRow()]);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Ohne Zuordnung fortfahren'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ohne Zuordnung fortfahren'));
      await tester.pumpAndSettle();

      expect(find.text('Ohne Zuordnung'), findsOneWidget);
      expect(container.read(importControllerProvider).summary.skipped, 1);
    },
  );

  testWidgets('result view groups failures and offers retry', (tester) async {
    const rows = [
      ImportRow(
        index: 0,
        rawLine: 'Pacific Rim',
        parsedTitle: 'Pacific Rim',
        status: ImportRowStatus.matchedAutomatically,
        selectedCandidate: TmdbSearchResult(id: 68726, title: 'Pacific Rim'),
      ),
      ImportRow(
        index: 1,
        rawLine: 'Karate Kid',
        parsedTitle: 'Karate Kid',
        status: ImportRowStatus.matchedAutomatically,
        selectedCandidate: TmdbSearchResult(id: 1885, title: 'Karate Kid'),
      ),
    ];
    when(
      repository.commit(
        any,
        any,
        onlyIndexes: anyNamed('onlyIndexes'),
        onProgress: anyNamed('onProgress'),
      ),
    ).thenAnswer(
      (_) async => ImportCommitReport.fromOutcomes(const [
        ImportRowOutcome(
          rowIndex: 0,
          sourceText: 'Pacific Rim',
          kind: ImportRowOutcomeKind.failed,
          failure: ImportSaveFailure(
            sourceText: 'Pacific Rim',
            targetType: 'SingleMovie',
            category: ImportSaveFailureCategory.databaseConstraint,
            developerMessage: 'UNIQUE constraint failed: genres.tmdb_id',
            userMessage:
                'Der Eintrag konnte aufgrund eines Datenbankkonflikts nicht gespeichert werden.',
          ),
        ),
        ImportRowOutcome(
          rowIndex: 1,
          sourceText: 'Karate Kid',
          kind: ImportRowOutcomeKind.added,
          moviesAdded: 1,
        ),
      ]),
    );

    await pumpImportScreen(tester);
    await analyze(rows);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Import starten'));
    await tester.tap(find.text('Import starten'));
    await tester.pumpAndSettle();

    expect(find.text('Import teilweise abgeschlossen'), findsOneWidget);
    expect(find.text('Datenbankfehler · 1'), findsOneWidget);
    expect(find.text('Pacific Rim'), findsWidgets);
    expect(find.text('Fehlgeschlagene erneut versuchen'), findsOneWidget);
    expect(find.text('Zur Sammlung'), findsOneWidget);
  });
}
