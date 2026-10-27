import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/sync/collection_records.dart';
import '../../../core/sync/sync_provider.dart';
import '../../backup/application/backup_providers.dart';
import '../../backup/data/backup_service.dart';
import '../../server/application/server_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../application/storage_migration.dart';
import '../application/sync_providers.dart';

/// "Daten & Synchronisation": where the collection lives, sync state,
/// conflicts, export, backup and restore.
class SyncScreen extends ConsumerWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(collectionStorageProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Daten & Synchronisation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StorageSection(current: storage),
          if (storage == CollectionStorage.selfHosted) ...[
            const SizedBox(height: 24),
            const _SyncStatusSection(),
          ],
          const _ConflictSection(),
          const SizedBox(height: 24),
          const _BackupSection(),
        ],
      ),
    );
  }
}

class _StorageSection extends ConsumerWidget {
  const _StorageSection({required this.current});

  final CollectionStorage current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasServer = ref.watch(serverClientProvider) != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Speicherort', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        const Text(
          'Deine Sammlung liegt immer vollständig auf diesem Gerät. '
          'Ein Speicherort hält sie zusätzlich zwischen Geräten aktuell.',
        ),
        const SizedBox(height: 8),
        for (final option in CollectionStorage.values)
          Card(
            child: ListTile(
              leading: Icon(
                option == current
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(option.label),
              subtitle: Text(switch (option) {
                CollectionStorage.local =>
                  'Kein Konto, kein Server. Sicherungen machst du selbst.',
                CollectionStorage.selfHosted =>
                  hasServer
                      ? 'Abgleich über deinen Heimserver im eigenen Netzwerk.'
                      : 'Verbinde zuerst einen Movie Shelf Server.',
                CollectionStorage.cloud =>
                  'Bald verfügbar: Abgleich ohne eigenen Server.',
              }),
              enabled:
                  option != current &&
                  option != CollectionStorage.cloud &&
                  (option != CollectionStorage.selfHosted || hasServer),
              onTap: () => _confirmMove(context, ref, option),
            ),
          ),
        if (!hasServer)
          TextButton.icon(
            onPressed: () => context.push('/server'),
            icon: const Icon(Icons.dns_outlined),
            label: const Text('Server verbinden'),
          ),
      ],
    );
  }

  Future<void> _confirmMove(
    BuildContext context,
    WidgetRef ref,
    CollectionStorage target,
  ) async {
    final migration = ref.read(storageMigrationProvider);
    final messenger = ScaffoldMessenger.of(context);
    MigrationPreview preview;
    try {
      preview = await migration.preview(target);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
      return;
    }
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Umziehen: ${target.label}'),
        content: Text(_describe(target, preview)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Umziehen'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text('Sammlung wird übertragen und geprüft …')),
          ],
        ),
      ),
    );
    String message;
    try {
      await migration.migrate(target);
      message = 'Fertig. Speicherort: ${target.label}.';
    } catch (e) {
      message = '$e';
    }
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  static String _describe(CollectionStorage target, MigrationPreview preview) {
    final titles = preview.local[SyncEntityType.title] ?? 0;
    final copies = preview.local[SyncEntityType.copy] ?? 0;
    final base =
        'Vorher wird ein Schnappschuss deiner Sammlung gespeichert. '
        'Auf diesem Gerät wird nichts gelöscht.\n\n'
        '$titles Titel und $copies Exemplare';
    return switch (target) {
      CollectionStorage.local =>
        '$base bleiben hier. Der Abgleich mit anderen Geräten endet.',
      _ =>
        '$base werden übertragen und danach gezählt.'
            '${(preview.remote?[SyncEntityType.title] ?? 0) > 0 ? '\n\nAm Ziel liegen schon ${preview.remote![SyncEntityType.title]} Titel von anderen Geräten. Beide Stände werden zusammengeführt; Widersprüche zeigt Movie Shelf dir an.' : ''}',
    };
  }
}

class _SyncStatusSection extends ConsumerWidget {
  const _SyncStatusSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncControllerProvider);
    final report = sync.valueOrNull;
    return Card(
      child: ListTile(
        leading: sync.isLoading
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(sync.hasError ? Icons.cloud_off : Icons.cloud_done_outlined),
        title: Text(
          sync.hasError
              ? 'Server gerade nicht erreichbar'
              : report == null
              ? 'Noch nicht abgeglichen'
              : 'Abgeglichen ${DateFormat.Hm().format(report.at)}',
        ),
        subtitle: Text(
          sync.hasError
              ? 'Änderungen bleiben auf dem Gerät und werden später übertragen.'
              : report == null
              ? ''
              : '${report.pushed} gesendet, ${report.received} empfangen',
        ),
        trailing: IconButton(
          tooltip: 'Jetzt abgleichen',
          icon: const Icon(Icons.sync),
          onPressed: sync.isLoading
              ? null
              : ref.read(syncControllerProvider.notifier).refresh,
        ),
      ),
    );
  }
}

final _recordsProvider = FutureProvider.autoDispose<Map<String, SyncRecord>>(
  (ref) => CollectionRecords(ref.watch(appDatabaseProvider)).buildAll(),
);

class _ConflictSection extends ConsumerWidget {
  const _ConflictSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conflicts = ref.watch(syncConflictsProvider).valueOrNull ?? [];
    if (conflicts.isEmpty) return const SizedBox.shrink();
    final records = ref.watch(_recordsProvider).valueOrNull ?? {};
    final controller = ref.read(syncControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Widersprüche', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        const Text(
          'Diese Angaben wurden auf zwei Geräten gleichzeitig geändert. '
          'Nichts wird überschrieben, bis du wählst.',
        ),
        const SizedBox(height: 8),
        for (final conflict in conflicts)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _subject(conflict, records),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Dieses Gerät: ${_value(conflict, conflict.localJson)}'),
                  Text(
                    'Anderes Gerät: ${_value(conflict, conflict.serverJson)}',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            controller.resolve(conflict, keepLocal: true),
                        child: const Text('Meins behalten'),
                      ),
                      FilledButton(
                        onPressed: () =>
                            controller.resolve(conflict, keepLocal: false),
                        child: const Text('Anderes übernehmen'),
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

  static const _fieldLabels = {
    'condition': 'Zustand',
    'storageLocation': 'Standort',
    'purchasePrice': 'Preis',
    'purchaseDate': 'Kaufdatum',
    'quantity': 'Anzahl',
    'notes': 'Notizen',
    'onWishlist': 'Wunschliste',
    'rating': 'Bewertung',
    'watchStatus': 'Gesehen',
    'format': 'Format',
    'editionName': 'Edition',
    'maxPrice': 'Höchstpreis',
  };

  static String _subject(
    SyncConflictRow conflict,
    Map<String, SyncRecord> records,
  ) {
    final record = records[conflict.entityUuid];
    final name =
        record?.fields['title'] ??
        record?.fields['productTitle'] ??
        records[record?.fields['editionId']]?.fields['productTitle'] ??
        records[record?.fields['subjectId']]?.fields['title'] ??
        'Eintrag';
    final field = conflict.field == FieldConflict.deletedField
        ? 'gelöscht oder geändert'
        : _fieldLabels[conflict.field] ?? conflict.field;
    return '$name · $field';
  }

  static String _value(SyncConflictRow conflict, String? json) {
    final value = json == null ? null : jsonDecode(json);
    if (conflict.field == FieldConflict.deletedField) {
      return value == true ? 'gelöscht' : 'behalten';
    }
    if (value == null) return 'leer';
    if (value is bool) return value ? 'ja' : 'nein';
    return '$value';
  }
}

class _BackupSection extends ConsumerWidget {
  const _BackupSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export & Sicherung',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Verschlüsselte Sicherung'),
                subtitle: const Text(
                  'Die ganze Sammlung als Datei, geschützt mit deinem Passwort.',
                ),
                onTap: () => _encryptedBackup(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.data_object),
                title: const Text('Export (JSON)'),
                subtitle: const Text(
                  'Lesbar und in jede Movie-Shelf-Installation importierbar.',
                ),
                onTap: () => _share(
                  context,
                  'movieshelf-export.json',
                  () async => jsonEncode(
                    await ref.read(backupServiceProvider).exportJson(),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_outlined),
                title: const Text('Exemplare als Tabelle (CSV)'),
                onTap: () => _share(
                  context,
                  'movieshelf-exemplare.csv',
                  ref.read(backupServiceProvider).exportCsv,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Sicherung einspielen'),
                subtitle: const Text(
                  'Vorher wird automatisch ein Schnappschuss gespeichert.',
                ),
                onTap: () => _restore(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Schnappschüsse'),
                subtitle: const Text(
                  'Automatisch vor jedem Umzug und jeder Wiederherstellung.',
                ),
                onTap: () => _snapshots(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _share(
    BuildContext context,
    String name,
    Future<String> Function() content,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = File(p.join((await getTemporaryDirectory()).path, name));
      await file.writeAsString(await content());
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Export fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _encryptedBackup(BuildContext context, WidgetRef ref) async {
    final password = await _askPassword(context, confirm: true);
    if (password == null || !context.mounted) return;
    final backup = ref.read(backupServiceProvider);
    final stamp = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _share(
      context,
      'movieshelf-$stamp.msbackup',
      () async => backup.encrypt(await backup.exportJson(), password),
    );
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final picked = await FilePicker.pickFiles(withData: true);
    final bytes = picked?.files.single.bytes;
    if (bytes == null || !context.mounted) return;
    final content = utf8.decode(bytes);
    final backup = ref.read(backupServiceProvider);
    try {
      String? password;
      if (content.contains(BackupService.encryptedFormat)) {
        password = await _askPassword(context, confirm: false);
        if (password == null) return;
      }
      final export = await backup.read(content, password: password);
      if (!context.mounted) return;
      final counts = BackupService.countRecords(export);
      final replace = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sicherung einspielen'),
          content: Text(
            'Die Datei enthält ${counts[SyncEntityType.title] ?? 0} Titel und '
            '${counts[SyncEntityType.copy] ?? 0} Exemplare.\n\n'
            'Zusammenführen ergänzt deine Sammlung. Ersetzen macht sie gleich '
            'der Datei; was nur hier existiert, wird entfernt.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ersetzen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Zusammenführen'),
            ),
          ],
        ),
      );
      if (replace == null) return;
      await backup.restore(export, replace: replace);
      messenger.showSnackBar(
        const SnackBar(content: Text('Sicherung eingespielt.')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _snapshots(BuildContext context, WidgetRef ref) async {
    final backup = ref.read(backupServiceProvider);
    final files = await backup.listSnapshots();
    if (!context.mounted) return;
    final chosen = await showModalBottomSheet<File>(
      context: context,
      builder: (context) => SafeArea(
        child: files.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Noch keine Schnappschüsse.'),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final file in files)
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(p.basenameWithoutExtension(file.path)),
                      subtitle: const Text(
                        'Antippen, um diesen Stand wiederherzustellen',
                      ),
                      onTap: () => Navigator.pop(context, file),
                    ),
                ],
              ),
      ),
    );
    if (chosen == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await backup.restore(
        await backup.read(await chosen.readAsString()),
        replace: true,
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Schnappschuss wiederhergestellt.')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<String?> _askPassword(BuildContext context, {required bool confirm}) {
    final controller = TextEditingController();
    final repeat = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Passwort'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (confirm)
              const Text(
                'Ohne dieses Passwort lässt sich die Sicherung nicht öffnen. '
                'Movie Shelf kann es nicht wiederherstellen.',
              ),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Passwort'),
            ),
            if (confirm)
              TextField(
                controller: repeat,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Wiederholen'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.length < 8 ||
                  (confirm && controller.text != repeat.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Mindestens 8 Zeichen, beide Eingaben gleich.',
                    ),
                  ),
                );
                return;
              }
              Navigator.pop(context, controller.text);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
