import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_shelf/features/collections/application/collections_providers.dart';
import 'package:movie_shelf/features/collections/domain/movie_collection_info.dart';
import 'package:movie_shelf/features/collections/presentation/franchise_section.dart';
import 'package:movie_shelf/features/scanner/presentation/fundstueck_result_screen.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/match_candidate.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';

void main() {
  MovieCollectionInfo sample() {
    return MovieCollectionInfo(
      localId: 4,
      tmdbCollectionId: 295,
      name: 'Pirates of the Caribbean',
      currentTmdbMovieId: 3,
      parts: const [
        MovieCollectionPart(
          tmdbMovieId: 1,
          title: 'The Curse of the Black Pearl',
          year: 2003,
          isCurrent: false,
          status: CollectionStatus.owned,
          localMovieId: 10,
        ),
        MovieCollectionPart(
          tmdbMovieId: 3,
          title: "At World's End",
          year: 2007,
          isCurrent: true,
        ),
      ],
    );
  }

  testWidgets('tapping a part opens the existing movie or add screen', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: FranchiseCard(info: sample(), pendingConfirmation: true),
          ),
        ),
        GoRoute(
          path: '/movie/:id',
          builder: (context, state) =>
              Text('movie-${state.pathParameters['id']}'),
        ),
        GoRoute(
          path: '/search/add/:tmdbId',
          builder: (context, state) =>
              Text('add-${state.pathParameters['tmdbId']}'),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );

    await tester.tap(find.text('The Curse of the Black Pearl'));
    await tester.pumpAndSettle();
    expect(find.text('movie-10'), findsOneWidget);

    router.go('/');
    await tester.pumpAndSettle();
    await tester.tap(find.text("At World's End"));
    await tester.pumpAndSettle();
    expect(find.text('add-3'), findsOneWidget);
  });

  testWidgets('a franchise failure still shows the scan confirmation', (
    tester,
  ) async {
    const candidate = MatchCandidate(
      result: TmdbSearchResult(id: 285, title: 'Am Ende der Welt'),
      confidence: 0.99,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          franchiseProvider.overrideWith(
            (ref, id) => Stream<MovieCollectionInfo?>.error(StateError('down')),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: MissingMovieView(
              barcode: '400',
              productTitle: 'Pirates Blu-ray',
              candidates: [candidate],
              selected: candidate,
              showAlternatives: false,
              onToggleAlternatives: _noop,
              onSelect: _ignore,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Am Ende der Welt'), findsOneWidget);
    expect(find.text('Als gekauft speichern'), findsOneWidget);
    expect(find.text('Teil einer Filmreihe'), findsNothing);
  });
}

void _noop() {}

void _ignore(int index) {}
