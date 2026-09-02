import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/core/providers/core_providers.dart';
import 'package:movie_shelf/core/providers/repository_providers.dart';
import 'package:movie_shelf/features/import/application/import_controller.dart';
import 'package:movie_shelf/features/import/data/import_repository.dart';
import 'package:movie_shelf/features/import/domain/import_models.dart';
import 'package:movie_shelf/features/import/presentation/import_movie_search_screen.dart';
import 'package:movie_shelf/features/import/presentation/import_screen.dart';

import 'import_movie_search_screen_test.mocks.dart';

const _notFoundTitle = 'Some completely unknown title';

ImportRow _notFoundRow() => const ImportRow(
  index: 0,
  rawLine: _notFoundTitle,
  parsedTitle: _notFoundTitle,
  status: ImportRowStatus.notFound,
);

List<TmdbSearchResult> _page(int page, int count) => List.generate(
  count,
  (i) =>
      TmdbSearchResult(id: page * 100 + i, title: 'Treffer ${page * 100 + i}'),
);

@GenerateMocks([ImportRepository, TmdbApiClient])
void main() {
  late MockImportRepository importRepository;
  late MockTmdbApiClient tmdbApiClient;
  late ProviderContainer container;

  setUp(() {
    importRepository = MockImportRepository();
    tmdbApiClient = MockTmdbApiClient();
    container = ProviderContainer(
      overrides: [
        importRepositoryProvider.overrideWithValue(importRepository),
        tmdbApiClientProvider.overrideWithValue(tmdbApiClient),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> pumpAndAnalyze(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/import',
      routes: [
        GoRoute(path: '/import', builder: (_, __) => const ImportScreen()),
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

    when(
      importRepository.buildRows(any),
    ).thenAnswer((_) async => [_notFoundRow()]);
    await container
        .read(importControllerProvider.notifier)
        .analyzePlainText(_notFoundTitle);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'opening the manual search screen prefills the query with the imported title '
    'and shows the results returned by TMDB',
    (tester) async {
      when(
        tmdbApiClient.searchMovies(any, page: 1),
      ).thenAnswer((_) async => _page(1, 3));
      await pumpAndAnalyze(tester);

      await tester.tap(find.text('Film suchen'));
      await tester.pumpAndSettle();

      expect(find.text('Film zuordnen'), findsOneWidget);
      expect(find.textContaining(_notFoundTitle), findsWidgets);
      expect(find.widgetWithText(TextField, _notFoundTitle), findsOneWidget);
      expect(find.text('Treffer 100'), findsOneWidget);
      verify(tmdbApiClient.searchMovies(_notFoundTitle, page: 1)).called(1);
    },
  );

  testWidgets(
    'selecting a manual search result assigns it and returns to the import review',
    (tester) async {
      when(
        tmdbApiClient.searchMovies(any, page: 1),
      ).thenAnswer((_) async => _page(1, 3));
      await pumpAndAnalyze(tester);

      await tester.tap(find.text('Film suchen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Treffer 100'));
      await tester.pumpAndSettle();

      expect(find.text('Film zuordnen'), findsNothing);
      expect(find.text('Manuell zugeordnet'), findsOneWidget);
      expect(find.textContaining('Treffer 100'), findsOneWidget);
    },
  );

  testWidgets('"Ohne Film fortfahren" marks the row skipped and returns', (
    tester,
  ) async {
    when(
      tmdbApiClient.searchMovies(any, page: 1),
    ).thenAnswer((_) async => _page(1, 3));
    await pumpAndAnalyze(tester);

    await tester.tap(find.text('Film suchen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ohne Zuordnung fortfahren'));
    await tester.pumpAndSettle();

    expect(find.text('Film zuordnen'), findsNothing);
    expect(find.text('Ohne Zuordnung'), findsOneWidget);
  });

  testWidgets(
    'pressing back without selecting anything leaves the row unchanged',
    (tester) async {
      when(
        tmdbApiClient.searchMovies(any, page: 1),
      ).thenAnswer((_) async => _page(1, 3));
      await pumpAndAnalyze(tester);

      await tester.tap(find.text('Film suchen'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Film zuordnen'), findsNothing);
      expect(find.text('Kein passender Titel erkannt'), findsOneWidget);
      expect(
        container.read(importControllerProvider).rows.single.status,
        ImportRowStatus.notFound,
      );
    },
  );

  testWidgets('"Mehr laden" appends the next page of results', (tester) async {
    when(
      tmdbApiClient.searchMovies(any, page: 1),
    ).thenAnswer((_) async => _page(1, 20));
    when(
      tmdbApiClient.searchMovies(any, page: 2),
    ).thenAnswer((_) async => _page(2, 5));
    await pumpAndAnalyze(tester);

    await tester.tap(find.text('Film suchen'));
    await tester.pumpAndSettle();

    expect(find.text('Treffer 200'), findsNothing);

    await tester.dragUntilVisible(
      find.text('Mehr laden'),
      find.byType(ListView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mehr laden'), findsOneWidget);
    await tester.tap(find.text('Mehr laden'));
    await tester.pumpAndSettle();

    expect(find.text('Treffer 200'), findsOneWidget);
    verify(tmdbApiClient.searchMovies(_notFoundTitle, page: 2)).called(1);
  });
}
