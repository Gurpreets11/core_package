import 'package:flutter/material.dart';

/// A single item in an [AppCommonBar]'s overflow (3-dot) menu.
class AppOverflowMenuItem {
  /// Creates an [AppOverflowMenuItem].
  const AppOverflowMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  /// The item's label.
  final String label;

  /// Called when the item is selected.
  final VoidCallback onTap;

  /// An optional leading icon.
  final IconData? icon;

  /// Renders the label/icon in the theme's error color (e.g. "Delete
  /// account", "Log out").
  final bool isDestructive;
}

/// A themed [AppBar] wrapper — mainly exists so every screen constructs
/// its app bar the same way (and so future shared behavior, like a
/// consistent back-button icon, a global search action, or an overflow
/// menu, has one place to live) rather than each screen configuring
/// `AppBar` from scratch.
///
/// Colors come from `ThemeData.appBarTheme`, which the app's theme
/// config already sets — this widget doesn't read the theme scope
/// directly so it always matches whatever `Theme.of(context)` currently
/// is (light or dark).
///
/// ```dart
/// Scaffold(
///   appBar: AppCommonBar(
///     title: 'Leads',
///     actions: [
///       IconButton(icon: Icon(Icons.search), onPressed: () {}),
///     ],
///     overflowMenuItems: [
///       AppOverflowMenuItem(
///         label: 'Settings',
///         icon: Icons.settings_outlined,
///         onTap: () => context.push('/settings'),
///       ),
///       AppOverflowMenuItem(
///         label: 'Log out',
///         icon: Icons.logout,
///         isDestructive: true,
///         onTap: () => authController.logout(),
///       ),
///     ],
///   ),
///   drawer: const AppNavigationDrawer(...),
///   body: ...,
/// )
/// ```
class AppCommonBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AppCommonBar].
  const AppCommonBar({
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.bottom,
    this.overflowMenuItems,
    super.key,
  });

  /// The title text shown in the app bar.
  final String title;

  /// Trailing action widgets (icons/buttons), shown before the
  /// overflow menu (if any).
  final List<Widget>? actions;

  /// Whether to show the automatic back/close button when there's a
  /// route to pop. Set to `false` on root screens (e.g. the home tab).
  final bool showBackButton;

  /// An optional bottom widget (e.g. a `TabBar`).
  final PreferredSizeWidget? bottom;

  /// If provided and non-empty, shows a 3-dot overflow menu as the
  /// last action, with these items in order.
  final List<AppOverflowMenuItem>? overflowMenuItems;

  @override
  Widget build(BuildContext context) {
    final items = overflowMenuItems;

    return AppBar(
      title: Text(title),
      actions: [
        ...?actions,
        if (items != null && items.isNotEmpty) _OverflowMenuButton(items),
      ],
      automaticallyImplyLeading: showBackButton,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

class _OverflowMenuButton extends StatelessWidget {
  const _OverflowMenuButton(this.items);

  final List<AppOverflowMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (index) => items[index].onTap(),
      itemBuilder: (context) => [
        for (var i = 0; i < items.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                if (items[i].icon != null) ...[
                  Icon(
                    items[i].icon,
                    color: items[i].isDestructive ? errorColor : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  items[i].label,
                  style: TextStyle(
                    color: items[i].isDestructive ? errorColor : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
