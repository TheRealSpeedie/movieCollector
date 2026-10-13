import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../server/domain/server_models.dart';
import '../application/remote_providers.dart';
import '../domain/remote_models.dart';

Future<void> sendRemoteCommand(
  BuildContext context,
  WidgetRef ref,
  RemotePlayer player,
  String command, {
  double? seconds,
  int? titleId,
  int? episodeId,
}) async {
  try {
    final connection = await ref.read(controlConnectionProvider.future);
    await connection!.send(
      player.deviceId,
      command,
      seconds: seconds,
      titleId: titleId,
      episodeId: episodeId,
    );
  } on Object {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${player.name} reagiert nicht.')));
    }
  }
}

Future<void> openOnTelevision(
  BuildContext context,
  WidgetRef ref,
  int titleId,
) async {
  final player = await showModalBottomSheet<RemotePlayer>(
    context: context,
    builder: (context) => const _PlayerPicker(),
  );
  if (player == null || !context.mounted) return;
  await sendRemoteCommand(context, ref, player, 'open', titleId: titleId);
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Auf ${player.name} geöffnet.')));
  }
}

class _PlayerPicker extends ConsumerWidget {
  const _PlayerPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(remotePlayersProvider);
    return SafeArea(
      child: players.when(
        loading: () => const SizedBox(height: 160, child: LoadingView()),
        error: (error, _) => ErrorView(error: error),
        data: (list) => list.isEmpty
            ? const SizedBox(
                height: 200,
                child: EmptyState(
                  icon: Icons.tv_off_outlined,
                  title: 'Kein Fernseher verbunden',
                  message: 'Öffne Movie Shelf auf deinem Fernseher.',
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final player in list)
                    ListTile(
                      leading: const Icon(Icons.tv),
                      title: Text(player.name),
                      subtitle: Text(
                        player.state.active
                            ? 'Läuft: ${player.state.title ?? ''}'
                            : 'Bereit',
                      ),
                      onTap: () => Navigator.of(context).pop(player),
                    ),
                ],
              ),
      ),
    );
  }
}

class RemoteScreen extends ConsumerWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(remotePlayersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Fernbedienung')),
      body: players.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(controlConnectionProvider),
        ),
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.tv_off_outlined,
                title: 'Kein Fernseher verbunden',
                message:
                    'Öffne Movie Shelf auf deinem Fernseher. Sobald er mit dem Server verbunden ist, erscheint er hier.',
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [for (final p in list) _PlayerCard(player: p)],
              ),
      ),
    );
  }
}

class _PlayerCard extends ConsumerWidget {
  const _PlayerCard({required this.player});

  final RemotePlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = player.state;
    void send(String command, {double? seconds}) =>
        sendRemoteCommand(context, ref, player, command, seconds: seconds);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tv, color: AppColors.dustyRose),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    player.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!state.active)
              const Text(
                'Bereit. Wähle einen Titel und öffne ihn auf dem Fernseher.',
                style: TextStyle(color: AppColors.neutralGray),
              )
            else ...[
              Text(
                state.title ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (state.subtitle != null)
                Text(
                  state.subtitle!,
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: state.fraction,
                minHeight: 4,
                backgroundColor: AppColors.divider,
                color: AppColors.dustyRose,
              ),
              const SizedBox(height: 4),
              Text(
                '${formatClock(state.positionSeconds)} / ${formatClock(state.durationSeconds)}',
                style: const TextStyle(
                  color: AppColors.neutralGray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: '10 Sekunden zurück',
                    icon: const Icon(Icons.replay_10),
                    onPressed: () => send(
                      'seek',
                      seconds: (state.positionSeconds - 10).clamp(
                        0,
                        double.infinity,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    tooltip: state.playing ? 'Pause' : 'Wiedergabe',
                    iconSize: 32,
                    icon: Icon(state.playing ? Icons.pause : Icons.play_arrow),
                    onPressed: () => send(state.playing ? 'pause' : 'play'),
                  ),
                  IconButton(
                    tooltip: '10 Sekunden vor',
                    icon: const Icon(Icons.forward_10),
                    onPressed: () =>
                        send('seek', seconds: state.positionSeconds + 10),
                  ),
                  IconButton(
                    tooltip: 'Beenden',
                    icon: const Icon(Icons.stop),
                    onPressed: () => send('stop'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
