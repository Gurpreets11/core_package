import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A themed circular loading spinner with a visible background track
/// ring behind the animated arc — reads as a "bordered" spinner rather
/// than a bare arc floating on nothing, and gives every loading state
/// across the app the same look instead of a raw
/// `CircularProgressIndicator` per screen.
///
/// ```dart
/// const AppLoadingSpinner()               // default size
/// const AppLoadingSpinner.small()         // compact, e.g. inside a button
/// const AppLoadingSpinner.large()         // a full-screen loading state
/// AppLoadingSpinner(color: Colors.white)  // override the arc color
/// ```
class AppLoadingSpinner extends StatelessWidget {
  /// Creates a medium [AppLoadingSpinner] (24 logical pixels).
  const AppLoadingSpinner({
    this.size = 24,
    this.strokeWidth = 3,
    this.color,
    this.trackColor,
    super.key,
  });

  /// Creates a small [AppLoadingSpinner] (16 logical pixels) — sized
  /// for use inside buttons or list rows.
  const AppLoadingSpinner.small({this.color, this.trackColor, super.key})
      : size = 16,
        strokeWidth = 2;

  /// Creates a large [AppLoadingSpinner] (40 logical pixels) — sized
  /// for a full-screen or full-card loading state.
  const AppLoadingSpinner.large({this.color, this.trackColor, super.key})
      : size = 40,
        strokeWidth = 4;

  /// The spinner's diameter, in logical pixels.
  final double size;

  /// The arc's stroke width.
  final double strokeWidth;

  /// The animated arc's color. Defaults to the theme's primary color.
  final Color? color;

  /// The background track ring's color. Defaults to a faint tint of
  /// the theme's `onSurface` color.
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? config.primary),
        backgroundColor: trackColor ?? config.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}
