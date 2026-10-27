import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../server/application/server_providers.dart';
import '../../server/data/profile_api.dart';
import 'tv_focusable.dart';

final _profilesProvider = FutureProvider.autoDispose<List<ServerProfile>>((
  ref,
) {
  final client = ref.watch(serverClientProvider);
  if (client == null) return const [];
  return ProfileApi(client).profiles();
});

/// Who is watching? Each profile has its own continue watching, languages
/// and age limit; a PIN can protect it.
class TvProfilesScreen extends ConsumerWidget {
  const TvProfilesScreen({super.key});

  Future<void> _switch(
    BuildContext context,
    WidgetRef ref,
    ServerProfile profile,
  ) async {
    final client = ref.read(serverClientProvider);
    if (client == null || profile.current) return;
    String? pin;
    if (profile.hasPin) {
      pin = await showDialog<String>(
        context: context,
        builder: (_) => _PinDialog(name: profile.name),
      );
      if (pin == null) return;
    }
    try {
      final credentials = await ProfileApi(
        client,
      ).switchTo(profile.id, pin: pin);
      await ref.read(serverSessionProvider.notifier).connect(credentials);
      ref.invalidate(serverHomeProvider);
      if (context.mounted) context.go('/home');
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(describeError(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(_profilesProvider);
    return TvPage(
      child: profiles.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(_profilesProvider),
        ),
        data: (list) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wer schaut?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final (i, profile) in list.indexed)
                  TvFocusable(
                    autofocus: i == 0,
                    onSelect: () => _switch(context, ref, profile),
                    child: SizedBox(
                      width: 180,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: profile.current
                                  ? AppColors.dustyRose
                                  : AppColors.surface,
                              child: Text(
                                profile.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              profile.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              [
                                if (profile.current) 'Aktiv',
                                if (profile.hasPin) 'PIN',
                                if (profile.maxAgeRating != null)
                                  'ab ${profile.maxAgeRating}',
                              ].join(' · '),
                              style: const TextStyle(
                                color: AppColors.neutralGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A number pad for the remote: no keyboard needed.
class _PinDialog extends StatefulWidget {
  const _PinDialog({required this.name});

  final String name;

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  var _pin = '';

  void _press(String key) => setState(() {
    if (key == '⌫') {
      if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
    } else if (_pin.length < 8) {
      _pin += key;
    }
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('PIN für ${widget.name}'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _pin.isEmpty ? '–' : '•' * _pin.length,
              style: const TextStyle(fontSize: 32, letterSpacing: 8),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.6,
              children: [
                for (final key in [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '⌫',
                  '0',
                  'OK',
                ])
                  TvFocusable(
                    autofocus: key == '1',
                    onSelect: key == 'OK'
                        ? (_pin.length >= 4
                              ? () => Navigator.of(context).pop(_pin)
                              : null)
                        : () => _press(key),
                    child: Center(
                      child: Text(key, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
