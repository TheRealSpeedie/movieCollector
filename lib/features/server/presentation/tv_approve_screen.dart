import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../application/server_providers.dart';
import '../data/pairing_link.dart';

String formatFingerprint(String fingerprint) {
  final short = fingerprint.toUpperCase().padRight(16).substring(0, 16).trim();
  return [
    for (var i = 0; i < short.length; i += 4)
      short.substring(i, (i + 4).clamp(0, short.length)),
  ].join(' ');
}

class TvApproveScreen extends ConsumerStatefulWidget {
  const TvApproveScreen({super.key});

  @override
  ConsumerState<TvApproveScreen> createState() => _TvApproveScreenState();
}

class _TvApproveScreenState extends ConsumerState<TvApproveScreen> {
  final _code = TextEditingController();

  Map<String, dynamic>? _tv;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final value = await context.push<String>('/server/scan');
    if (value == null) return;
    try {
      final link = PairingLink.parse(value);
      final own = ref.read(serverSessionProvider).valueOrNull;
      if (link.mode != 'tv') {
        throw const PairingFailedException(
          'Dieser Code gehört nicht zu einem Fernseher. Öffne auf dem Fernseher Movie Shelf und scanne den dortigen Code.',
        );
      }
      if (own != null && own.fingerprint != link.fingerprint) {
        throw const PairingFailedException(
          'Dieser Fernseher gehört zu einem anderen Server.',
        );
      }
      await _lookup(link.sessionId);
    } on AppException catch (e) {
      setState(() => _error = e.message);
    }
  }

  Future<void> _lookup(String idOrCode) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final tv =
          await ref
                  .read(serverClientProvider)!
                  .get('/api/pairing/tv-sessions/${idOrCode.trim()}')
              as Map<String, dynamic>;
      setState(() => _tv = tv);
    } on Object catch (e) {
      setState(() => _error = describeError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _approve() async {
    final tv = _tv!;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(serverClientProvider)!
          .post('/api/pairing/tv-sessions/${tv['sessionId']}/approve');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${tv['deviceName']} wurde verbunden.')),
      );
      context.pop();
    } on Object catch (e) {
      setState(() => _error = describeError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tv = _tv;
    return Scaffold(
      appBar: AppBar(title: const Text('Fernseher koppeln')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (tv == null) ..._enter() else ..._confirm(tv),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: AppColors.errorRed)),
          ],
        ],
      ),
    );
  }

  List<Widget> _enter() => [
    const Text(
      'Öffne Movie Shelf auf deinem Fernseher. Dort erscheint ein QR-Code und ein Code mit sechs Zeichen.',
      style: TextStyle(color: AppColors.neutralGray),
    ),
    const SizedBox(height: 16),
    FilledButton.icon(
      onPressed: _busy ? null : _scan,
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('QR-Code scannen'),
    ),
    const SizedBox(height: 24),
    TextField(
      controller: _code,
      enabled: !_busy,
      textCapitalization: TextCapitalization.characters,
      autocorrect: false,
      maxLength: 6,
      decoration: const InputDecoration(labelText: 'Oder Code eingeben'),
      onSubmitted: _lookup,
    ),
    Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(
        onPressed: _busy ? null : () => _lookup(_code.text),
        child: const Text('Weiter'),
      ),
    ),
  ];

  List<Widget> _confirm(Map<String, dynamic> tv) => [
    Card(
      child: ListTile(
        leading: const Icon(Icons.tv, color: AppColors.dustyRose),
        title: Text(tv['deviceName'] as String),
        subtitle: Text('Server: ${tv['serverName']}'),
      ),
    ),
    const SizedBox(height: 16),
    const Text('Code auf dem Fernseher'),
    Text(
      tv['shortCode'] as String,
      style: Theme.of(context).textTheme.headlineMedium,
    ),
    const SizedBox(height: 12),
    const Text('Server-Kennung'),
    Text(
      formatFingerprint(tv['fingerprint'] as String),
      style: Theme.of(context).textTheme.titleMedium,
    ),
    const SizedBox(height: 12),
    const Text(
      'Verbinde den Fernseher nur, wenn Code und Kennung genauso auf dem Bildschirm stehen.',
      style: TextStyle(color: AppColors.neutralGray),
    ),
    const SizedBox(height: 20),
    FilledButton(
      onPressed: _busy ? null : _approve,
      child: const Text('Fernseher verbinden'),
    ),
    TextButton(
      onPressed: _busy ? null : () => setState(() => _tv = null),
      child: const Text('Abbrechen'),
    ),
  ];
}
