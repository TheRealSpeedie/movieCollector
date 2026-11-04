import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/add/presentation/add_sheet.dart';
import 'theme/speednema_colors.dart';
import 'theme/tokens.g.dart';

/// Width breakpoints, by available space rather than device type.
abstract final class Breakpoints {
  /// From here a navigation rail replaces the bottom bar.
  static const medium = 600.0;

  /// From here the rail shows labels beside its icons.
  static const expanded = 1200.0;
}

class _Destination {
  const _Destination(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// The five top-level sections. Same functions at every size; only the
/// navigation's form changes: bottom bar on phones, rail on tablets and
/// desktop windows. Tabs only navigate; "+" in the rail adds.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _Destination(Icons.home_outlined, Icons.home, 'Home'),
    _Destination(Icons.video_library_outlined, Icons.video_library, 'Sammlung'),
    _Destination(Icons.explore_outlined, Icons.explore, 'Entdecken'),
    _Destination(
      Icons.document_scanner_outlined,
      Icons.document_scanner,
      'Fundstück',
    ),
    _Destination(Icons.more_horiz, Icons.more_horiz, 'Mehr'),
  ];

  void _select(int index) => navigationShell.goBranch(
    index,
    // Tapping the current tab again returns to its start.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < Breakpoints.medium) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _select,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final extended = width >= Breakpoints.expanded;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            minExtendedWidth: 220,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _select,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: extended
                  ? FloatingActionButton.extended(
                      heroTag: 'add',
                      elevation: 0,
                      onPressed: () => showAddSheet(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Hinzufügen'),
                    )
                  : FloatingActionButton(
                      heroTag: 'add',
                      elevation: 0,
                      tooltip: 'Hinzufügen',
                      onPressed: () => showAddSheet(context),
                      child: const Icon(Icons.add),
                    ),
            ),
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
            ],
          ),
          VerticalDivider(width: 1, color: context.colors.hairline),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
