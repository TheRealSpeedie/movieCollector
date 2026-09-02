import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/matching/item_selection.dart';

class SelectableListItem {
  const SelectableListItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.isSpecial = false,
  });

  final int id;
  final String title;
  final String? subtitle;
  final bool isSpecial;
}

class SelectableItemList extends StatelessWidget {
  const SelectableItemList({
    super.key,
    required this.items,
    required this.selection,
    required this.onChanged,
    this.showRegularSeasonsAction = false,
    this.singleSelect = false,
  });

  final List<SelectableListItem> items;
  final ItemSelection selection;
  final VoidCallback onChanged;
  final bool showRegularSeasonsAction;
  final bool singleSelect;

  @override
  Widget build(BuildContext context) {
    final ids = items.map((item) => item.id);
    final selectedCount = selection.countOf(ids);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$selectedCount / ${items.length} ausgewählt',
          style: const TextStyle(
            color: AppColors.neutralGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {
                selection.selectAll(ids);
                onChanged();
              },
              child: const Text('Alle auswählen'),
            ),
            OutlinedButton(
              onPressed: () {
                selection.deselectAll();
                onChanged();
              },
              child: const Text('Auswahl aufheben'),
            ),
            if (showRegularSeasonsAction)
              OutlinedButton(
                onPressed: () {
                  selection.selectRegular(ids);
                  onChanged();
                },
                child: const Text('Reguläre Staffeln auswählen'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in items)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: selection.contains(item.id),
            title: Text(item.title),
            subtitle: item.subtitle == null ? null : Text(item.subtitle!),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) {
              if (singleSelect) {
                selection.selectAll([item.id]);
              } else {
                selection.toggle(item.id);
              }
              onChanged();
            },
          ),
      ],
    );
  }
}
