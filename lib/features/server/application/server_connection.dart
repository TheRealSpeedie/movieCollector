import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/connection_badge.dart';
import 'server_providers.dart';

/// Whether the paired server answered recently, as seen by real requests.
class ServerReachability {
  const ServerReachability({this.reachable, this.lastOk});

  /// Null until the first request after pairing or start.
  final bool? reachable;
  final DateTime? lastOk;
}

class ServerReachabilityNotifier extends Notifier<ServerReachability> {
  @override
  ServerReachability build() {
    // A different server (or none) starts from scratch.
    ref.watch(serverSessionProvider.select((s) => s.valueOrNull?.serverId));
    return const ServerReachability();
  }

  void report(bool reachable) {
    if (state.reachable == reachable && !reachable) return;
    state = ServerReachability(
      reachable: reachable,
      lastOk: reachable ? DateTime.now() : state.lastOk,
    );
  }
}

final serverReachabilityProvider =
    NotifierProvider<ServerReachabilityNotifier, ServerReachability>(
      ServerReachabilityNotifier.new,
    );

/// The connection to the user's Speednema Server, in the states people
/// need to tell apart. Local collection features never depend on it.
sealed class ServerConnectionState {
  const ServerConnectionState();
}

/// No server paired. Not a problem; the app works without one.
final class ServerNotConfigured extends ServerConnectionState {
  const ServerNotConfigured();
}

/// Paired, credentials loading or no answer yet.
final class ServerConnecting extends ServerConnectionState {
  const ServerConnecting();
}

final class ServerConnected extends ServerConnectionState {
  const ServerConnected({this.lastOk});

  final DateTime? lastOk;
}

/// Paired, but the last request did not reach it.
final class ServerOffline extends ServerConnectionState {
  const ServerOffline({this.lastOk});

  final DateTime? lastOk;
}

/// The server removed this device; it has to be connected again.
final class ServerAuthRequired extends ServerConnectionState {
  const ServerAuthRequired();
}

final serverConnectionProvider = Provider<ServerConnectionState>((ref) {
  final session = ref.watch(serverSessionProvider);
  if (ref.watch(serverRevokedProvider)) return const ServerAuthRequired();
  if (session.isLoading && !session.hasValue) return const ServerConnecting();
  if (session.valueOrNull == null) return const ServerNotConfigured();
  final reach = ref.watch(serverReachabilityProvider);
  return switch (reach.reachable) {
    null => const ServerConnecting(),
    true => ServerConnected(lastOk: reach.lastOk),
    false => ServerOffline(lastOk: reach.lastOk),
  };
});

extension ServerConnectionText on ServerConnectionState {
  /// Short status in the words app and dashboard share.
  String get label => switch (this) {
    ServerNotConfigured() => 'Nicht verbunden',
    ServerConnecting() => 'Wird verbunden …',
    ServerConnected() => 'Verbunden',
    ServerOffline() => 'Nicht erreichbar',
    ServerAuthRequired() => 'Neu verbinden nötig',
  };

  /// One sentence on what it means for the person.
  String get explanation => switch (this) {
    ServerNotConfigured() =>
      'Deine Sammlung funktioniert ohne Server. Mit einem eigenen Speednema '
          'Server kannst du Filme streamen und mit deinem Haushalt teilen.',
    ServerConnecting() => 'Speednema meldet sich bei deinem Server.',
    ServerConnected() => 'Streaming und Abgleich funktionieren.',
    ServerOffline() =>
      'Streaming ist gerade nicht möglich. Deine Sammlung bleibt auf diesem '
          'Gerät verfügbar; Änderungen werden später abgeglichen.',
    ServerAuthRequired() =>
      'Der Server hat dieses Gerät getrennt. Verbinde es noch einmal, deine '
          'Sammlung bleibt erhalten.',
  };

  ConnectionTone get tone => switch (this) {
    ServerNotConfigured() => ConnectionTone.none,
    ServerConnecting() => ConnectionTone.busy,
    ServerConnected() => ConnectionTone.ok,
    ServerOffline() => ConnectionTone.offline,
    ServerAuthRequired() => ConnectionTone.attention,
  };
}
