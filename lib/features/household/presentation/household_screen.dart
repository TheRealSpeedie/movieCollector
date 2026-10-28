import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../application/household_providers.dart';
import '../data/household_api.dart';

/// Share one collection with the people you live with. Copies, editions and
/// the wishlist are shared; what someone watched and rated stays theirs.
class HouseholdScreen extends ConsumerWidget {
  const HouseholdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(householdApiProvider) != null;
    final household = ref.watch(householdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Haushalt')),
      body: !available
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Ein Haushalt braucht einen gemeinsamen Speicherort: Movie Shelf '
                'Cloud oder deinen eigenen Server. Wähle ihn unter Daten & '
                'Synchronisation.',
              ),
            )
          : household.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(householdProvider),
              ),
              data: (h) => h == null
                  ? const SizedBox.shrink()
                  : _HouseholdView(household: h),
            ),
    );
  }
}

class _HouseholdView extends ConsumerStatefulWidget {
  const _HouseholdView({required this.household});

  final Household household;

  @override
  ConsumerState<_HouseholdView> createState() => _HouseholdViewState();
}

class _HouseholdViewState extends ConsumerState<_HouseholdView> {
  var _busy = false;

  Household get _h => widget.household;

  Future<void> _run(
    String reason,
    Future<void> Function(HouseholdApi api) change,
    String done,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await changeHousehold(ref, reason, change);
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String title, String text, String action) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(action),
            ),
          ],
        ),
      ) ==
      true;

  Future<void> _invite() async {
    final api = ref.read(householdApiProvider);
    if (api == null) return;
    final messenger = ScaffoldMessenger.of(context);
    HouseholdInvite invite;
    try {
      invite = await api.invite();
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
      return;
    }
    if (!mounted) return;
    final text =
        'Komm in meinen Movie-Shelf-Haushalt: Mehr › Daten & Synchronisation › '
        'Haushalt › Beitreten, Code ${invite.code}';
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Einladungscode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              invite.code,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(letterSpacing: 4),
            ),
            const SizedBox(height: 8),
            Text(
              'Einmal gültig, bis ${DateFormat('dd.MM.yyyy').format(invite.expiresAt)}. '
              'Die eingeladene Person braucht denselben Speicherort wie du.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: invite.code)),
            child: const Text('Kopieren'),
          ),
          TextButton(
            onPressed: () => SharePlus.instance.share(ShareParams(text: text)),
            child: const Text('Teilen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }

  Future<void> _join() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Einem Haushalt beitreten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Deine Sammlung wird mit der des Haushalts zusammengeführt. '
              'Auf deinen Geräten bleibt alles erhalten; vorher wird ein '
              'Schnappschuss gespeichert.',
            ),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Einladungscode'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Beitreten'),
          ),
        ],
      ),
    );
    if (code == null || code.trim().isEmpty) return;
    await _run(
      'vor-haushalt',
      (api) => api.join(code),
      'Willkommen im Haushalt. Die Sammlung wird abgeglichen.',
    );
  }

  Future<void> _leave() async {
    if (!await _confirm(
      'Haushalt verlassen?',
      'Du behältst auf deinen Geräten alles, was jetzt da ist, und gleichst '
          'es danach nur noch für dich ab. Änderungen der anderen erreichen '
          'dich nicht mehr.',
      'Verlassen',
    )) {
      return;
    }
    await _run(
      'vor-haushalt-verlassen',
      (api) => api.leave(),
      'Du hast den Haushalt verlassen.',
    );
  }

  Future<void> _remove(HouseholdMember member) async {
    if (!await _confirm(
      '${member.name} entfernen?',
      'Die Person behält ihre Sammlung auf ihren Geräten, sieht aber eure '
          'gemeinsame Sammlung nicht mehr.',
      'Entfernen',
    )) {
      return;
    }
    await _run(
      'vor-haushalt-aendern',
      (api) => api.remove(member.id),
      '${member.name} wurde entfernt.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Im Haushalt teilt ihr eine Sammlung: Exemplare, Ausgaben und die '
          'Wunschliste. Was du gesehen hast und wie du Filme bewertest, '
          'bleibt deins.',
          style: TextStyle(color: AppColors.neutralGray),
        ),
        const SizedBox(height: 16),
        for (final member in _h.members)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              member.owner ? Icons.home_outlined : Icons.person_outline,
              color: member.you ? AppColors.sage : null,
            ),
            title: Text(member.you ? '${member.name} (du)' : member.name),
            subtitle: Text(
              member.owner ? 'Hat den Haushalt angelegt' : 'Mitglied',
            ),
            trailing: _h.isOwner && !member.owner && !_busy
                ? IconButton(
                    tooltip: '${member.name} entfernen',
                    icon: const Icon(Icons.person_remove_outlined),
                    onPressed: () => _remove(member),
                  )
                : null,
          ),
        const SizedBox(height: 16),
        if (_busy) const LinearProgressIndicator(),
        if (_h.isOwner) ...[
          FilledButton.icon(
            onPressed: _busy ? null : _invite,
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Jemanden einladen'),
          ),
          if (!_h.shared) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy ? null : _join,
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('Einem Haushalt beitreten'),
            ),
          ],
        ] else
          OutlinedButton.icon(
            onPressed: _busy ? null : _leave,
            icon: const Icon(Icons.logout),
            label: const Text('Haushalt verlassen'),
          ),
      ],
    );
  }
}
