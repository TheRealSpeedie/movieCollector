import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/media_format.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../../household/application/household_providers.dart';
import '../application/catalog_providers.dart';
import '../data/edition_catalog.dart';
import '../../watch/application/watch_providers.dart';
import '../data/copy_repository.dart';

const _conditions = ['Neu', 'Sehr gut', 'Gut', 'Gebraucht', 'Beschädigt'];

/// "Meine Exemplare": the editions of a film and the copies the user owns,
/// with format, condition, location and price.
class CopiesSection extends ConsumerWidget {
  const CopiesSection({super.key, required int this.movieId}) : seasonId = null;

  const CopiesSection.season({super.key, required int this.seasonId})
    : movieId = null;

  final int? movieId;
  final int? seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editions =
        (movieId != null
                ? ref.watch(movieEditionsProvider(movieId!))
                : ref.watch(seasonEditionsProvider(seasonId!)))
            .valueOrNull ??
        const [];
    final repository = ref.read(copyRepositoryProvider);
    // In a household, copies of others show who owns them and cannot be
    // changed here.
    final household = ref.watch(householdProvider).valueOrNull;
    final shared = household?.shared ?? false;
    final catalog = movieId == null ? null : ref.watch(editionCatalogProvider);
    final names = {
      for (final m in household?.members ?? const []) '${m.id}': m.name,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Meine Exemplare',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: () => _addEdition(context, repository),
              icon: const Icon(Icons.add),
              label: const Text('Ausgabe'),
            ),
          ],
        ),
        if (editions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Noch keine Ausgabe erfasst.',
              style: TextStyle(color: AppColors.neutralGray),
            ),
          ),
        for (final e in editions)
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              [
                                if (e.edition.region != null)
                                  'Region ${e.edition.region}',
                                if (e.edition.audioLanguages != null)
                                  'Ton ${e.edition.audioLanguages}',
                                if (e.edition.subtitleLanguages != null)
                                  'UT ${e.edition.subtitleLanguages}',
                                if (e.edition.catalogId != null)
                                  'aus dem Katalog',
                                _ownership(e.copies),
                              ].join(' · '),
                              style: const TextStyle(
                                color: AppColors.neutralGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (catalog != null)
                        IconButton(
                          tooltip: 'Ausgabe im Katalog teilen',
                          icon: const Icon(Icons.ios_share),
                          onPressed: () => _share(
                            context,
                            repository,
                            catalog,
                            e.edition.id,
                          ),
                        ),
                      IconButton(
                        tooltip: 'Ausgabe bearbeiten',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            _editEdition(context, repository, e.edition),
                      ),
                    ],
                  ),
                  for (final copy in e.copies)
                    copy.ownerId != null
                        ? ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.album_outlined),
                            title: Text(
                              '${_copyTitle(copy)} · gehört '
                              '${names[copy.ownerId] ?? 'jemand anderem im Haushalt'}',
                            ),
                            subtitle: Text(_copyDetails(copy, own: false)),
                            trailing: const Tooltip(
                              message:
                                  'Nur die Besitzerin oder der Besitzer kann es ändern',
                              child: Icon(Icons.lock_outline, size: 18),
                            ),
                          )
                        : ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              copy.isPrivate
                                  ? Icons.visibility_off_outlined
                                  : Icons.album_outlined,
                            ),
                            title: Text(
                              [
                                _copyTitle(copy),
                                if (shared) copy.isPrivate ? 'privat' : 'deins',
                              ].join(' · '),
                            ),
                            subtitle: Text(_copyDetails(copy)),
                            trailing: IconButton(
                              tooltip: 'Exemplar bearbeiten',
                              icon: const Icon(Icons.more_vert),
                              onPressed: () =>
                                  _editCopy(context, repository, copy, shared),
                            ),
                          ),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: () => repository.addCopy(e.edition.id),
                        icon: const Icon(Icons.add),
                        label: Text(
                          e.copies.every((c) => c.ownerId != null)
                              ? 'Besitze ich'
                              : 'Weiteres Exemplar',
                        ),
                      ),
                      if (e.copies.isEmpty)
                        TextButton(
                          onPressed: () async {
                            final removed = await repository
                                .removeEditionIfUnused(e.edition.id);
                            if (!removed && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ausgaben mit Barcode bleiben erhalten, damit der Scanner sie wiedererkennt.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Ausgabe entfernen'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Shares the release facts with the catalog after showing exactly what
  /// is sent. Copies, prices and notes stay private.
  Future<void> _share(
    BuildContext context,
    CopyRepository repository,
    EditionCatalog catalog,
    int editionId,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final entry = await repository.catalogEntryFor(editionId, movieId!);
    if (entry == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Nur Filme mit TMDB-Eintrag lassen sich teilen.'),
        ),
      );
      return;
    }
    if (!context.mounted) return;
    final sent = [
      '${entry.title}${entry.year == null ? '' : ' (${entry.year})'}',
      entry.format.label,
      if (entry.editionName != null) entry.editionName!,
      if (entry.region != null) 'Region ${entry.region}',
      if (entry.audioLanguages != null) 'Ton ${entry.audioLanguages}',
      if (entry.subtitleLanguages != null)
        'Untertitel ${entry.subtitleLanguages}',
      if (entry.publisher != null) entry.publisher!,
      if (entry.barcodes.isNotEmpty) 'Barcode ${entry.barcodes.join(', ')}',
    ];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ausgabe teilen?'),
        content: Text(
          'An ${catalog.name} geht nur diese Beschreibung der '
          'Veröffentlichung, damit andere sie wiedererkennen:\n\n'
          '${sent.join('\n')}\n\n'
          'Nicht gesendet: deine Exemplare, Preise, Notizen und wem sie gehören.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Teilen'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final saved = await catalog.submit(
        entry,
        replaces: entry.id.isEmpty ? null : entry.id,
      );
      await repository.linkCatalog(editionId, saved.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            saved.pending
                ? 'Danke! Die Ausgabe wird geprüft und dann für alle sichtbar.'
                : 'Danke! Die Ausgabe ist jetzt im Katalog.',
          ),
        ),
      );
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
    }
  }

  /// Who has this edition: the person, others in the household, or nobody.
  static String _ownership(List<OwnedCopyRow> copies) {
    final mine = copies.where((c) => c.ownerId == null).length;
    final others = copies.length - mine;
    if (copies.isEmpty) return 'Nicht in der Sammlung';
    return [
      if (mine > 0) 'Du besitzt $mine',
      if (others > 0) 'im Haushalt $others',
    ].join(', ');
  }

  static String _copyTitle(OwnedCopyRow copy) => [
    if (copy.quantity > 1) '${copy.quantity}×',
    copy.condition ?? 'Zustand nicht erfasst',
  ].join(' ');

  static String _copyDetails(OwnedCopyRow copy, {bool own = true}) {
    final parts = [
      if (copy.storageLocation != null) copy.storageLocation!,
      if (copy.purchasePrice != null)
        '${copy.purchasePrice!.toStringAsFixed(2)} €',
      if (copy.purchaseDate != null)
        'gekauft ${DateFormat('dd.MM.yyyy').format(copy.purchaseDate!)}',
      if (copy.notes != null) copy.notes!,
    ];
    if (parts.isEmpty) return own ? 'Antippen zum Ergänzen' : 'Keine Angaben';
    return parts.join(' · ');
  }

  Future<void> _addEdition(
    BuildContext context,
    CopyRepository repository,
  ) async {
    var format = MediaFormat.bluray;
    final name = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ausgabe hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<MediaFormat>(
                initialValue: format,
                decoration: const InputDecoration(labelText: 'Format'),
                items: [
                  for (final f in MediaFormat.values)
                    DropdownMenuItem(value: f, child: Text(f.label)),
                ],
                onChanged: (f) => setState(() => format = f ?? format),
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Edition (optional, z. B. Steelbook)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Besitze ich'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final editionName = name.text.trim().isEmpty ? null : name.text.trim();
    if (movieId != null) {
      await repository.addMovieEdition(
        movieId!,
        format: format,
        editionName: editionName,
      );
    } else {
      await repository.addSeasonEdition(
        seasonId!,
        format: format,
        editionName: editionName,
      );
    }
  }

  Future<void> _editEdition(
    BuildContext context,
    CopyRepository repository,
    PhysicalEditionRow edition,
  ) async {
    var format = MediaFormat.fromName(edition.format);
    final name = TextEditingController(text: edition.editionName);
    final region = TextEditingController(text: edition.region);
    final audio = TextEditingController(text: edition.audioLanguages);
    final subtitles = TextEditingController(text: edition.subtitleLanguages);
    final publisher = TextEditingController(text: edition.publisher);
    String? text(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<MediaFormat>(
                  initialValue: format,
                  decoration: const InputDecoration(labelText: 'Format'),
                  items: [
                    for (final f in MediaFormat.values)
                      DropdownMenuItem(value: f, child: Text(f.label)),
                  ],
                  onChanged: (f) => setState(() => format = f ?? format),
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Edition'),
                ),
                TextField(
                  controller: region,
                  decoration: const InputDecoration(
                    labelText: 'Region (z. B. B oder 2)',
                  ),
                ),
                TextField(
                  controller: audio,
                  decoration: const InputDecoration(
                    labelText: 'Tonspuren (z. B. de, en)',
                  ),
                ),
                TextField(
                  controller: subtitles,
                  decoration: const InputDecoration(labelText: 'Untertitel'),
                ),
                TextField(
                  controller: publisher,
                  decoration: const InputDecoration(
                    labelText: 'Label / Vertrieb',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Speichern'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirmed != true) return;
    await repository.updateEdition(
      edition.id,
      PhysicalEditionsCompanion(
        format: Value(format.name),
        editionName: Value(text(name)),
        region: Value(text(region)),
        audioLanguages: Value(text(audio)),
        subtitleLanguages: Value(text(subtitles)),
        publisher: Value(text(publisher)),
      ),
    );
  }

  Future<void> _editCopy(
    BuildContext context,
    CopyRepository repository,
    OwnedCopyRow copy,
    bool shared,
  ) async {
    var condition = copy.condition;
    var isPrivate = copy.isPrivate;
    var purchaseDate = copy.purchaseDate;
    final location = TextEditingController(text: copy.storageLocation);
    final price = TextEditingController(
      text: copy.purchasePrice?.toStringAsFixed(2),
    );
    final notes = TextEditingController(text: copy.notes);
    final quantity = TextEditingController(text: '${copy.quantity}');

    final action = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: _conditions.contains(condition)
                      ? condition
                      : null,
                  decoration: const InputDecoration(labelText: 'Zustand'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Nicht erfasst'),
                    ),
                    for (final c in _conditions)
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (c) => setState(() => condition = c),
                ),
                TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    labelText: 'Standort (z. B. Regal Wohnzimmer)',
                  ),
                ),
                TextField(
                  controller: price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Kaufpreis',
                    suffixText: '€',
                  ),
                ),
                TextField(
                  controller: quantity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Anzahl'),
                ),
                TextField(
                  controller: notes,
                  decoration: const InputDecoration(labelText: 'Notizen'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Gekauft am'),
                  subtitle: Text(
                    purchaseDate == null
                        ? 'Nicht erfasst'
                        : DateFormat('dd.MM.yyyy').format(purchaseDate!),
                  ),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: purchaseDate ?? DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => purchaseDate = picked);
                  },
                ),
                if (shared)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Nur für mich sichtbar'),
                    subtitle: const Text(
                      'Die anderen im Haushalt sehen dieses Exemplar nicht.',
                    ),
                    value: isPrivate,
                    onChanged: (v) => setState(() => isPrivate = v),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'remove'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                      ),
                      child: const Text('Exemplar entfernen'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, 'save'),
                      child: const Text('Speichern'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (action == 'remove') {
      await repository.removeCopy(copy.id);
      return;
    }
    if (action != 'save') return;
    String? text(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    await repository.updateCopy(
      copy.id,
      OwnedCopiesCompanion(
        condition: Value(condition),
        storageLocation: Value(text(location)),
        purchasePrice: Value(
          double.tryParse((text(price) ?? '').replaceAll(',', '.')),
        ),
        purchaseDate: Value(purchaseDate),
        notes: Value(text(notes)),
        quantity: Value(int.tryParse(quantity.text.trim()) ?? copy.quantity),
        isPrivate: Value(isPrivate),
      ),
    );
  }
}
