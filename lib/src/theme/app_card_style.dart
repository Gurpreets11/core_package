import 'package:flutter/material.dart';

/// Component-level style tokens for [AppCard], letting an app override
/// card appearance independently of the global
/// [AppThemeConfig.borderRadius]/[AppThemeConfig.surface] — e.g. a flat
/// (zero-elevation) card style, or cards with a different corner
/// radius than buttons/fields.
///
/// Leave any field `null` to fall back to the corresponding
/// [AppThemeConfig] value.
@immutable
class AppCardStyle {
  /// Creates an [AppCardStyle]. All fields are optional overrides.
  const AppCardStyle({
    this.elevation = 1,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
  });

  /// The card's shadow elevation.
  final double elevation;

  /// Overrides [AppThemeConfig.borderRadius] for cards specifically.
  /// `null` falls back to the theme's shared radius.
  final double? borderRadius;

  /// Overrides [AppThemeConfig.surface] for cards specifically. `null`
  /// falls back to the theme's shared surface color.
  final Color? backgroundColor;

  /// Overrides the default internal padding (`spacing.md`). `null`
  /// falls back to that default.
  final EdgeInsetsGeometry? padding;

  /// Returns a copy of this style with the given fields replaced.
  AppCardStyle copyWith({
    double? elevation,
    double? borderRadius,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCardStyle(
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
    );
  }
}
