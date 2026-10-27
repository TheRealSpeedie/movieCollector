import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/providers/core_providers.dart';
import 'package:movie_shelf/core/providers/shared_preferences_provider.dart';
import 'package:movie_shelf/core/sync/sync_provider.dart';
import 'package:movie_shelf/features/backup/application/backup_providers.dart';
import 'package:movie_shelf/features/backup/data/backup_service.dart';
import 'package:movie_shelf/features/cloud/application/cloud_providers.dart';
import 'package:movie_shelf/features/settings/application/settings_providers.dart';
import 'package:movie_shelf/features/settings/data/settings_repository.dart';
import 'package:movie_shelf/features/sync/application/storage_migration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/sync/sync_engine_test.dart' show Device, FakeServer;

void main() {
  late Directory documents;
  late FakeServer cloud;
  late Device phone;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    documents = await Directory.systemTemp.createTemp('cloud-migration');
    cloud = FakeServer();
    phone = Device(cloud);
  });

  tearDown(() async {
    await phone.db.close();
    await documents.delete(recursive: true);
  });

  Future<ProviderContainer> container({
    CollectionSyncProvider? signedIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(phone.db),
        backupServiceProvider.overrideWithValue(
          BackupService(phone.db, documents: () async => documents),
        ),
        cloudSyncProvider.overrideWithValue(signedIn),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('moving to the cloud transfers, verifies and then switches', () async {
    await phone.own(603);
    await phone.own(604);
    final c = await container(signedIn: cloud);

    await c.read(storageMigrationProvider).migrate(CollectionStorage.cloud);

    expect(c.read(collectionStorageProvider), CollectionStorage.cloud);
    expect((await cloud.snapshot()).counts['title'], 2);
  });

  test('without a cloud account nothing switches', () async {
    await phone.own(603);
    final c = await container();

    await expectLater(
      c.read(storageMigrationProvider).migrate(CollectionStorage.cloud),
      throwsA(
        isA<MigrationException>().having(
          (e) => e.message,
          'message',
          contains('Movie Shelf Cloud'),
        ),
      ),
    );
    expect(c.read(collectionStorageProvider), CollectionStorage.local);
    expect(await phone.db.select(phone.db.movies).get(), hasLength(1));
  });
}
