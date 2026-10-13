import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../application/sync_providers.dart';
import '../data/collection_sync_repository.dart';
import '../domain/collection_snapshot.dart';

class SyncScreen extends ConsumerWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(syncControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sammlung abgleichen'),
        actions: [
          IconButton(
            tooltip: 'Jetzt abgleichen',
            icon: const Icon(Icons.sync),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: ref
          .watch(syncControllerProvider)
          .when(
            loading: () => const LoadingView(),
            error: (error, _) =>
                ErrorView(error: error, onRetry: controller.refresh),
            data: (report) => report == null
                ? const EmptyState(
                    icon: Icons.dns_outlined,
                    title: 'Kein Server verbunden',
                    message:
                        'Verbinde dein Handy mit dem Heimserver, um Filme mit deiner digitalen Bibliothek abzugleichen.',
                  )
                : _Report(report: report),
          ),
    );
  }
}

class _Report extends ConsumerWidget {
  const _Report({required this.report});

  final SyncReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(syncControllerProvider.notifier);
    if (report.pending == 0) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        title: 'Alles abgeglichen',
        message: report.pushed + report.removed == 0
            ? 'Deine Sammlung auf dem Handy und auf dem Server stimmen überein.'
            : '${report.pushed} Filme an den Server übertragen, ${report.removed} entfernt.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (report.conflicts.isNotEmpty) ...[
          Text('Konflikte', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text(
            'Dieser Film wurde auf dem Handy und auf dem Server unterschiedlich geändert. Nichts wird überschrieben, bis du wählst.',
          ),
          const SizedBox(height: 12),
          for (final item in report.conflicts)
            _DifferenceCard(
              item: item,
              onKeepLocal: () => controller.keepLocal(item.tmdbId),
              onKeepServer: () => controller.keepServer(item.tmdbId),
            ),
        ],
        if (report.incoming.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Neu vom Server',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text(
            'Ein anderes Gerät hat diese Filme geändert. Übernimm die Änderung oder behalte deinen Stand.',
          ),
          const SizedBox(height: 12),
          for (final item in report.incoming)
            _DifferenceCard(
              item: item,
              onKeepLocal: () => controller.keepLocal(item.tmdbId),
              onKeepServer: () => controller.keepServer(item.tmdbId),
            ),
        ],
      ],
    );
  }
}

class _DifferenceCard extends StatelessWidget {
  const _DifferenceCard({
    required this.item,
    required this.onKeepLocal,
    required this.onKeepServer,
  });

  final SyncDifference item;
  final VoidCallback onKeepLocal;
  final VoidCallback onKeepServer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _Side(label: 'Handy', snapshot: item.local),
            const SizedBox(height: 4),
            _Side(label: 'Server', snapshot: item.server),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onKeepLocal,
                  child: const Text('Handy behalten'),
                ),
                FilledButton(
                  onPressed: onKeepServer,
                  child: const Text('Server übernehmen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.label, required this.snapshot});

  final String label;
  final CollectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final copies = snapshot.barcodes.length;
    return Text(
      '$label: ${snapshot.status.germanLabel}, '
      '${copies == 0 ? 'keine physische Ausgabe' : '$copies physische Ausgabe${copies == 1 ? '' : 'n'}'}',
    );
  }
}
