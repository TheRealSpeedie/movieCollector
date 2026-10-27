import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

/// Which title a personal state belongs to. Exactly one id is set.
typedef Subject = ({int? movieId, int? seriesId, int? seasonId});

Subject movieSubject(int id) => (movieId: id, seriesId: null, seasonId: null);
Subject seriesSubject(int id) => (movieId: null, seriesId: id, seasonId: null);

/// Watch history, rating and wishlist details. The wishlist flag itself is
/// changed through OwnershipService, because it affects the derived status.
class PersonalStateRepository {
  PersonalStateRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  Stream<PersonalStateRow?> watch(Subject subject) => (_db.select(
    _db.personalStates,
  )..where((t) => _matches(t, subject))).watchSingleOrNull();

  Future<PersonalStateRow?> get(Subject subject) => (_db.select(
    _db.personalStates,
  )..where((t) => _matches(t, subject))).getSingleOrNull();

  /// Watched counts a viewing; unwatched keeps the count as history.
  Future<void> setWatched(Subject subject, bool watched) async {
    final current = await get(subject);
    if (watched) {
      await _write(
        subject,
        PersonalStatesCompanion(
          watchStatus: const Value('watched'),
          watchCount: Value((current?.watchCount ?? 0) + 1),
          lastWatchedAt: Value(_now()),
        ),
      );
    } else {
      await _write(
        subject,
        const PersonalStatesCompanion(watchStatus: Value('unwatched')),
      );
    }
  }

  /// Records a finished viewing, for example when playback reached the end.
  /// Does nothing if the title was marked watched in the last hour.
  Future<void> recordViewing(Subject subject) async {
    final current = await get(subject);
    final last = current?.lastWatchedAt;
    if (last != null && _now().difference(last) < const Duration(hours: 1)) {
      return;
    }
    await setWatched(subject, true);
  }

  Future<void> setRating(Subject subject, int? rating) =>
      _write(subject, PersonalStatesCompanion(rating: Value(rating)));

  Future<void> setMaxPrice(Subject subject, double? price) =>
      _write(subject, PersonalStatesCompanion(maxPrice: Value(price)));

  Future<void> setPreferredEdition(Subject subject, String? editionUuid) =>
      _write(
        subject,
        PersonalStatesCompanion(preferredEditionUuid: Value(editionUuid)),
      );

  Future<void> setFavourite(Subject subject, bool favourite) =>
      _write(subject, PersonalStatesCompanion(favourite: Value(favourite)));

  Future<void> _write(Subject subject, PersonalStatesCompanion values) async {
    final stamped = values.copyWith(updatedAt: Value(_now()));
    final existing = await get(subject);
    if (existing != null) {
      await (_db.update(
        _db.personalStates,
      )..where((t) => t.id.equals(existing.id))).write(stamped);
      return;
    }
    await _db
        .into(_db.personalStates)
        .insert(
          stamped.copyWith(
            movieId: Value(subject.movieId),
            seriesId: Value(subject.seriesId),
            seasonId: Value(subject.seasonId),
          ),
        );
  }

  Expression<bool> _matches($PersonalStatesTable t, Subject s) =>
      s.movieId != null
      ? t.movieId.equals(s.movieId!)
      : s.seriesId != null
      ? t.seriesId.equals(s.seriesId!)
      : t.seasonId.equals(s.seasonId!);
}
