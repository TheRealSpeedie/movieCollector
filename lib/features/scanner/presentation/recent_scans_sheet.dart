import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../application/scan_providers.dart';

/// "Zuletzt gescannt" with the barcodes that wait for a connection.
class RecentScansSheet extends ConsumerWidget {
  const RecentScansSheet({super.key, required this.onOpen});

  /// Scans the code again to show its result.
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentScansProvider).valueOrNull ?? [];
    final pending = ref.watch(pendingScanCountProvider).valueOrNull ?? 0;
    final time = DateFormat('dd.MM. HH:mm');
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              'Zuletzt gescannt',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: pending == 0
                ? null
                : TextButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final done = await ref
                          .read(pendingScanProcessorProvider)
                          .run();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            done == 0
                                ? 'Noch keine Verbindung. Die Barcodes bleiben gespeichert.'
                                : '$done Barcodes erkannt.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.cloud_sync_outlined),
                    label: Text('$pending jetzt erkennen'),
                  ),
          ),
          if (recent.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Noch nichts gescannt.', textAlign: TextAlign.center),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final scan in recent)
                  ListTile(
                    leading: Icon(
                      scan.verdict == 'pending'
                          ? Icons.schedule
                          : scan.verdict == 'alreadyOwnedExact' ||
                                scan.verdict == 'otherEditionOwned'
                          ? Icons.check_circle_outline
                          : Icons.qr_code,
                      color: scan.verdict == 'pending'
                          ? AppColors.amber
                          : AppColors.neutralGray,
                    ),
                    title: Text(scan.title ?? scan.code),
                    subtitle: Text(
                      scan.verdict == 'pending'
                          ? 'Wartet auf Internet · ${time.format(scan.scannedAt)}'
                          : '${scan.code} · ${time.format(scan.scannedAt)}',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onOpen(scan.code);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
