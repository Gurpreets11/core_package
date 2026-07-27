import 'package:flutter/material.dart';

import '../../theme/app_theme_config.dart';
import '../../theme/app_theme_scope.dart';

/// The visual style of an [AppButton].
enum AppButtonVariant {
  /// A filled, high-emphasis button using the theme's primary color.
  primary,

  /// A filled, medium-emphasis button using the theme's secondary color.
  secondary,

  /// A low-emphasis, text-only button.
  text,

  /// An outlined, medium-emphasis button.
  outlined,
}

/// A themed button consuming [AppThemeScope] — never a hardcoded color —
/// with a built-in loading state so screens don't need to hand-roll a
/// spinner-vs-label swap every time.
///
/// ```dart
/// AppButton(
///   label: 'Sign in',
///   isLoading: authState.isLoading,
///   onPressed: () => controller.login(),
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expand = true,
    super.key,
  });

  /// The button's label text. Hidden (but still laid out for sizing)
  /// while [isLoading] is `true`.
  final String label;

  /// Called when the button is tapped. If `null`, the button renders in
  /// a disabled state regardless of [isLoading].
  final VoidCallback? onPressed;

  /// The visual style to render.
  final AppButtonVariant variant;

  /// When `true`, shows a spinner in place of [label] and disables
  /// taps — the caller doesn't need to also null out [onPressed].
  final bool isLoading;

  /// An optional leading icon, hidden while [isLoading].
  final IconData? icon;

  /// Whether the button should fill the available width. Defaults to
  /// `true`, matching common form/CTA layouts.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _foregroundColor(config),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                SizedBox(width: config.spacing.xs),
              ],
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: config.primary,
            foregroundColor: config.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: config.secondary,
            foregroundColor: config.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: config.primary,
            side: BorderSide(color: config.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(foregroundColor: config.primary),
          child: child,
        ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Color _foregroundColor(AppThemeConfig config) {
    return switch (variant) {
      AppButtonVariant.primary => config.onPrimary,
      AppButtonVariant.secondary => config.onSecondary,
      AppButtonVariant.outlined || AppButtonVariant.text => config.primary,
    };
  }
}
