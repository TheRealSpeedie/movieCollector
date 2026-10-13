import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../application/server_providers.dart';
import '../data/pairing_link.dart';
import '../data/pairing_service.dart';

class ConnectScreen extends ConsumerStatefulWidget {
  const ConnectScreen({super.key});

  @override
  ConsumerState<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends ConsumerState<ConnectScreen> {
  final _linkField = TextEditingController();
  final _deviceName = TextEditingController(text: 'Mein Handy');
  final _username = TextEditingController();
  final _password = TextEditingController();

  PairingLink? _link;
  PairingProgress? _progress;
  String? _error;
  bool _cancelled = false;

  @override
  void dispose() {
    _cancelled = true;
    _linkField.dispose();
    _deviceName.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _busy => _progress != null;

  Future<void> _scan() async {
    final value = await context.push<String>('/server/scan');
    if (value != null) _accept(value);
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _linkField.text = data!.text!.trim();
      _accept(_linkField.text);
    }
  }

  void _accept(String value) {
    try {
      final link = PairingLink.parse(value);
      setState(() {
        _link = link;
        _error = null;
      });
    } on AppException catch (e) {
      setState(() => _error = e.message);
    }
  }

  Future<void> _connect() async {
    final link = _link!;
    final name = _deviceName.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Gib dem Gerät einen Namen.');
      return;
    }
    setState(() {
      _error = null;
      _progress = PairingProgress.verifying;
    });
    try {
      final credentials = await ref
          .read(pairingServiceProvider)
          .pair(
            link,
            deviceName: name,
            username: _username.text.trim(),
            password: _password.text,
            onProgress: (p) {
              if (mounted) setState(() => _progress = p);
            },
            isCancelled: () => _cancelled,
          );
      await ref.read(serverSessionProvider.notifier).connect(credentials);
      if (mounted) context.go('/server');
    } on AppException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _progress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final link = _link;
    return Scaffold(
      appBar: AppBar(title: const Text('Server verbinden')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (link == null) ..._chooseSource() else ..._confirm(link),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _ErrorBanner(message: _error!),
          ],
        ],
      ),
    );
  }

  List<Widget> _chooseSource() => [
    Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mit deinem Heimserver koppeln',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Öffne das Movie-Shelf-Dashboard auf deinem Computer, wähle „Geräte“ und dann „Gerät verbinden“. Der Code ist drei Minuten gültig.',
              style: TextStyle(color: AppColors.neutralGray),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _scan,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('QR-Code scannen'),
              ),
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 16),
    TextField(
      controller: _linkField,
      decoration: InputDecoration(
        labelText: 'Oder Kopplungslink einfügen',
        hintText: 'movieshelf://pair?…',
        suffixIcon: IconButton(
          icon: const Icon(Icons.content_paste),
          tooltip: 'Aus Zwischenablage einfügen',
          onPressed: _paste,
        ),
      ),
      onSubmitted: _accept,
    ),
    const SizedBox(height: 12),
    Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(
        onPressed: () => _accept(_linkField.text),
        child: const Text('Weiter'),
      ),
    ),
  ];

  List<Widget> _confirm(PairingLink link) => [
    Card(
      child: ListTile(
        leading: const Icon(Icons.dns_outlined, color: AppColors.sage),
        title: Text(link.serverName),
        subtitle: Text('${link.host}:${link.port}'),
        trailing: _busy
            ? null
            : TextButton(
                onPressed: () => setState(() {
                  _link = null;
                  _error = null;
                }),
                child: const Text('Ändern'),
              ),
      ),
    ),
    const SizedBox(height: 16),
    TextField(
      controller: _deviceName,
      enabled: !_busy,
      decoration: const InputDecoration(labelText: 'Name dieses Geräts'),
    ),
    const SizedBox(height: 20),
    Text('Anmeldung', style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 4),
    const Text(
      'Melde dich mit deinem Konto an, um sofort verbunden zu sein. Ohne Anmeldung bestätigst du das Gerät im Dashboard.',
      style: TextStyle(color: AppColors.neutralGray, fontSize: 13),
    ),
    const SizedBox(height: 12),
    TextField(
      controller: _username,
      enabled: !_busy,
      autocorrect: false,
      onChanged: (_) => setState(() {}),
      decoration: const InputDecoration(labelText: 'Benutzername'),
    ),
    const SizedBox(height: 12),
    TextField(
      controller: _password,
      enabled: !_busy,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Passwort'),
      onSubmitted: (_) => _connect(),
    ),
    const SizedBox(height: 20),
    if (_busy)
      _ProgressRow(progress: _progress!)
    else
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _connect,
          child: Text(
            _username.text.trim().isEmpty
                ? 'Verbinden und im Dashboard bestätigen'
                : 'Verbinden',
          ),
        ),
      ),
  ];
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.progress});

  final PairingProgress progress;

  @override
  Widget build(BuildContext context) {
    final label = switch (progress) {
      PairingProgress.verifying => 'Server wird überprüft …',
      PairingProgress.claiming => 'Gerät wird verbunden …',
      PairingProgress.waitingForApproval =>
        'Bestätige dieses Gerät jetzt im Dashboard unter „Geräte“.',
    };
    return Row(
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.errorRed, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
