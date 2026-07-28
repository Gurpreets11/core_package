import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A single destination in an [AppBottomNavBar].
class AppBottomNavItem {
  /// Creates an [AppBottomNavItem].
  const AppBottomNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  /// The destination's label.
  final String label;

  /// The icon shown when not selected.
  final IconData icon;

  /// The icon shown when selected. Falls back to [icon] if omitted.
  final IconData? selectedIcon;
}

/// A themed bottom navigation bar, wrapping Material 3's
/// [NavigationBar] with the app's brand color for the selection
/// indicator.
///
/// ```dart
/// Scaffold(
///   bottomNavigationBar: AppBottomNavBar(
///     currentIndex: selectedTab,
///     onTap: (index) => setState(() => selectedTab = index),
///     items: const [
///       AppBottomNavItem(label: 'Home', icon: Icons.home_outlined,
///           selectedIcon: Icons.home),
///       AppBottomNavItem(label: 'Leads', icon: Icons.people_outline,
///           selectedIcon: Icons.people),
///       AppBottomNavItem(label: 'Profile', icon: Icons.person_outline,
///           selectedIcon: Icons.person),
///     ],
///   ),
/// )
/// ```
class AppBottomNavBar extends StatelessWidget {
  /// Creates an [AppBottomNavBar].
  const AppBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  /// The destinations to show.
  final List<AppBottomNavItem> items;

  /// The index of the currently selected destination.
  final int currentIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: config.primary.withValues(alpha: 0.12),
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon ?? item.icon),
            label: item.label,
          ),
      ],
    );
  }
}
