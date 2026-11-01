import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/core/network/dio_client.dart';
import 'package:speednema/core/network/network_info.dart';
import 'package:speednema/core/network/tmdb/tmdb_api_client.dart';
import 'package:speednema/core/network/tmdb/tmdb_models.dart';
import 'package:speednema/core/providers/core_providers.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/features/search/presentation/movie_search_screen.dart';

import '../../fixtures/movie_fixtures.dart';

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

class _FakeTmdb extends TmdbApiClient {
  _FakeTmdb(this.results)
    : super(DioClient(dio: Dio(), networkInfo: _Online()));

  final List<TmdbSearchResult> results;

  @override
  Future<List<TmdbSearchResult>> searchMovies(
    String query, {
    int page = 1,
    int? year,
  }) async => results;
}

/// Search looks on the shelf first and never offers to add a film twice.
void main() {
  final owned = buildMovie(id: 7, tmdbId: 603, title: 'The Matrix');

  Future<String?> pump(
    WidgetTester tester, {
    required bool tmdb,
    List<TmdbSearchResult> results = const [],
  }) async {
    String? opened;
    final router = GoRouter(
      initialLocation: '/search',
      routes: [
        GoRoute(path: '/search', builder: (_, _) => const MovieSearchScreen()),
        GoRoute(
          path: '/movie/:id',
          builder: (_, s) {
            opened = '/movie/${s.pathParameters['id']}';
            return const Scaffold(body: Text('Film'));
          },
        ),
        GoRoute(
          path: '/search/add/:id',
          builder: (_, s) {
            opened = '/search/add/${s.pathParameters['id']}';
            return const Scaffold(body: Text('Hinzufügen'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allMoviesProvider.overrideWith((ref) => Stream.value([owned])),
          if (tmdb) tmdbUserTokenProvider.overrideWith((ref) => 'token'),
          tmdbApiClientProvider.overrideWithValue(_FakeTmdb(results)),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    // The search field blinks and posters spin while loading, so settle by
    // time instead of waiting for stillness.
    Future<void> frames() async {
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    await frames();
    await tester.enterText(find.byType(TextField), 'matrix');
    await tester.pump(const Duration(milliseconds: 450));
    await frames();
    return opened;
  }

  testWidgets('own films are found even without movie information', (
    tester,
  ) async {
    await pump(tester, tmdb: false);
    expect(find.text('In deiner Sammlung'), findsOneWidget);
    expect(find.text('The Matrix'), findsOneWidget);
    expect(find.text('Filminfos sind noch nicht eingerichtet'), findsOneWidget);
    expect(find.text('Keine Treffer'), findsNothing);
  });

  testWidgets('a TMDB result already owned opens the film instead of adding it', (
    tester,
  ) async {
    await pump(
      tester,
      tmdb: true,
      results: const [
        TmdbSearchResult(id: 603, title: 'The Matrix'),
        TmdbSearchResult(id: 604, title: 'The Matrix Reloaded'),
      ],
    );
    // One chip marks the TMDB result; the section header says the same.
    expect(find.text('In deiner Sammlung'), findsNWidgets(2));

    await tester.tap(find.text('The Matrix').last);
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Film'), findsOneWidget);
  });

  testWidgets('a new film leads to adding it', (tester) async {
    await pump(
      tester,
      tmdb: true,
      results: const [TmdbSearchResult(id: 604, title: 'The Matrix Reloaded')],
    );
    await tester.tap(find.text('The Matrix Reloaded'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Hinzufügen'), findsOneWidget);
  });
}
