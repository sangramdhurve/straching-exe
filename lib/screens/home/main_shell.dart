import 'package:flutter/material.dart';

import '../../widgets/floating_nav_bar.dart';
import '../../widgets/responsive.dart';
import '../clips/clips_library_screen.dart';
import '../favorites/favorites_screen.dart';
import '../routine/routines_screen.dart';
import '../settings/settings_screen.dart';
import 'home_screen.dart';

/// Lets descendant screens (e.g. a "Browse clips" banner on Home) switch the
/// active shell tab without owning the index.
class ShellNavigator extends InheritedWidget {
  final void Function(int index) go;
  const ShellNavigator({super.key, required this.go, required super.child});

  static ShellNavigator? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellNavigator>();

  @override
  bool updateShouldNotify(ShellNavigator oldWidget) => false;
}

/// Root scaffold. Phones get a floating pill nav; tablets/iPad (and wide
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
    ClipsLibraryScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  static const _destinations = <({IconData icon, IconData selected, String label})>[
    (icon: Icons.home_outlined, selected: Icons.home, label: 'Home'),
    (icon: Icons.list_alt_outlined, selected: Icons.list_alt, label: 'Routines'),
    (icon: Icons.play_circle_outline, selected: Icons.play_circle, label: 'Clips'),
    (icon: Icons.favorite_outline, selected: Icons.favorite, label: 'Favorites'),
    (icon: Icons.settings_outlined, selected: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return ShellNavigator(
      go: (i) => setState(() => _index = i),
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
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
      bottomNavigationBar: FloatingNavBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          for (final d in _destinations)
            FloatingNavItem(
                icon: d.icon, selectedIcon: d.selected, label: d.label),
        ],
      ),
    );
  }
}
