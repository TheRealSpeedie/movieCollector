import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_shelf/app/theme/app_theme.dart';
import 'package:movie_shelf/features/server/application/server_providers.dart';
import 'package:movie_shelf/features/server/domain/server_models.dart';
import 'package:movie_shelf/features/television/application/tv_providers.dart';
import 'package:movie_shelf/features/television/presentation/tv_focusable.dart';
import 'package:movie_shelf/features/television/presentation/tv_home_screen.dart';

import '../server/support/fakes.dart';

ServerTitle title(int id, String name, {bool series = false}) => ServerTitle(
  id: id,
  isSeries: series,
  tmdbId: id,
  name: name,
  year: 2020,
  posterUrl: null,
  runtimeMinutes: 100,
  genres: const [],
  rating: null,
  qualities: const [],
  favorite: false,
  watched: false,
  fraction: 0,
  watchedEpisodes: 0,
  totalEpisodes: 0,
);

bool focused(String text) =>
    Focus.of(find.text(text).evaluate().first).hasFocus;

Future<void> press(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('TvFocusable', () {
    testWidgets('moves focus with the arrow keys and selects with enter', (
      tester,
    ) async {
      var selected = '';
      Widget item(String label) => TvFocusable(
        onSelect: () => selected = label,
        child: Padding(padding: const EdgeInsets.all(20), child: Text(label)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(
                  children: [
                    TvFocusable(
                      autofocus: true,
                      onSelect: () => selected = 'one',
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('one'),
                      ),
                    ),
                    item('two'),
                  ],
                ),
                Row(children: [item('three'), item('four')]),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(focused('one'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowRight);
      expect(focused('two'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowDown);
      expect(focused('four'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowLeft);
      expect(focused('three'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowUp);
      expect(focused('one'), isTrue);

      await press(tester, LogicalKeyboardKey.select);
      expect(selected, 'one');
    });
  });

  group('TvHomeScreen', () {
    late String opened;

    Future<void> pumpHome(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      opened = '';
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const TvHomeScreen()),
          GoRoute(
            path: '/title/:id',
            builder: (_, state) {
              opened = state.pathParameters['id']!;
              return const Scaffold(body: Text('detail'));
            },
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            credentialStoreProvider.overrideWithValue(
              MemoryStore(sampleCredentials()),
            ),
            serverDiscoveryProvider.overrideWithValue(FakeDiscovery()),
            serverClientProvider.overrideWithValue(null),
            serverHomeProvider.overrideWith(
              (ref) async => HomeData(
                resume: const [
                  ResumeItem(
                    isNext: false,
                    titleId: 1,
                    episodeId: null,
                    fileId: 10,
                    name: 'Resume Movie',
                    subtitle: null,
                    posterUrl: null,
                    backdropUrl: null,
                    positionSeconds: 300,
                    durationSeconds: 6000,
                  ),
                ],
                recent: [title(2, 'Recent A'), title(3, 'Recent B')],
              ),
            ),
            tvTitlesProvider.overrideWith(
              (ref, kind) async => kind == 'Movie'
                  ? [title(4, 'Movie A')]
                  : [title(5, 'Show A', series: true)],
            ),
          ],
          child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('starts on the first resume tile', (tester) async {
      await pumpHome(tester);

      expect(focused('Resume Movie'), isTrue);
    });

    testWidgets('walks down the rows and across a row', (tester) async {
      await pumpHome(tester);

      await press(tester, LogicalKeyboardKey.arrowDown);
      expect(focused('Recent A'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowRight);
      expect(focused('Recent B'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowDown);
      expect(focused('Movie A'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowDown);
      expect(focused('Show A'), isTrue);

      await press(tester, LogicalKeyboardKey.arrowUp);
      await press(tester, LogicalKeyboardKey.arrowUp);
      await press(tester, LogicalKeyboardKey.arrowUp);
      expect(focused('Resume Movie'), isTrue);
    });

    testWidgets('opens the focused title with the select key', (tester) async {
      await pumpHome(tester);

      await press(tester, LogicalKeyboardKey.arrowDown);
      await press(tester, LogicalKeyboardKey.arrowDown);
      await press(tester, LogicalKeyboardKey.select);

      expect(opened, '4');
      expect(find.text('detail'), findsOneWidget);
    });
  });
}
