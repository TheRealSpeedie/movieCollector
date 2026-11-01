import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/core/collection/ownership_service.dart';
import 'package:speednema/core/database/app_database.dart';
import 'package:speednema/shared/models/collection_status.dart';

/// Marking a film as owned without choosing a format uses the preferred
/// one; paths without a person deciding (sync, restore) never invent one.
void main() {
  late AppDatabase db;
  late int movieId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    movieId = await db
        .into(db.movies)
        .insert(MoviesCompanion.insert(title: 'Arrival', tmdbId: const Value(1)));
  });

  tearDown(() => db.close());

  Future<String> editionFormat() async =>
      (await db.select(db.physicalEditions).getSingle()).format;

  test('owned without a format gets the preferred one', () async {
    await OwnershipService(db, defaultFormat: () => 'bluray')
        .setMovieStatus(movieId, CollectionStatus.owned);
    expect(await editionFormat(), 'bluray');
  });

  test('without a preference the format stays unknown', () async {
    await OwnershipService(db, defaultFormat: () => null)
        .setMovieStatus(movieId, CollectionStatus.owned);
    expect(await editionFormat(), 'unknown');
  });

  test('sync and restore (no default) never invent a format', () async {
    await OwnershipService(db).setMovieStatus(movieId, CollectionStatus.owned);
    expect(await editionFormat(), 'unknown');
  });
}
