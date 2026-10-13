import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../server/application/server_providers.dart';
import '../data/control_connection.dart';
import '../domain/remote_models.dart';

class PlayerBridge {
  const PlayerBridge({
    required this.play,
    required this.pause,
    required this.seek,
    required this.stop,
    required this.snapshot,
  });

  final Future<void> Function() play;
  final Future<void> Function() pause;
  final Future<void> Function(double seconds) seek;
  final void Function() stop;
  final PlayerSnapshot Function() snapshot;
}

final playerBridgeProvider = StateProvider<PlayerBridge?>((ref) => null);

final controlConnectionProvider =
    FutureProvider.autoDispose<ControlConnection?>((ref) async {
      final client = ref.watch(serverClientProvider);
      if (client == null) return null;
      final connection = ControlConnection(client);
      ref.onDispose(connection.stop);
      await connection.start();
      return connection;
    });

final remotePlayersProvider = StreamProvider.autoDispose<List<RemotePlayer>>((
  ref,
) async* {
  final connection = await ref.watch(controlConnectionProvider.future);
  if (connection == null) {
    yield const [];
    return;
  }
  final changes = StreamController<void>();
  final players = <String, RemotePlayer>{};

  Future<void> refresh() async {
    players
      ..clear()
      ..addEntries(
        (await connection.players()).map((p) => MapEntry(p.deviceId, p)),
      );
    changes.add(null);
  }

  final subscriptions = [
    connection.playerStates.listen((player) {
      players[player.deviceId] = player;
      changes.add(null);
    }),
    connection.playersGone.listen((id) {
      players.remove(id);
      changes.add(null);
    }),
    connection.reconnected.listen((_) => refresh()),
  ];
  ref.onDispose(() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    changes.close();
  });

  await refresh();
  await for (final _ in changes.stream) {
    yield players.values.toList();
  }
});
