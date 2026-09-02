import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/matching/item_selection.dart';
import 'package:movie_shelf/shared/widgets/selectable_item_list.dart';

void main() {
  testWidgets('select all, deselect all, and regular seasons', (tester) async {
    final selection = ItemSelection([1, 2]);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return SelectableItemList(
                items: const [
                  SelectableListItem(id: 0, title: 'Specials', isSpecial: true),
                  SelectableListItem(id: 1, title: 'Staffel 1'),
                  SelectableListItem(id: 2, title: 'Staffel 2'),
                  SelectableListItem(id: 3, title: 'Staffel 3'),
                ],
                selection: selection,
                showRegularSeasonsAction: true,
                onChanged: () => setState(() {}),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('2 / 4 ausgewählt'), findsOneWidget);

    await tester.tap(find.text('Alle auswählen'));
    await tester.pump();
    expect(find.text('4 / 4 ausgewählt'), findsOneWidget);
    expect(selection.contains(0), isTrue);

    await tester.tap(find.text('Reguläre Staffeln auswählen'));
    await tester.pump();
    expect(find.text('3 / 4 ausgewählt'), findsOneWidget);
    expect(selection.contains(0), isFalse);

    await tester.tap(find.text('Auswahl aufheben'));
    await tester.pump();
    expect(find.text('0 / 4 ausgewählt'), findsOneWidget);
  });
}
