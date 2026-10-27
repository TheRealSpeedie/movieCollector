import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../editions/data/copy_repository.dart';
import '../../watch/application/watch_providers.dart';
import '../data/personal_state_repository.dart';

/// Watched, rating and, for wishlist titles, the price limit and the
/// edition the user is looking for.
class PersonalSection extends ConsumerWidget {
  const PersonalSection({
    super.key,
    required this.subject,
    this.onWishlist = false,
    this.editions = const [],
  });

  final Subject subject;
  final bool onWishlist;

  /// Known editions, offered as the preferred one on the wishlist.
  final List<EditionWithCopies> editions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalStateProvider(subject)).valueOrNull;
    final repository = ref.read(personalStateRepositoryProvider);
    final watched = state?.watchStatus == 'watched';
    final count = state?.watchCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Persönlich', style: Theme.of(context).textTheme.titleMedium),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Gesehen'),
          subtitle: Text(
            count == 0
                ? 'Noch nicht gesehen'
                : '$count× gesehen'
                      '${state?.lastWatchedAt != null ? ', zuletzt am ${DateFormat('dd.MM.yyyy').format(state!.lastWatchedAt!)}' : ''}',
          ),
          value: watched,
          onChanged: (value) => repository.setWatched(subject, value),
        ),
        if (watched)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => repository.setWatched(subject, true),
              icon: const Icon(Icons.replay),
              label: const Text('Nochmal gesehen'),
            ),
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('Bewertung'),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                children: [
                  for (var star = 1; star <= 5; star++)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: '${star * 2} von 10',
                      onPressed: () {
                        final value = star * 2;
                        repository.setRating(
                          subject,
                          state?.rating == value ? null : value,
                        );
                      },
                      icon: Icon(
                        (state?.rating ?? 0) >= star * 2
                            ? Icons.star
                            : (state?.rating ?? 0) == star * 2 - 1
                            ? Icons.star_half
                            : Icons.star_border,
                        color: AppColors.amber,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (onWishlist) ...[
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.euro),
            title: const Text('Höchstpreis'),
            subtitle: Text(
              state?.maxPrice == null
                  ? 'Nicht festgelegt'
                  : '${state!.maxPrice!.toStringAsFixed(2)} €',
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () async {
              final price = await _askPrice(context, state?.maxPrice);
              if (price == null) return;
              await repository.setMaxPrice(subject, price < 0 ? null : price);
            },
          ),
          if (editions.isNotEmpty)
            DropdownButtonFormField<String?>(
              initialValue: state?.preferredEditionUuid,
              decoration: const InputDecoration(labelText: 'Gesuchte Ausgabe'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Egal')),
                for (final e in editions)
                  DropdownMenuItem(value: e.edition.uuid, child: Text(e.label)),
              ],
              onChanged: (uuid) =>
                  repository.setPreferredEdition(subject, uuid),
            ),
        ],
      ],
    );
  }

  /// Returns the price, -1 to clear, or null when cancelled.
  static Future<double?> _askPrice(BuildContext context, double? current) {
    final controller = TextEditingController(
      text: current?.toStringAsFixed(2) ?? '',
    );
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Höchstpreis'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: '€'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, -1.0),
            child: const Text('Entfernen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              double.tryParse(controller.text.replaceAll(',', '.')),
            ),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
