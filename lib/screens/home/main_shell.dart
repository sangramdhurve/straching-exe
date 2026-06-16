import 'package:flutter/material.dart';

import '../../widgets/responsive.dart';
import '../favorites/favorites_screen.dart';
import '../routine/routines_screen.dart';
import '../settings/settings_screen.dart';
import 'home_screen.dart';

/// Root scaffold. Phones get a bottom NavigationBar; tablets/iPad (and wide
/// landscape) get a side NavigationRail — the platform-idiomatic large-screen nav.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [
    HomeScreen(),
    RoutinesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  static const _destinations = <({IconData icon, IconData selected, String label})>[
    (icon: Icons.home_outlined, selected: Icons.home, label: 'Home'),
    (icon: Icons.list_alt_outlined, selected: Icons.list_alt, label: 'Routines'),
    (icon: Icons.favorite_outline, selected: Icons.favorite, label: 'Favorites'),
    (icon: Icons.settings_outlined, selected: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(index: _index, children: _pages);

    if (isWideScreen(context)) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selected),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selected),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
