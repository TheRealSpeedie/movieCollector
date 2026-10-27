import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../application/cloud_providers.dart';

final _accountDetailsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
      final client = ref.watch(cloudClientProvider);
      if (client?.session == null) return null;
      return client!.account();
    });

final _devicesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) async {
    final client = ref.watch(cloudClientProvider);
    if (client?.session == null) return const [];
    return client!.devices();
  },
);

/// Movie Shelf Cloud: sign in or create an account, then manage it.
/// Returns true when the user signed in, so a storage move can continue.
class CloudAccountScreen extends ConsumerWidget {
  const CloudAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(cloudAccountProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Shelf Cloud')),
      body: ref.watch(cloudClientProvider) == null
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Diese Version der App kennt keinen Movie-Shelf-Cloud-Dienst.',
              ),
            )
          : session == null
          ? const _SignIn()
          : const _Account(),
    );
  }
}

class _SignIn extends ConsumerStatefulWidget {
  const _SignIn();

  @override
  ConsumerState<_SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<_SignIn> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  var _register = false;
  var _busy = false;
  String? _error;

  Future<void> _submit() async {
    final client = ref.read(cloudClientProvider)!;
    if (_register && _password.text != _repeat.text) {
      setState(() => _error = 'Die Passwörter stimmen nicht überein.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final device = '${Platform.operatingSystem} · Movie Shelf';
      final session = _register
          ? await client.signUp(_email.text, _password.text, device)
          : await client.signIn(_email.text, _password.text, device);
      ref.read(cloudAccountProvider.notifier).signedIn(session);
      if (mounted && context.canPop()) context.pop(true);
    } on AppException catch (e) {
      setState(() => _error = describeError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgot() async {
    final client = ref.read(cloudClientProvider)!;
    final messenger = ScaffoldMessenger.of(context);
    final email = await _ask(
      context,
      'Passwort vergessen',
      'E-Mail-Adresse',
      initial: _email.text,
    );
    if (email == null) return;
    try {
      await client.forgotPassword(email);
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
      return;
    }
    if (!mounted) return;
    final code = await _ask(context, 'Code aus der E-Mail', 'Code');
    if (code == null || !mounted) return;
    final password = await _ask(
      context,
      'Neues Passwort',
      'Mindestens 10 Zeichen',
      obscure: true,
    );
    if (password == null) return;
    try {
      await client.resetPassword(code, password);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Passwort geändert. Melde dich jetzt an.'),
        ),
      );
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Movie Shelf Cloud hält deine Sammlung auf all deinen Geräten aktuell, '
          'ohne eigenen Server. Gespeichert werden deine E-Mail-Adresse und deine '
          'Sammlung, keine Filme. Die Sammlung bleibt immer auch auf deinem Gerät.',
          style: TextStyle(color: AppColors.neutralGray),
        ),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Anmelden')),
            ButtonSegment(value: true, label: Text('Konto erstellen')),
          ],
          selected: {_register},
          onSelectionChanged: (s) => setState(() => _register = s.first),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(labelText: 'E-Mail-Adresse'),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          autofillHints: [
            _register ? AutofillHints.newPassword : AutofillHints.password,
          ],
          decoration: InputDecoration(
            labelText: 'Passwort',
            helperText: _register ? 'Mindestens 10 Zeichen' : null,
          ),
        ),
        if (_register)
          TextField(
            controller: _repeat,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Passwort wiederholen',
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.errorRed)),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(_register ? 'Konto erstellen' : 'Anmelden'),
        ),
        if (_register)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Die ersten 30 Tage sind kostenlos.',
              style: TextStyle(color: AppColors.neutralGray),
            ),
          )
        else
          TextButton(
            onPressed: _forgot,
            child: const Text('Passwort vergessen?'),
          ),
      ],
    );
  }
}

class _Account extends ConsumerWidget {
  const _Account();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(cloudClientProvider)!;
    final details = ref.watch(_accountDetailsProvider);
    final devices = ref.watch(_devicesProvider).valueOrNull ?? const [];
    final storage = ref.watch(collectionStorageProvider);
    final messenger = ScaffoldMessenger.of(context);
    final date = DateFormat('dd.MM.yyyy');

    Future<void> act(Future<void> Function() work, String done) async {
      try {
        await work();
        messenger.showSnackBar(SnackBar(content: Text(done)));
      } on AppException catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
      }
      ref.invalidate(_accountDetailsProvider);
      ref.invalidate(_devicesProvider);
    }

    final data = details.valueOrNull;
    final subscription = data?['subscription'] as Map<String, dynamic>?;
    final expires = subscription?['expiresAt'] == null
        ? null
        : DateTime.parse(subscription!['expiresAt'] as String).toLocal();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(client.session!.email),
          subtitle: Text(
            storage == CollectionStorage.cloud
                ? 'Deine Sammlung wird über Movie Shelf Cloud abgeglichen.'
                : 'Angemeldet. Wähle unter Daten & Synchronisation Movie Shelf Cloud als Speicherort.',
          ),
        ),
        if (details.hasError) ErrorView(error: details.error!),
        if (data != null && data['emailVerified'] != true)
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.mark_email_unread_outlined,
                color: AppColors.amber,
              ),
              title: const Text('E-Mail-Adresse bestätigen'),
              subtitle: const Text(
                'Gib den Code aus der E-Mail ein. Damit kannst du dein Konto wiederherstellen.',
              ),
              trailing: TextButton(
                onPressed: () =>
                    act(client.resendVerification, 'Neuer Code ist unterwegs.'),
                child: const Text('Neu senden'),
              ),
              onTap: () async {
                final code = await _ask(context, 'Bestätigungscode', 'Code');
                if (code == null) return;
                await act(() => client.verify(code), 'Adresse bestätigt.');
              },
            ),
          ),
        if (subscription != null)
          Card(
            child: ListTile(
              leading: Icon(
                subscription['active'] == true
                    ? Icons.verified_outlined
                    : Icons.error_outline,
                color: subscription['active'] == true
                    ? AppColors.sage
                    : AppColors.amber,
              ),
              title: Text(
                subscription['plan'] == 'trial'
                    ? 'Testzeitraum'
                    : 'Movie Shelf Cloud',
              ),
              subtitle: Text(
                subscription['active'] == true
                    ? 'Aktiv bis ${expires == null ? '?' : date.format(expires)}'
                    : 'Abgelaufen. Deine Sammlung bleibt auf deinen Geräten und lässt sich exportieren; '
                          'neue Änderungen werden erst nach einer Verlängerung abgeglichen.',
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text('Geräte', style: Theme.of(context).textTheme.titleMedium),
        for (final device in devices)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.devices_outlined),
            title: Text(device['name'] as String),
            subtitle: Text(
              device['current'] == true
                  ? 'Dieses Gerät'
                  : 'Zuletzt ${device['lastSeenAt'] == null ? '–' : date.format(DateTime.parse(device['lastSeenAt'] as String).toLocal())}',
            ),
            trailing: device['current'] == true
                ? null
                : TextButton(
                    onPressed: () => act(
                      () => client.revokeDevice(device['id'] as String),
                      'Gerät abgemeldet.',
                    ),
                    child: const Text('Abmelden'),
                  ),
          ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => act(() async {
            final file = File(
              p.join(
                (await getTemporaryDirectory()).path,
                'movieshelf-cloud-export.json',
              ),
            );
            await file.writeAsString(jsonEncode(await client.export()));
            await SharePlus.instance.share(
              ShareParams(files: [XFile(file.path)]),
            );
          }, 'Export erstellt.'),
          icon: const Icon(Icons.download_outlined),
          label: const Text('Meine Daten exportieren'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            if (storage == CollectionStorage.cloud) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Wähle zuerst einen anderen Speicherort unter Daten & Synchronisation.',
                  ),
                ),
              );
              return;
            }
            await client.signOut();
            ref.read(cloudAccountProvider.notifier).signedOut();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Auf diesem Gerät abmelden'),
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
          onPressed: () async {
            final password = await _ask(
              context,
              'Konto löschen',
              'Passwort zur Bestätigung',
              obscure: true,
              note:
                  'Konto, Geräte und die Sammlung in der Cloud werden gelöscht. '
                  'Die Sammlung auf diesem Gerät bleibt erhalten.',
            );
            if (password == null) return;
            try {
              await client.deleteAccount(password);
              if (storage == CollectionStorage.cloud) {
                await ref
                    .read(collectionStorageProvider.notifier)
                    .set(CollectionStorage.local);
              }
              ref.read(cloudAccountProvider.notifier).signedOut();
            } on AppException catch (e) {
              messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
            }
          },
          child: const Text('Konto löschen'),
        ),
      ],
    );
  }
}

Future<String?> _ask(
  BuildContext context,
  String title,
  String label, {
  String initial = '',
  bool obscure = false,
  String? note,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note != null) Text(note),
          TextField(
            controller: controller,
            autofocus: true,
            obscureText: obscure,
            decoration: InputDecoration(labelText: label),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
