import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

/// Recently scanned items and barcodes waiting for a connection.
class ScanLogRepository {
  ScanLogRepository(this._db);

  static const _keep = 50;

  final AppDatabase _db;

  Future<void> record({
    required String code,
    required String verdict,
    String? title,
    int? movieId,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.scanHistory,
      )..where((t) => t.code.equals(code))).go();
      await _db
          .into(_db.scanHistory)
          .insert(
            ScanHistoryCompanion.insert(
              code: code,
              verdict: verdict,
              title: Value(title),
              movieId: Value(movieId),
            ),
          );
      await _db.customStatement(
        'DELETE FROM scan_history WHERE id NOT IN '
        '(SELECT id FROM scan_history ORDER BY scanned_at DESC, id DESC LIMIT $_keep)',
      );
    });
  }

  Stream<List<ScanHistoryRow>> watchRecent({int limit = 20}) =>
      (_db.select(_db.scanHistory)
            ..orderBy([
              (t) => OrderingTerm.desc(t.scannedAt),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(limit))
          .watch();

  Future<void> clearHistory() => _db.delete(_db.scanHistory).go();

  Future<void> queue(String code) => _db
      .into(_db.pendingScans)
      .insert(
        PendingScansCompanion.insert(code: code),
        mode: InsertMode.insertOrIgnore,
      );

  Future<List<PendingScanRow>> pending() => (_db.select(
    _db.pendingScans,
  )..orderBy([(t) => OrderingTerm.asc(t.scannedAt)])).get();

  Stream<int> watchPendingCount() =>
      _db.select(_db.pendingScans).watch().map((rows) => rows.length);

  Future<void> markAttempt(String code, String? error) => _db.customStatement(
    'UPDATE pending_scans SET attempts = attempts + 1, last_error = ? WHERE code = ?',
    [error, code],
  );

  Future<void> resolved(String code) =>
      (_db.delete(_db.pendingScans)..where((t) => t.code.equals(code))).go();
}
