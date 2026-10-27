import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/collection/ownership_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/collection_records.dart';

class BackupException implements Exception {
  const BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Counts of an export or of the collection, per record type.
typedef RecordCounts = Map<String, int>;

/// Export, encrypted backup and restore of the whole collection.
///
/// An export is the set of sync records (see CollectionRecords), so it carries
/// stable UUIDs: importing it again, on this or another device, merges instead
/// of duplicating.
class BackupService {
  BackupService(this._db, {Future<Directory> Function()? documents})
    : _records = CollectionRecords(_db),
      _documents = documents ?? getApplicationDocumentsDirectory;

  static const format = 'movieshelf-export';
  static const encryptedFormat = 'movieshelf-backup';
  static const version = 1;
  static const _keepSnapshots = 5;

  final AppDatabase _db;
  final CollectionRecords _records;
  final Future<Directory> Function() _documents;

  Future<Map<String, Object?>> exportJson() async {
    final records = await _records.buildAll();
    return {
      'format': format,
      'version': version,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'records': [
        for (final r in records.values)
          {'type': r.type, 'uuid': r.uuid, 'fields': r.fields},
      ],
    };
  }

  static RecordCounts countRecords(Map<String, Object?> export) {
    final counts = <String, int>{};
    for (final r in export['records'] as List) {
      final type = (r as Map)['type'] as String;
      counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts;
  }

  Future<RecordCounts> currentCounts() async {
    final counts = <String, int>{};
    for (final r in (await _records.buildAll()).values) {
      counts[r.type] = (counts[r.type] ?? 0) + 1;
    }
    return counts;
  }

  /// One row per owned copy, for spreadsheets.
  Future<String> exportCsv() async {
    final rows = await _db.customSelect('''
SELECT COALESCE(m.title, s.name) AS title,
       COALESCE(m.release_year, NULL) AS year,
       ts.season_number AS season,
       e.format, e.product_title, e.edition_name, e.region,
       c.quantity, c.condition, c.storage_location, c.purchase_date, c.purchase_price, c.notes,
       (SELECT GROUP_CONCAT(b.barcode, ' ') FROM barcodes b WHERE b.physical_edition_id = e.id) AS barcodes
FROM owned_copies c
JOIN physical_editions e ON e.id = c.edition_id
LEFT JOIN physical_edition_movies em ON em.edition_id = e.id
LEFT JOIN movies m ON m.id = em.movie_id
LEFT JOIN physical_edition_tv_seasons es ON es.edition_id = e.id
LEFT JOIN tv_seasons ts ON ts.id = es.season_id
LEFT JOIN tv_series s ON s.id = ts.series_id
ORDER BY title, season
''').get();
    String cell(Object? value) {
      if (value == null) return '';
      final text = value is int && value > 100000000000
          ? DateTime.fromMillisecondsSinceEpoch(value).toIso8601String()
          : '$value';
      return text.contains(RegExp('[;"\n]'))
          ? '"${text.replaceAll('"', '""')}"'
          : text;
    }

    final buffer = StringBuffer(
      'Titel;Jahr;Staffel;Format;Produkt;Edition;Region;Anzahl;Zustand;'
      'Standort;Gekauft am;Preis;Notizen;Barcodes\n',
    );
    for (final r in rows) {
      buffer.writeln(
        [
          r.data['title'],
          r.data['year'],
          r.data['season'],
          r.data['format'],
          r.data['product_title'],
          r.data['edition_name'],
          r.data['region'],
          r.data['quantity'],
          r.data['condition'],
          r.data['storage_location'],
          r.data['purchase_date'],
          r.data['purchase_price'],
          r.data['notes'],
          r.data['barcodes'],
        ].map(cell).join(';'),
      );
    }
    return buffer.toString();
  }

  /// Encrypts an export with a key derived from [password] (Argon2id) using
  /// AES-256-GCM. Without the password the file cannot be read.
  Future<String> encrypt(Map<String, Object?> export, String password) async {
    if (password.length < 8) {
      throw const BackupException(
        'Das Passwort muss mindestens 8 Zeichen lang sein.',
      );
    }
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final kdf = _kdf();
    final key = await kdf.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final box = await AesGcm.with256bits().encrypt(
      utf8.encode(jsonEncode(export)),
      secretKey: key,
    );
    return jsonEncode({
      'format': encryptedFormat,
      'version': version,
      'kdf': {
        'name': 'argon2id',
        'memory': kdf.memory,
        'iterations': kdf.iterations,
        'parallelism': kdf.parallelism,
        'salt': base64Encode(salt),
      },
      'nonce': base64Encode(box.nonce),
      'mac': base64Encode(box.mac.bytes),
      'data': base64Encode(box.cipherText),
    });
  }

  /// Reads a plain export or an encrypted backup.
  Future<Map<String, Object?>> read(String content, {String? password}) async {
    final Map<String, Object?> json;
    try {
      json = Map<String, Object?>.from(jsonDecode(content) as Map);
    } on FormatException {
      throw const BackupException('Die Datei ist keine Movie-Shelf-Sicherung.');
    }
    if (json['format'] == format) return json;
    if (json['format'] != encryptedFormat) {
      throw const BackupException('Die Datei ist keine Movie-Shelf-Sicherung.');
    }
    if (password == null) {
      throw const BackupException('Diese Sicherung braucht ein Passwort.');
    }
    final kdfJson = Map<String, Object?>.from(json['kdf'] as Map);
    final kdf = Argon2id(
      memory: kdfJson['memory'] as int,
      iterations: kdfJson['iterations'] as int,
      parallelism: kdfJson['parallelism'] as int,
      hashLength: 32,
    );
    final key = await kdf.deriveKeyFromPassword(
      password: password,
      nonce: base64Decode(kdfJson['salt'] as String),
    );
    try {
      final clear = await AesGcm.with256bits().decrypt(
        SecretBox(
          base64Decode(json['data'] as String),
          nonce: base64Decode(json['nonce'] as String),
          mac: Mac(base64Decode(json['mac'] as String)),
        ),
        secretKey: key,
      );
      return Map<String, Object?>.from(jsonDecode(utf8.decode(clear)) as Map);
    } on SecretBoxAuthenticationError {
      throw const BackupException(
        'Das Passwort ist falsch oder die Datei ist beschädigt.',
      );
    }
  }

  /// Imports an export. Merge keeps everything that exists and adds or
  /// updates records from the file; replace makes the collection equal to it.
  /// A snapshot of the current collection is saved first.
  Future<void> restore(
    Map<String, Object?> export, {
    required bool replace,
  }) async {
    if (export['format'] != format || (export['version'] as int) > version) {
      throw const BackupException(
        'Diese Sicherung stammt aus einer neueren Version von Movie Shelf.',
      );
    }
    await saveSnapshot('vor-wiederherstellung');
    final incoming = [
      for (final r in export['records'] as List)
        SyncRecord(
          (r as Map)['type'] as String,
          r['uuid'] as String,
          Map<String, Object?>.from(r['fields'] as Map),
        ),
    ];
    await _db.transaction(() async {
      final local = await _records.buildAll();
      final ids = {for (final r in incoming) r.uuid};
      final removed = replace
          ? [
              for (final r in local.values)
                if (!ids.contains(r.uuid)) (type: r.type, uuid: r.uuid),
            ]
          : <({String type, String uuid})>[];
      await _records.apply(incoming, removed, local);
      await OwnershipService(_db).recompute();
    });
  }

  /// Saves the collection to the app's private snapshot folder and returns
  /// the file. Used before migrations and restores so they can be undone.
  Future<File> saveSnapshot(String reason) async {
    final folder = Directory(p.join((await _documents()).path, 'snapshots'));
    await folder.create(recursive: true);
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(folder.path, 'snapshot-$stamp-$reason.json'));
    await file.writeAsString(jsonEncode(await exportJson()));
    final all = await listSnapshots();
    for (final old in all.skip(_keepSnapshots)) {
      await old.delete();
    }
    return file;
  }

  Future<List<File>> listSnapshots() async {
    final folder = Directory(p.join((await _documents()).path, 'snapshots'));
    if (!await folder.exists()) return [];
    final files = await folder
        .list()
        .where((e) => e is File)
        .cast<File>()
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  /// Fast enough on phones, strong against guessing. Stored in the file so
  /// the parameters can change later.
  static Argon2id _kdf() => Argon2id(
    memory: 19 * 1024,
    iterations: 2,
    parallelism: 1,
    hashLength: 32,
  );
}
