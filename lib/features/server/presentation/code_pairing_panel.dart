import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/errors/user_facing_error.dart';
import '../application/server_providers.dart';
import '../data/pairing_service.dart';
import '../data/server_discovery.dart';

const _sessionLifetime = Duration(seconds: 150);
const _pollInterval = Duration(seconds: 2);

/// Connecting without a QR code: servers found on the network, or an
/// address typed in. Either way this phone shows a short code that someone
/// signed in confirms in the dashboard or on a phone that is connected.
class CodePairingPanel extends ConsumerStatefulWidget {
  const CodePairingPanel({super.key, required this.deviceName});

  /// The name this phone gets on the server.
  final String Function() deviceName;

  @override
  ConsumerState<CodePairingPanel> createState() => _CodePairingPanelState();
}

class _CodePairingPanelState extends ConsumerState<CodePairingPanel> {
  final _address = TextEditingController();
  List<DiscoveredServer>? _found;
  bool _searching = false;
  TvPairing? _pairing;
  String? _serverName;
  String? _error;
  int _run = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _disposed = true;
    _address.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _searching = true;
      _error = null;
    });
    List<DiscoveredServer> found;
    try {
      found = await ref.read(serverDiscoveryProvider).discover();
    } catch (_) {
      found = const [];
    }
    if (_disposed) return;
    setState(() {
      _found = found;
      _searching = false;
    });
  }

  Future<void> _pair({
    required String baseUrl,
    required String name,
    String? fingerprint,
  }) async {
    final run = ++_run;
    bool stale() => _disposed || run != _run;
    setState(() {
      _error = null;
      _serverName = name;
    });
    final service = ref.read(pairingServiceProvider);
    try {
      final pairing = await service.startTv(
        baseUrl,
        widget.deviceName(),
        fingerprint: fingerprint,
        deviceType: 'phone',
      );
      if (stale()) return;
      setState(() => _pairing = pairing);
      final deadline = DateTime.now().add(_sessionLifetime);
      while (!stale() && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(_pollInterval);
        if (stale()) return;
        final credentials = await service.pollTv(pairing);
        if (credentials != null) {
          await ref.read(serverSessionProvider.notifier).connect(credentials);
          if (mounted) context.go('/server');
          return;
        }
      }
      if (!stale()) {
        setState(() {
          _pairing = null;
          _error = 'Der Code ist abgelaufen. Versuche es noch einmal.';
        });
      }
    } catch (e) {
      if (stale()) return;
      setState(() {
        _pairing = null;
        _error = describeError(e);
      });
    }
  }

  void _cancel() => setState(() {
    _run++;
    _pairing = null;
  });

  @override
  Widget build(BuildContext context) {
    final pairing = _pairing;
    return pairing != null ? _code(context, pairing) : _choose(context);
  }

  Widget _code(BuildContext context, TvPairing pairing) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final spaced = pairing.shortCode.split('').join(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Code für ${_serverName ?? 'deinen Server'}',
          style: text.titleMedium,
        ),
        const SizedBox(height: AppSpacing.m),
        Semantics(
          label: 'Code ${pairing.shortCode.split('').join(' ')}',
          excludeSemantics: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            alignment: Alignment.center,
            child: SelectableText(
              spaced,
              style: text.displaySmall?.copyWith(letterSpacing: 4),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        Text(
          'Gib den Code im Dashboard deines Servers unter „Geräte“ › „Mit Code verbinden“ ein, oder '
          'auf einem Handy, das schon verbunden ist, unter Mehr › Speednema '
          'Server › Gerät koppeln. Er gilt zwei Minuten.',
          style: text.bodyMedium?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.m),
        Row(
          children: [
            const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.m),
            const Expanded(child: Text('Wartet auf Bestätigung …')),
            TextButton(onPressed: _cancel, child: const Text('Abbrechen')),
          ],
        ),
      ],
    );
  }

  Widget _choose(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final found = _found ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Im Netzwerk', style: text.titleMedium)),
            if (_searching)
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              TextButton(onPressed: _search, child: const Text('Neu suchen')),
          ],
        ),
        if (!_searching && found.isEmpty)
          Text(
            'Kein Server gefunden. Prüfe, ob er läuft und dieses Handy im '
            'selben WLAN ist, oder gib seine Adresse ein.',
            style: text.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
        for (final server in found)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.dns_outlined, color: colors.textSecondary),
            title: Text(server.name),
            subtitle: Text('${server.host}:${server.port}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pair(
              baseUrl: server.baseUrl,
              name: server.name,
              fingerprint: server.fingerprint.isEmpty
                  ? null
                  : server.fingerprint,
            ),
          ),
        const SizedBox(height: AppSpacing.l),
        Text('Adresse eingeben', style: text.titleMedium),
        const SizedBox(height: AppSpacing.s),
        TextField(
          controller: _address,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'z. B. 192.168.1.20',
            helperText: 'Ohne Port wird $defaultServerPort verwendet.',
          ),
          onSubmitted: (_) => _pairTyped(),
        ),
        const SizedBox(height: AppSpacing.s),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton(
            onPressed: _pairTyped,
            child: const Text('Verbinden'),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.s),
          Text(_error!, style: TextStyle(color: colors.error)),
        ],
      ],
    );
  }

  void _pairTyped() {
    final typed = _address.text.trim();
    if (typed.isEmpty) {
      setState(() => _error = 'Gib die Adresse deines Servers ein.');
      return;
    }
    _pair(baseUrl: serverBaseUrl(typed), name: typed);
  }
}
