import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/features/scanner/application/scan_providers.dart';
import 'package:speednema/features/scanner/domain/scan_assessment.dart';
import 'package:speednema/features/scanner/presentation/fundstueck_result_screen.dart';
import 'package:speednema/features/scanner/presentation/verdict_panel.dart';
import 'package:speednema/shared/models/collection_status.dart';

import '../../support/golden_harness.dart';

/// "Do I already own this?" answered first, in a word, with the right
/// priority, a haptic, and a way forward when the lookup fails.
void main() {
  ScanAssessment assessment(List<ScanVerdict> verdicts, {bool exact = true}) =>
      ScanAssessment(
        confidence: exact ? MatchConfidence.exact : MatchConfidence.probable,
        insights: [for (final v in verdicts) ScanInsight(v, 'Hinweis $v')],
      );

  group('which verdict leads', () {
    test('owning the exact edition beats everything', () {
      final v = verdictFor(
        assessment([
          ScanVerdict.collectionGap,
          ScanVerdict.wishlistMatch,
          ScanVerdict.alreadyOwnedExact,
        ]),
        CollectionStatus.owned,
      );
      expect(v.title, 'Hab ich');
      expect(v.owned, isTrue);
    });

    test('another edition is still "Hab ich", but says so', () {
      expect(
        verdictFor(assessment([ScanVerdict.otherEditionOwned]), null).title,
        'Hab ich – andere Ausgabe',
      );
    });

    test('the wishlist beats a gap in a series', () {
      expect(
        verdictFor(
          assessment([ScanVerdict.collectionGap, ScanVerdict.wishlistMatch]),
          null,
        ).title,
        'Auf deiner Wunschliste',
      );
    });

    test('without an assessment the collection status decides', () {
      expect(verdictFor(null, CollectionStatus.owned).title, 'Hab ich');
      expect(verdictFor(null, CollectionStatus.open).title, 'Noch nicht gekauft');
      expect(verdictFor(null, null).title, 'Neu für dich');
    });
  });

  const request = (
    editionId: null,
    tmdbId: 1,
    tmdbCollectionId: null,
    format: null,
    exact: true,
  );

  Widget panel(ScanAssessment a, {CollectionStatus? status}) => ProviderScope(
    overrides: [
      scanAssessmentProvider(request).overrideWith((ref) async => a),
    ],
    child: MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VerdictPanel(request: request, status: status),
        ),
      ),
    ),
  );

  testWidgets('owning it is confirmed with a firm haptic, once', (tester) async {
    final haptics = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          haptics.add(call.arguments as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(
      panel(assessment([ScanVerdict.alreadyOwnedExact]), status: CollectionStatus.owned),
    );
    await tester.pumpAndSettle();
    await tester.pump();

    expect(find.text('Hab ich'), findsOneWidget);
    expect(find.text('Genau diese Ausgabe'), findsOneWidget);
    expect(haptics, ['HapticFeedbackType.heavyImpact']);
  });

  testWidgets('a failed lookup offers retry and title entry', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, _) => const Scaffold(
                  body: LookupFailedView(
                    barcode: '4006381333931',
                    message: 'Keine Internetverbindung verfügbar.',
                  ),
                ),
              ),
              GoRoute(
                path: '/search',
                builder: (_, _) => const Scaffold(body: Text('Suche')),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Erneut versuchen'), findsOneWidget);
    await tester.tap(find.text('Titel eingeben'));
    await tester.pumpAndSettle();
    expect(find.text('Suche'), findsOneWidget);
  });

  for (final (name, verdicts, status, exact) in [
    ('owned_exact', [ScanVerdict.alreadyOwnedExact], CollectionStatus.owned, true),
    ('wishlist', [ScanVerdict.wishlistMatch], CollectionStatus.wishlist, false),
    ('new', [ScanVerdict.newDiscovery], null, false),
  ]) {
    screenGoldens(
      'verdict_$name',
      () => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VerdictPanel(request: request, status: status),
        ),
      ),
      overrides: () => [
        scanAssessmentProvider(request).overrideWith(
          (ref) async => assessment(verdicts, exact: exact),
        ),
      ],
      devices: const [GoldenDevice.phone],
      textScales: const [1.0],
    );
  }
}
