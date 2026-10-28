import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../sync/application/sync_providers.dart';
import '../data/scan_log_repository.dart';
import '../domain/barcode_lookup_result.dart';
import '../domain/scan_assessment.dart';

final scanLogRepositoryProvider = Provider<ScanLogRepository>(
  (ref) => ScanLogRepository(ref.watch(appDatabaseProvider)),
);

final scanAssessorProvider = Provider<ScanAssessor>(
  (ref) => ScanAssessor(ref.watch(appDatabaseProvider)),
);

final recentScansProvider = StreamProvider<List<ScanHistoryRow>>(
  (ref) => ref.watch(scanLogRepositoryProvider).watchRecent(),
);

final pendingScanCountProvider = StreamProvider<int>(
  (ref) => ref.watch(scanLogRepositoryProvider).watchPendingCount(),
);

/// What to assess: an exact edition, or a title with a confidence.
typedef AssessmentRequest = ({
  int? editionId,
  int? tmdbId,
  int? tmdbCollectionId,
  String? format,
  bool exact,
});

final scanAssessmentProvider = FutureProvider.autoDispose
    .family<ScanAssessment, AssessmentRequest>((ref, request) {
      final assessor = ref.watch(scanAssessorProvider);
      // Re-evaluate when the collection changes, for example after saving.
      final db = ref.watch(appDatabaseProvider);
      final subscription = db
          .tableUpdates(
            TableUpdateQuery.onAllTables([
              db.movies,
              db.tvSeasonsTable,
              db.ownedCopies,
              db.personalStates,
              db.physicalEditionMovies,
              db.physicalEditionTvSeasons,
            ]),
          )
          .listen((_) => ref.invalidateSelf());
      ref.onDispose(subscription.cancel);
      final digital = ref.watch(serverTmdbIdsProvider);
      if (request.editionId != null) {
        return assessor.forEdition(request.editionId!, digitalTmdbIds: digital);
      }
      return assessor.forTitle(
        tmdbId: request.tmdbId!,
        tmdbCollectionId: request.tmdbCollectionId,
        scannedFormat: request.format,
        digitalTmdbIds: digital,
        confidence: request.exact
            ? MatchConfidence.exact
            : MatchConfidence.probable,
      );
    });

/// Resolves barcodes that were scanned offline. Stops at the first one that
/// still cannot be looked up, because the device is probably still offline.
class PendingScanProcessor {
  PendingScanProcessor(this._ref);

  final Ref _ref;
  bool _running = false;

  Future<int> run() async {
    if (_running) return 0;
    _running = true;
    var resolved = 0;
    try {
      final log = _ref.read(scanLogRepositoryProvider);
      final resolver = _ref.read(barcodeResolverProvider);
      for (final pending in await log.pending()) {
        final BarcodeLookupResult result;
        try {
          result = await resolver.resolve(pending.code);
        } catch (e) {
          await log.markAttempt(pending.code, '$e');
          continue;
        }
        if (result is BarcodeUnresolvedOffline) break;
        await log.resolved(pending.code);
        await log.record(
          code: pending.code,
          verdict: 'resolved',
          title: scanTitle(result),
        );
        resolved++;
      }
    } finally {
      _running = false;
    }
    return resolved;
  }
}

final pendingScanProcessorProvider = Provider<PendingScanProcessor>(
  PendingScanProcessor.new,
);

/// Looks up barcodes scanned offline when the app starts and whenever it
/// returns to the foreground, not only when the scanner opens. Watched once
/// by the app; works in every storage mode.
final pendingScanDrainProvider = Provider<void>((ref) {
  final processor = ref.watch(pendingScanProcessorProvider);
  unawaited(processor.run());
  final lifecycle = AppLifecycleListener(
    onResume: () => unawaited(processor.run()),
  );
  ref.onDispose(lifecycle.dispose);
});

/// A short name for a lookup result, for the scan history.
String? scanTitle(BarcodeLookupResult result) => switch (result) {
  BarcodeKnownMovie(:final movie) => movie.title,
  BarcodeKnownEdition(:final edition) =>
    edition.productTitle ??
        edition.series?.name ??
        edition.movies.firstOrNull?.title,
  BarcodeNeedsConfirmation(:final productTitle, :final candidates) =>
    candidates.firstOrNull?.result.title ?? productTitle,
  BarcodeNeedsTvConfirmation(:final productTitle) => productTitle,
  BarcodeNeedsMovieBundleConfirmation(:final productTitle) => productTitle,
  BarcodeWeakMatch(:final productTitle) => productTitle,
  BarcodeNoMatch(:final productTitle) => productTitle,
  _ => null,
};
