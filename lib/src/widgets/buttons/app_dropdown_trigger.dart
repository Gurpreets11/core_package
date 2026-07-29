import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A compact, pill-shaped trigger button for opening a dropdown menu,
/// filter sheet, or popup — the common "Sort by ▾" / "Status ▾"
/// control seen in list/filter bars. This is distinct from
/// [AppDropdownField]: that's a form field holding a selected value;
/// this is just a tappable trigger with an animated arrow, and leaves
/// what actually opens (a menu, [AppDialogs.showActionSheet], a custom
/// popup) entirely to the caller.
///
/// The arrow rotates open automatically while [onTap]'s returned
/// future is pending, and back closed once it completes — so wiring
/// this up to, say, [AppDialogs.showActionSheet] (which already
/// returns a `Future`) gets the correct open/close animation for free,
/// with no external state to manage.
///
/// ```dart
/// AppDropdownTrigger(
///   label: 'Sort by: Newest',
///   onTap: () => AppDialogs.showActionSheet<SortOrder>(
///     context,
///     title: 'Sort by',
///     items: sortOptions,
///   ),
/// )
/// ```
class AppDropdownTrigger extends StatefulWidget {
  /// Creates an [AppDropdownTrigger].
  const AppDropdownTrigger({
    required this.label,
    required this.onTap,
    this.icon = Icons.keyboard_arrow_down,
    this.leadingIcon,
    super.key,
  });

  /// The trigger's label text.
  final String label;

  /// Called on tap. The arrow animates open while this future is
  /// pending, and closed once it resolves.
  final Future<void> Function() onTap;

  /// The arrow icon, rotated 180° while open. Defaults to
  /// [Icons.keyboard_arrow_down].
  final IconData icon;

  /// An optional icon shown before [label] (e.g. a filter icon).
  final IconData? leadingIcon;

  @override
  State<AppDropdownTrigger> createState() => _AppDropdownTriggerState();
}

class _AppDropdownTriggerState extends State<AppDropdownTrigger> {
  bool _isOpen = false;

  Future<void> _handleTap() async {
    setState(() => _isOpen = true);
    try {
      await widget.onTap();
    } finally {
      if (mounted) setState(() => _isOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Material(
      color: config.surface,
      borderRadius: BorderRadius.circular(config.borderRadius * 2),
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(config.borderRadius * 2),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: config.spacing.sm,
            vertical: config.spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: 18),
                SizedBox(width: config.spacing.xs),
              ],
              Text(widget.label),
              SizedBox(width: config.spacing.xs / 2),
              AnimatedRotation(
                turns: _isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(widget.icon, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
