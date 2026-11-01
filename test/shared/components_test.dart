import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/shared/models/collection_status.dart';
import 'package:speednema/shared/widgets/media_card.dart';
import 'package:speednema/shared/widgets/settings_group.dart';
import 'package:speednema/shared/widgets/skeleton.dart';
import 'package:speednema/shared/widgets/status_view.dart';

import '../support/golden_harness.dart';
import 'component_gallery.dart';

void main() {
  for (final appearance in Brightness.values) {
    testWidgets('components meet tap target, label and contrast guidelines '
        '(${appearance.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(
        tester,
        const ComponentGallery(),
        brightness: appearance,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }

  testWidgets('a media card says its status, not only with colour', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpScreen(
      tester,
      const Scaffold(
        body: SizedBox(
          width: 120,
          child: MediaCard(
            title: 'Arrival',
            subtitle: '2016',
            status: CollectionStatus.wishlist,
            badge: MediaBadge.playable(),
          ),
        ),
      ),
    );
    expect(
      find.bySemanticsLabel(
        'Arrival, 2016, ${CollectionStatus.wishlist.germanLabel}, '
        'Auf deinem Server abspielbar',
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('the whole settings row toggles, not only the switch', (
    tester,
  ) async {
    var value = false;
    await pumpScreen(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: SettingsTile.toggle(
            icon: Icons.subtitles_outlined,
            title: 'Untertitel',
            toggle: value,
            onToggle: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Untertitel'));
    await tester.pump();
    expect(value, isTrue);
  });

  testWidgets('a status view offers its actions', (tester) async {
    var retried = 0;
    await pumpScreen(
      tester,
      Scaffold(
        body: StatusView(
          kind: StatusKind.noNetwork,
          title: 'Keine Internetverbindung',
          primary: StatusAction('Erneut versuchen', () => retried++),
        ),
      ),
    );
    await tester.tap(find.text('Erneut versuchen'));
    expect(retried, 1);
  });

  testWidgets('skeletons hold still when reduced motion is on', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Skeleton(child: SkeletonBox(width: 10, height: 10)),
        ),
      ),
    );
    // A running pulse would never settle.
    await tester.pumpAndSettle();
    final fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
    expect(fade.opacity.value, 1);
  });

  screenGoldens(
    'components',
    () => const ComponentGallery(),
    devices: const [GoldenDevice.phone],
  );
}
