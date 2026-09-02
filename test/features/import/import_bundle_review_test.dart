import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/core/providers/repository_providers.dart';
import 'package:movie_shelf/features/import/application/import_controller.dart';
import 'package:movie_shelf/features/import/domain/import_models.dart';
import 'package:movie_shelf/features/import/presentation/import_screen.dart';

import 'import_screen_test.mocks.dart';

void main() {
  testWidgets('import review shows movie bundle counts', (tester) async {
    final repository = MockImportRepository();
    when(repository.buildRows(any)).thenAnswer(
      (_) async => [
        ImportRow(
          index: 0,
          rawLine: "Sharknado Collector's Box",
          parsedTitle: 'Sharknado',
          status: ImportRowStatus.ambiguous,
          target: ImportTarget.movieBundle(
            collection: const TmdbCollectionDetails(
              id: 11,
              name: 'Sharknado Collection',
              parts: [
                TmdbCollectionMovieRef(id: 1, title: 'Sharknado'),
                TmdbCollectionMovieRef(id: 2, title: 'Sharknado 2'),
              ],
            ),
            selectedTmdbIds: const [1, 2],
          ),
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: [importRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ImportScreen()),
      ),
    );
    await container
        .read(importControllerProvider.notifier)
        .analyzePlainText("Sharknado Collector's Box");
    await tester.pumpAndSettle();

    expect(find.text('Filmreihe erkannt'), findsOneWidget);
    expect(find.textContaining('2 Filme ausgewählt'), findsOneWidget);
    expect(find.text('✓ Sharknado'), findsOneWidget);
    expect(find.text('Auswahl bearbeiten'), findsOneWidget);
  });
}
