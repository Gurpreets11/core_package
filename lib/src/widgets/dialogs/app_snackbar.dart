import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';
import '../cards/app_card.dart';

/// Themed, quick, non-blocking feedback (a "Saved" toast, an error
/// message after a failed save) — the lightweight complement to
/// [AppDialogs], which is for things that need a response before the
/// user continues.
abstract final class AppSnackbar {
  /// Shows a success-toned snackbar.
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, tone: AppStatusTone.success);
  }

  /// Shows an error-toned snackbar.
  static void showError(BuildContext context, String message) {
    _show(context, message, tone: AppStatusTone.danger);
  }

  /// Shows a warning-toned snackbar.
  static void showWarning(BuildContext context, String message) {
    _show(context, message, tone: AppStatusTone.warning);
  }

  /// Shows a neutral-toned snackbar.
  static void show(BuildContext context, String message) {
    _show(context, message, tone: AppStatusTone.neutral);
  }

  static void _show(
    BuildContext context,
    String message, {
    required AppStatusTone tone,
  }) {
    final config = AppThemeScope.of(context);
    final (background, foreground) = switch (tone) {
      AppStatusTone.success => (const Color(0xFF1E7E34), Colors.white),
      AppStatusTone.warning => (const Color(0xFF9A6700), Colors.white),
      AppStatusTone.danger => (config.error, config.onError),
      AppStatusTone.neutral => (config.surface, config.onSurface),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: foreground)),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
          ),
        ),
      );
  }
}
