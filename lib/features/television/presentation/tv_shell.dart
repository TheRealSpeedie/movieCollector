import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../server/application/server_providers.dart';

/// The TV's main areas, chosen with the remote from a menu on the left.
const tvSections = [
  (path: '/home', label: 'Start', icon: Icons.home_outlined),
  (path: '/movies', label: 'Filme', icon: Icons.movie_outlined),
  (path: '/series', label: 'Serien', icon: Icons.tv_outlined),
  (path: '/continue', label: 'Weiterschauen', icon: Icons.play_circle_outline),
  (path: '/search', label: 'Suche', icon: Icons.search),
  (path: '/profiles', label: 'Profile', icon: Icons.people_outline),
  (path: '/settings', label: 'Einstellungen', icon: Icons.settings_outlined),
];

class TvShell extends ConsumerWidget {
  const TvShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(serverSessionProvider).valueOrNull?.username;
    return Scaffold(
      body: Row(
        children: [
          // A focus group, so Left from the content always lands in the menu.
          FocusTraversalGroup(
            child: Container(
              width: 240,
              color: context.colors.surface,
              padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.movie_filter, color: context.colors.accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Speednema',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (profile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 34),
                      child: Text(
                        profile,
                        style: TextStyle(color: context.colors.textSecondary),
                      ),
                    ),
                  const SizedBox(height: 24),
                  for (final section in tvSections)
                    _MenuItem(
                      label: section.label,
                      icon: section.icon,
                      selected: location.startsWith(section.path),
                      onSelect: () => context.go(section.path),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: FocusTraversalGroup(child: child)),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelect;

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  var _focused = false;

  @override
  Widget build(BuildContext context) {
    final highlight = _focused || widget.selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: _focused
            ? context.colors.accent
            : widget.selected
            ? context.colors.hairline
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onSelect,
          onFocusChange: (focused) => setState(() => _focused = focused),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: _focused
                      ? context.colors.background
                      : highlight
                      ? context.colors.text
                      : context.colors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                      color: _focused ? context.colors.background : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
