import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/features/scanner/presentation/fundstueck_result_screen.dart';
import 'package:movie_shelf/shared/models/match_candidate.dart';

import '../../fixtures/movie_fixtures.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
  }

  group('KnownMovieView', () {
    testWidgets('shows the owned banner for an already owned movie', (
      tester,
    ) async {
      await pump(tester, KnownMovieView(movie: ownedMovieFixture()));

      expect(find.text('✓ Bereits in deiner Sammlung'), findsOneWidget);
      expect(find.text('Gekaufter Film'), findsOneWidget);
    });

    testWidgets('shows the wishlist banner for a wishlist movie', (
      tester,
    ) async {
      await pump(tester, KnownMovieView(movie: wishlistMovieFixture()));

      expect(find.text('♡ Auf deiner Wunschliste'), findsOneWidget);
    });

    testWidgets('shows the open banner for an open movie', (tester) async {
      await pump(tester, KnownMovieView(movie: openMovieFixture()));

      expect(find.text('Als offen gespeichert'), findsOneWidget);
    });
  });

  group('MissingMovieView', () {
    testWidgets('shows the missing-movie banner and save actions', (
      tester,
    ) async {
      const candidate = MatchCandidate(
        result: TmdbSearchResult(id: 1, title: 'Ein unbekannter Film'),
        confidence: 0.6,
      );
      await pump(
        tester,
        MissingMovieView(
          barcode: '4001234567890',
          productTitle: 'Ein unbekannter Film DVD',
          candidates: const [candidate],
          selected: candidate,
          showAlternatives: false,
          onToggleAlternatives: () {},
          onSelect: (_) {},
        ),
      );

      expect(find.text('Dieser Film fehlt dir'), findsOneWidget);
      expect(find.text('Als gekauft speichern'), findsOneWidget);
      expect(find.text('Zur Wunschliste'), findsOneWidget);
      expect(find.text('Als offen speichern'), findsOneWidget);
    });
  });

  group('NoMatchView', () {
    testWidgets('shows a helpful message when nothing matched', (tester) async {
      await pump(
        tester,
        const NoMatchView(productTitle: 'Unbekanntes Produkt'),
      );

      expect(
        find.text('Es wurde kein passender Film gefunden.'),
        findsOneWidget,
      );
      expect(find.textContaining('Unbekanntes Produkt'), findsOneWidget);
    });
  });
}
