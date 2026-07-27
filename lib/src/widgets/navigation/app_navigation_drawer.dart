import 'package:flutter/material.dart';

import '../../theme/app_theme_config.dart';
import '../../theme/app_theme_scope.dart';

/// A single item in an [AppNavigationDrawer].
class AppDrawerItem {
  /// Creates an [AppDrawerItem].
  const AppDrawerItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  /// The item's label.
  final String label;

  /// The item's leading icon.
  final IconData icon;

  /// Called when the item is tapped.
  final VoidCallback onTap;

  /// Whether to highlight this item as the current screen.
  final bool isSelected;
}

/// A themed navigation drawer with a header (avatar/name/org — whatever
/// the app supplies) and a configurable list of [AppDrawerItem]s, so
/// every app wires its drawer the same way instead of rebuilding
/// `Drawer` + `ListView` boilerplate per project.
///
/// ```dart
/// Scaffold(
///   drawer: AppNavigationDrawer(
///     header: UserAccountsDrawerHeader(
///       accountName: Text(user.name),
///       accountEmail: Text(user.email),
///     ),
///     items: [
///       AppDrawerItem(
///         label: 'Dashboard',
///         icon: Icons.dashboard_outlined,
///         isSelected: true,
///         onTap: () => context.go('/dashboard'),
///       ),
///       AppDrawerItem(
///         label: 'Leads',
///         icon: Icons.people_outline,
///         onTap: () => context.go('/leads'),
///       ),
///     ],
///     footerItems: [
///       AppDrawerItem(
///         label: 'Log out',
///         icon: Icons.logout,
///         onTap: () => authController.logout(),
///       ),
///     ],
///   ),
/// )
/// ```
class AppNavigationDrawer extends StatelessWidget {
  /// Creates an [AppNavigationDrawer].
  const AppNavigationDrawer({
    required this.items,
    this.header,
    this.footerItems = const [],
    super.key,
  });

  /// An optional header widget (commonly a `UserAccountsDrawerHeader`
  /// or a custom brand header — left to the app to build, since header
  /// content is highly app-specific).
  final Widget? header;

  /// The primary navigation items.
  final List<AppDrawerItem> items;

  /// Items pinned below a divider at the bottom (e.g. Settings, Log out).
  final List<AppDrawerItem> footerItems;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final item in items) _buildTile(item, config),
                ],
              ),
            ),
            if (footerItems.isNotEmpty) ...[
              const Divider(height: 1),
              for (final item in footerItems) _buildTile(item, config),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTile(AppDrawerItem item, AppThemeConfig config) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: item.isSelected ? config.primary : null,
      ),
      title: Text(
        item.label,
        style: TextStyle(
          color: item.isSelected ? config.primary : null,
          fontWeight: item.isSelected ? FontWeight.w600 : null,
        ),
      ),
      selected: item.isSelected,
      onTap: item.onTap,
    );
  }
}
