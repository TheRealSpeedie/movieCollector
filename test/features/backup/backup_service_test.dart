import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/core/collection/ownership_service.dart';
import 'package:speednema/core/database/app_database.dart';
import 'package:speednema/core/sync/collection_records.dart';
import 'package:speednema/features/backup/data/backup_service.dart';
import 'package:speednema/shared/models/collection_status.dart';

void main() {
  late AppDatabase source;
  late Directory documents;
  late BackupService backup;

  setUp(() async {
    source = AppDatabase(NativeDatabase.memory());
    documents = await Directory.systemTemp.createTemp('speednema-backup');
    backup = BackupService(source, documents: () async => documents);
    for (final (tmdbId, status) in [
      (603, CollectionStatus.owned),
      (604, CollectionStatus.wishlist),
    ]) {
      final id = await source
          .into(source.movies)
          .insert(
            MoviesCompanion.insert(
              title: 'Film $tmdbId',
              tmdbId: Value(tmdbId),
            ),
          );
      await OwnershipService(source).setMovieStatus(id, status);
    }
  });

  tearDown(() async {
    await source.close();
    await documents.delete(recursive: true);
  });

  test('an encrypted backup restores the same collection elsewhere', () async {
    final file = await backup.encrypt(
      await backup.exportJson(),
      'richtig langes passwort',
    );
    expect(file, isNot(contains('Film 603')));

    final target = AppDatabase(NativeDatabase.memory());
    addTearDown(target.close);
    final restore = BackupService(target, documents: () async => documents);
    await restore.restore(
      await restore.read(file, password: 'richtig langes passwort'),
      replace: false,
    );

    final before = await CollectionRecords(source).buildAll();
    final after = await CollectionRecords(target).buildAll();
    expect(after.keys.toSet(), before.keys.toSet());
    final movies = {
      for (final m in await target.select(target.movies).get())
        m.tmdbId: m.userStatus,
    };
    expect(movies, {
      603: CollectionStatus.owned,
      604: CollectionStatus.wishlist,
    });
  });

  group('backups from before the rename to Speednema', () {
    Future<void> expectRestores(Map<String, Object?> export) async {
      final target = AppDatabase(NativeDatabase.memory());
      addTearDown(target.close);
      final restore = BackupService(target, documents: () async => documents);
      await restore.restore(export, replace: false);
      final titles = {
        for (final m in await target.select(target.movies).get()) m.title,
      };
      expect(titles, {'Film 603', 'Film 604'});
    }

    test('a plain movieshelf-export still restores', () async {
      final legacy = {
        ...await backup.exportJson(),
        'format': BackupService.legacyFormat,
      };
      final read = await backup.read(jsonEncode(legacy));
      await expectRestores(read);
    });

    test('an encrypted movieshelf-backup still restores', () async {
      final file = Map<String, Object?>.from(
        jsonDecode(
              await backup.encrypt({
                ...await backup.exportJson(),
                'format': BackupService.legacyFormat,
              }, 'richtig langes passwort'),
            )
            as Map,
      )..['format'] = BackupService.legacyEncryptedFormat;
      final read = await backup.read(
        jsonEncode(file),
        password: 'richtig langes passwort',
      );
      await expectRestores(read);
    });

    test('a foreign file is called foreign, not newer', () async {
      await expectLater(
        backup.restore({
          'format': 'something-else',
          'version': 1,
          'records': [],
        }, replace: false),
        throwsA(
          isA<BackupException>().having(
            (e) => e.message,
            'message',
            contains('keine Speednema-Sicherung'),
          ),
        ),
      );
    });
  });

  test('a wrong password is reported, not a broken collection', () async {
    final file = await backup.encrypt(
      await backup.exportJson(),
      'passwort-eins',
    );
    await expectLater(
      backup.read(file, password: 'passwort-zwei'),
      throwsA(isA<BackupException>()),
    );
  });

  test(
    'replace removes what the backup does not contain and keeps a snapshot',
    () async {
      final export = await backup.exportJson();
      final extra = await source
          .into(source.movies)
          .insert(
            MoviesCompanion.insert(title: 'Neu', tmdbId: const Value(999)),
          );
      await OwnershipService(
        source,
      ).setMovieStatus(extra, CollectionStatus.owned);

      await backup.restore(export, replace: true);

      final tmdbIds = [
        for (final m in await source.select(source.movies).get()) m.tmdbId,
      ];
      expect(tmdbIds, unorderedEquals([603, 604]));
      expect(await backup.listSnapshots(), hasLength(1));
    },
  );

  test('merge keeps what the backup does not contain', () async {
    final export = await backup.exportJson();
    await source
        .into(source.movies)
        .insert(MoviesCompanion.insert(title: 'Neu', tmdbId: const Value(999)));

    await backup.restore(export, replace: false);

    expect(await source.select(source.movies).get(), hasLength(3));
  });

  test('the CSV lists one row per owned copy', () async {
    final csv = await backup.exportCsv();
    final lines = csv.trim().split('\n');
    expect(lines, hasLength(2));
    expect(lines[1], startsWith('Film 603;'));
  });
}
