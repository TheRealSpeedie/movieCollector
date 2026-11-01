import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speednema/app/app_shell.dart';
import 'package:speednema/app/theme/app_theme.dart';

import '../support/golden_harness.dart';

/// The shell: same five sections at every width, bottom bar on phones,
/// rail from 600, extended rail from 1200. Tab state survives switching.
void main() {
  const names = ['Home', 'Sammlung', 'Entdecken', 'Fundstück', 'Mehr'];

  GoRouter router() => GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          for (final name in names)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/${name.toLowerCase()}',
                  builder: (context, _) => Scaffold(
                    appBar: AppBar(title: Text('$name-Seite')),
                    body: Center(
                      child: TextButton(
                        onPressed: () => context.go(
                          '/${name.toLowerCase()}/detail',
                        ),
                        child: Text('$name öffnen'),
                      ),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'detail',
                      builder: (_, _) => Scaffold(
                        appBar: AppBar(title: Text('$name-Detail')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    ],
  );

  Future<void> pumpAt(WidgetTester tester, double width) async {
    tester.view
      ..physicalSize = Size(width, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: router(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final (width, bar, rail, extended) in [
    (390.0, true, false, false),
    (800.0, false, true, false),
    (1280.0, false, true, true),
  ]) {
    testWidgets('at ${width.toInt()} px the navigation adapts', (tester) async {
      await pumpAt(tester, width);
      expect(find.byType(NavigationBar), bar ? findsOneWidget : findsNothing);
      expect(find.byType(NavigationRail), rail ? findsOneWidget : findsNothing);
      if (rail) {
        final r = tester.widget<NavigationRail>(find.byType(NavigationRail));
        expect(r.extended, extended);
        // "+" lives in the rail on wide layouts.
        expect(find.byTooltip('Hinzufügen'), extended ? findsNothing : findsOneWidget);
        if (extended) expect(find.text('Hinzufügen'), findsOneWidget);
      }
      for (final name in names) {
        expect(find.text(name), findsWidgets);
      }
    });
  }

  testWidgets('switching tabs keeps where each one was; tapping again returns to its start', (
    tester,
  ) async {
    await pumpAt(tester, 390);
    await tester.tap(find.text('Sammlung'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sammlung öffnen'));
    await tester.pumpAndSettle();
    expect(find.text('Sammlung-Detail'), findsOneWidget);

    await tester.tap(find.text('Mehr'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sammlung'));
    await tester.pumpAndSettle();
    expect(find.text('Sammlung-Detail'), findsOneWidget);

    await tester.tap(find.text('Sammlung'));
    await tester.pumpAndSettle();
    expect(find.text('Sammlung-Seite'), findsOneWidget);
  });

  for (final device in GoldenDevice.values) {
    for (final appearance in Brightness.values) {
      testWidgets('shell, ${appearance.name}, ${device.name}', (tester) async {
        final loaded = await tester.runAsync(loadAppFonts) ?? false;
        if (!loaded) return markTestSkipped('SDK fonts not found');
        tester.view
          ..physicalSize = device.size
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: appearance == Brightness.dark
                  ? AppTheme.dark
                  : AppTheme.light,
              routerConfig: router(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/shell_${appearance.name}_${device.name}.png',
          ),
        );
      }, tags: ['golden']);
    }
  }
}
