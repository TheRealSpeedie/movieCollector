import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/widgets/status_chip.dart';

void main() {
  Future<void> pumpChip(WidgetTester tester, CollectionStatus status) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StatusChip(status: status)),
      ),
    );
  }

  testWidgets('shows the German label for each status', (tester) async {
    await pumpChip(tester, CollectionStatus.owned);
    expect(find.text('Gekauft'), findsOneWidget);

    await pumpChip(tester, CollectionStatus.wishlist);
    expect(find.text('Wunschliste'), findsOneWidget);

    await pumpChip(tester, CollectionStatus.open);
    expect(find.text('Offen'), findsOneWidget);
  });

  testWidgets('MissingChip shows the fehlt label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MissingChip())),
    );
    expect(find.text('Fehlt'), findsOneWidget);
  });
}
