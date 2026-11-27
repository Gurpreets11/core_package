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

  /// The icon shown when this destination isn't selected.
  final IconData icon;

  /// The icon shown when this destination is selected. Falls back to
  /// [icon] if omitted.
  final IconData? selectedIcon;
}

/// A themed bottom navigation bar. By default it is a rounded bar that
/// floats above the content: the selected destination expands into a
/// tinted pill that shows its label. Set [floating] to `false` for the
/// standard Material 3 [NavigationBar].
///
/// When [floating] is `true`, use it inside a `Scaffold` with
/// `extendBody: true` and leave about 100px of bottom padding in
/// scrollable content so nothing is hidden behind the bar.
///
/// ```dart
/// Scaffold(
///   extendBody: true,
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
    this.floating = true,
    super.key,
  });

  /// The destinations, in order.
  final List<AppBottomNavItem> items;

  /// The index of the currently selected destination.
  final int currentIndex;

  /// Called with the tapped destination's index.
  final ValueChanged<int> onTap;

  /// Whether to render the floating rounded style (default) or the
  /// standard Material 3 [NavigationBar].
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    if (!floating) {
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

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: config.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: config.primary.withValues(alpha: 0.14),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < items.length; i++)
                _NavButton(
                  item: items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final color =
        selected ? config.primary : config.onSurface.withValues(alpha: 0.6);

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? config.primary.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? (item.selectedIcon ?? item.icon) : item.icon,
                color: color,
                size: 24,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          item.label,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
