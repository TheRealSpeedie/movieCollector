import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';

/// The one way to add something to the collection, reachable from "+" on
/// Home and Sammlung and from the navigation rail: scan, search, import.
Future<void> showAddSheet(BuildContext context) {
  final router = GoRouter.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    // Sized by its content; scrolls when large text makes it taller.
    isScrollControlled: true,
    builder: (sheet) {
      void open(VoidCallback go) {
        Navigator.of(sheet).pop();
        go();
      }

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.s,
                ),
                child: Semantics(
                  header: true,
                  child: Text(
                    'Hinzufügen',
                    style: Theme.of(sheet).textTheme.titleLarge,
                  ),
                ),
              ),
              _AddOption(
                icon: Icons.qr_code_scanner,
                title: 'Barcode scannen',
                subtitle:
                    'DVD, Blu-ray oder 4K aus dem Regal oder vom Flohmarkt',
                onTap: () => open(() => router.go('/scanner')),
              ),
              _AddOption(
                icon: Icons.search,
                title: 'Titel suchen',
                subtitle: 'Film nach Namen finden',
                onTap: () => open(() => router.push('/search')),
              ),
              _AddOption(
                icon: Icons.playlist_add,
                title: 'Liste importieren',
                subtitle: 'Aus Notizen, einer Text- oder CSV-Datei',
                onTap: () => open(() => router.push('/import')),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _AddOption extends StatelessWidget {
  const _AddOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        backgroundColor: colors.tint(colors.accent),
        foregroundColor: colors.text,
        child: Icon(icon),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}

/// "+" for app bars: opens [showAddSheet].
class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Hinzufügen',
      icon: const Icon(Icons.add),
      onPressed: () => showAddSheet(context),
    );
  }
}
