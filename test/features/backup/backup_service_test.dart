import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/collection/ownership_service.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/sync/collection_records.dart';
import 'package:movie_shelf/features/backup/data/backup_service.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

void main() {
  late AppDatabase source;
  late Directory documents;
  late BackupService backup;

  setUp(() async {
    source = AppDatabase(NativeDatabase.memory());
    documents = await Directory.systemTemp.createTemp('movieshelf-backup');
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
