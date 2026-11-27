import 'package:flutter/material.dart';

import '../../theme/app_theme_config.dart';
import '../../theme/app_theme_scope.dart';
import '../animated/app_pressable_scale.dart';
import 'app_loading_spinner.dart';

/// The visual style of an [AppButton].
enum AppButtonVariant {
  /// A filled, high-emphasis button using the theme's primary color
  /// (or [AppButton.backgroundColor], if set).
  primary,

  /// A filled, medium-emphasis button using the theme's secondary
  /// color (or [AppButton.backgroundColor], if set).
  secondary,

  /// A low-emphasis, text-only button.
  text,

  /// An outlined, medium-emphasis button.
  outlined,

  /// A filled button with a gradient background — see
  /// [AppButton.gradient].
  gradient,
}

/// A themed button consuming [AppThemeScope] by default — but with
/// explicit escape hatches ([backgroundColor], [foregroundColor],
/// [gradient]) for the one-off button that doesn't fit the theme's two
/// brand colors — with a built-in loading state so screens don't need
/// to hand-roll a spinner-vs-label swap every time.
///
/// ```dart
/// // Theme-driven (the common case):
/// AppButton(
///   label: 'Sign in',
///   isLoading: authState.isLoading,
///   onPressed: () => controller.login(),
/// )
///
/// // A one-off custom color:
/// AppButton(
///   label: 'Add to cart',
///   backgroundColor: Colors.deepOrange,
///   onPressed: addToCart,
/// )
///
/// // A gradient CTA:
/// AppButton(
///   label: 'Upgrade to Pro',
///   variant: AppButtonVariant.gradient,
///   gradient: const LinearGradient(
///     colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
///   ),
///   onPressed: upgrade,
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
    this.backgroundColor,
    this.foregroundColor,
    this.gradient,
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

  /// Overrides the theme's color for [AppButtonVariant.primary]/
  /// [AppButtonVariant.secondary]. Has no effect on [.outlined]/[.text]
  /// (use [foregroundColor] for those) or [.gradient] (use [gradient]).
  final Color? backgroundColor;

  /// Overrides the default foreground (label/icon/spinner) color for
  /// any variant.
  final Color? foregroundColor;

  /// The gradient to use when [variant] is [AppButtonVariant.gradient].
  /// Defaults to a primary→secondary gradient from the current theme
  /// if omitted. Ignored for every other variant.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final effectiveOnPressed = isLoading ? null : onPressed;
    final resolvedForeground = _foregroundColor(config);

    final child = isLoading
        ? AppLoadingSpinner.small(color: resolvedForeground)
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
            backgroundColor: backgroundColor ?? config.primary,
            foregroundColor: resolvedForeground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? config.secondary,
            foregroundColor: resolvedForeground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: resolvedForeground,
            side: BorderSide(color: resolvedForeground),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
          ),
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(foregroundColor: resolvedForeground),
          child: child,
        ),
      AppButtonVariant.gradient => _GradientButton(
          onPressed: effectiveOnPressed,
          borderRadius: config.borderRadius,
          gradient: gradient ??
              LinearGradient(colors: [config.primary, config.secondary]),
          foregroundColor: resolvedForeground,
          shadowColor: config.primary,
          child: child,
        ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Color _foregroundColor(AppThemeConfig config) {
    if (foregroundColor != null) return foregroundColor!;
    return switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.gradient => config.onPrimary,
      AppButtonVariant.secondary => config.onSecondary,
      AppButtonVariant.outlined || AppButtonVariant.text => config.primary,
    };
  }
}

/// The gradient-filled button body for [AppButtonVariant.gradient].
/// `ElevatedButton` has no built-in gradient support, so this builds
/// the shape and disabled behavior manually: a gradient-decorated
/// container with a soft shadow, and a subtle scale-down while pressed
/// (via [AppPressableScale]) instead of an ink ripple.
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.gradient,
    required this.borderRadius,
    required this.foregroundColor,
    required this.shadowColor,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Gradient gradient;
  final double borderRadius;
  final Color foregroundColor;
  final Color shadowColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ) ??
        TextStyle(color: foregroundColor, fontWeight: FontWeight.w600);

    return Semantics(
      button: true,
      enabled: !isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: AppPressableScale(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: shadowColor.withValues(alpha: 0.30),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: DefaultTextStyle(
              style: labelStyle,
              child: IconTheme(
                data: IconThemeData(color: foregroundColor),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
