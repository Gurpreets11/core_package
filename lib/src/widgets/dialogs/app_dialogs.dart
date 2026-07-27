import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';
import '../buttons/app_button.dart';

/// A single option shown in an [AppActionSheet].
class AppActionSheetItem {
  /// Creates an [AppActionSheetItem].
  const AppActionSheetItem({
    required this.label,
    required this.value,
    this.icon,
    this.isDestructive = false,
  });

  /// The option's display label.
  final String label;

  /// The value returned from [AppDialogs.showActionSheet] when tapped.
  final Object value;

  /// An optional leading icon.
  final IconData? icon;

  /// Renders the label in the theme's error color, for destructive
  /// actions (e.g. "Delete", "Log out").
  final bool isDestructive;
}

/// Themed dialog and bottom-sheet helpers, so every app confirms
/// destructive actions, shows alerts, and presents action sheets the
/// same way instead of each screen building its own `AlertDialog`.
abstract final class AppDialogs {
  /// Shows a confirm/cancel dialog. Returns `true` if the user
  /// confirmed, `false` if they cancelled or dismissed it.
  ///
  /// ```dart
  /// final confirmed = await AppDialogs.showConfirm(
  ///   context,
  ///   title: 'Delete lead?',
  ///   message: 'This can\'t be undone.',
  ///   isDestructive: true,
  /// );
  /// ```
  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final config = AppThemeScope.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? config.error : config.primary,
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Shows a single-button alert dialog (e.g. an error message).
  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String dismissLabel = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dismissLabel),
          ),
        ],
      ),
    );
  }

  /// Shows a bottom-sheet action list and returns the tapped item's
  /// [AppActionSheetItem.value], or `null` if dismissed.
  static Future<T?> showActionSheet<T extends Object>(
    BuildContext context, {
    String? title,
    required List<AppActionSheetItem> items,
  }) {
    final config = AppThemeScope.of(context);

    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(config.borderRadius),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: EdgeInsets.all(config.spacing.md),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            for (final item in items)
              ListTile(
                leading: item.icon != null ? Icon(item.icon) : null,
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: item.isDestructive ? config.error : null,
                  ),
                ),
                onTap: () => Navigator.of(sheetContext).pop(item.value as T),
              ),
          ],
        ),
      ),
    );
  }
}

/// A convenience wrapper for showing an [AppButton]-driven confirm
/// bottom sheet when you need more than the two-button [AppDialogs]
/// confirm dialog (e.g. a longer message plus a full-width CTA).
class AppConfirmSheet extends StatelessWidget {
  /// Creates an [AppConfirmSheet].
  const AppConfirmSheet({
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmLabel = 'Confirm',
    this.isDestructive = false,
    super.key,
  });

  /// The sheet's title.
  final String title;

  /// The sheet's body message.
  final String message;

  /// Called when the confirm button is tapped, before the sheet closes.
  final VoidCallback onConfirm;

  /// The confirm button's label.
  final String confirmLabel;

  /// Renders the confirm button in the theme's error color.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(config.spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: config.spacing.xs),
            Text(message),
            SizedBox(height: config.spacing.md),
            AppButton(
              label: confirmLabel,
              variant: isDestructive
                  ? AppButtonVariant.secondary
                  : AppButtonVariant.primary,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
