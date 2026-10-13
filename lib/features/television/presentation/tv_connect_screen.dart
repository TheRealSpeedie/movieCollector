import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../server/application/server_providers.dart';
import '../../server/data/pairing_service.dart';
import '../../server/presentation/tv_approve_screen.dart';
import 'tv_focusable.dart';

const tvDeviceName = 'Fernseher';
const _sessionLifetime = Duration(seconds: 150);
const _pollInterval = Duration(seconds: 2);
const _defaultPort = 8096;

class TvConnectScreen extends ConsumerStatefulWidget {
  const TvConnectScreen({super.key});

  @override
  ConsumerState<TvConnectScreen> createState() => _TvConnectScreenState();
}

class _TvConnectScreenState extends ConsumerState<TvConnectScreen> {
  final _address = TextEditingController();

  TvPairing? _pairing;
  String? _serverName;
  String? _error;
  bool _manual = false;
  bool _searching = true;
  bool _disposed = false;
  int _run = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _disposed = true;
    _address.dispose();
    super.dispose();
  }

  Future<({String baseUrl, String? fingerprint, String name})?> _find() async {
    final typed = _address.text.trim();
    if (typed.isNotEmpty) {
      final host = typed.contains(':') ? typed : '$typed:$_defaultPort';
      return (baseUrl: 'http://$host', fingerprint: null, name: typed);
    }
    final found = await ref.read(serverDiscoveryProvider).discover();
    final server = found.firstOrNull;
    return server == null
        ? null
        : (
            baseUrl: server.baseUrl,
            fingerprint: server.fingerprint.isEmpty ? null : server.fingerprint,
            name: server.name,
          );
  }

  Future<void> _start() async {
    final run = ++_run;
    bool stale() => _disposed || run != _run;
    setState(() {
      _searching = true;
      _manual = false;
      _error = null;
      _pairing = null;
    });
    try {
      final target = await _find();
      if (stale()) return;
      if (target == null) {
        setState(() {
          _searching = false;
          _manual = true;
        });
        return;
      }
      final service = ref.read(pairingServiceProvider);
      while (!stale()) {
        final pairing = await service.startTv(
          target.baseUrl,
          tvDeviceName,
          fingerprint: target.fingerprint,
        );
        if (stale()) return;
        setState(() {
          _pairing = pairing;
          _serverName = target.name;
          _searching = false;
        });
        final deadline = DateTime.now().add(_sessionLifetime);
        while (!stale() && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(_pollInterval);
          if (stale()) return;
          final credentials = await service.pollTv(pairing);
          if (credentials != null) {
            await ref.read(serverSessionProvider.notifier).connect(credentials);
            return;
          }
        }
      }
    } on AppException catch (e) {
      if (stale()) return;
      setState(() {
        _error = e.message;
        _searching = false;
        _manual = true;
        _pairing = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TvPage(
      child: Row(
        children: [
          Expanded(child: _instructions(context)),
          const SizedBox(width: 48),
          SizedBox(width: 340, child: Center(child: _code(context))),
        ],
      ),
    );
  }

  Widget _instructions(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fernseher verbinden', style: theme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          _searching
              ? 'Der Movie-Shelf-Server wird im Heimnetz gesucht …'
              : _manual
              ? 'Es wurde kein Server gefunden. Gib die Adresse deines Servers ein, zum Beispiel 192.168.1.20.'
              : 'Öffne Movie Shelf auf deinem Handy, wähle „Fernseher koppeln“ und scanne den QR-Code. Du kannst auch den Code eingeben.',
          style: theme.titleMedium?.copyWith(color: AppColors.neutralGray),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: AppColors.errorRed)),
        ],
        const SizedBox(height: 24),
        if (_manual) ...[
          SizedBox(
            width: 360,
            child: TextField(
              controller: _address,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Serveradresse'),
              onSubmitted: (_) => _start(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Wrap(
          spacing: 16,
          children: [
            TvButton(
              label: _manual ? 'Verbinden' : 'Neu suchen',
              icon: _manual ? Icons.link : Icons.refresh,
              primary: true,
              autofocus: !_manual,
              onSelect: _start,
            ),
            if (!_manual && !_searching)
              TvButton(
                label: 'Adresse eingeben',
                icon: Icons.keyboard,
                onSelect: () => setState(() => _manual = true),
              ),
          ],
        ),
      ],
    );
  }

  Widget _code(BuildContext context) {
    final pairing = _pairing;
    if (pairing == null) {
      return _searching
          ? const CircularProgressIndicator(color: AppColors.dustyRose)
          : const Icon(Icons.tv, size: 96, color: AppColors.neutralGray);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: pairing.uri,
            size: 240,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          pairing.shortCode,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(letterSpacing: 8),
        ),
        const SizedBox(height: 8),
        Text(
          '${_serverName ?? ''} · ${formatFingerprint(pairing.link.fingerprint)}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.neutralGray),
        ),
      ],
    );
  }
}
