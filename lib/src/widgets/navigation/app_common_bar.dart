import 'package:flutter/material.dart';

/// A themed [AppBar] wrapper — mainly exists so every screen constructs
/// its app bar the same way (and so future shared behavior, like a
/// consistent back-button icon or a global search action, has one place
/// to live) rather than each screen configuring `AppBar` from scratch.
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
    super.key,
  });

  /// The title text shown in the app bar.
  final String title;

  /// Trailing action widgets (icons/buttons).
  final List<Widget>? actions;

  /// Whether to show the automatic back/close button when there's a
  /// route to pop. Set to `false` on root screens (e.g. the home tab).
  final bool showBackButton;

  /// An optional bottom widget (e.g. a `TabBar`).
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      automaticallyImplyLeading: showBackButton,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
