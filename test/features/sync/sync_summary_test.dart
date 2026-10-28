import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/sync/sync_engine.dart';
import 'package:movie_shelf/features/sync/application/sync_providers.dart';

void main() {
  test('the sync line says what is waiting and that nothing is lost', () {
    final report = SyncReport(
      pushed: 1,
      received: 2,
      conflicts: 0,
      at: DateTime(2026, 10, 28, 20, 5),
    );
    expect(syncSummary(AsyncData(report), 0), 'Abgeglichen 20:05');
    expect(
      syncSummary(AsyncError(Exception('offline'), StackTrace.empty), 3),
      'Nicht erreichbar – alles bleibt auf dem Gerät · 3 Änderungen warten',
    );
    expect(
      syncSummary(const AsyncData(null), 1),
      'Noch nicht abgeglichen · 1 Änderung wartet',
    );
  });
}
