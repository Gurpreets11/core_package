import 'package:flutter/material.dart';

/// Component-level style tokens for form fields ([AppTextField],
/// [AppDropdownField], [AppDateField]), letting an app override field
/// appearance independently of the global [AppThemeConfig.borderRadius]
/// — e.g. filled fields instead of outlined, or a different corner
/// radius than cards/buttons.
///
/// Leave any field `null`/`false` to fall back to the corresponding
/// [AppThemeConfig] value or Material default.
@immutable
class AppFieldStyle {
  /// Creates an [AppFieldStyle]. All fields are optional overrides.
  const AppFieldStyle({
    this.filled = false,
    this.fillColor,
    this.borderRadius,
  });

  /// Whether fields render with a filled background instead of a
  /// plain outline.
  final bool filled;

  /// The fill color when [filled] is `true`. `null` falls back to a
  /// faint tint of the theme's surface color.
  final Color? fillColor;

  /// Overrides [AppThemeConfig.borderRadius] for fields specifically.
  /// `null` falls back to the theme's shared radius.
  final double? borderRadius;

  /// Returns a copy of this style with the given fields replaced.
  AppFieldStyle copyWith({
    bool? filled,
    Color? fillColor,
    double? borderRadius,
  }) {
    return AppFieldStyle(
      filled: filled ?? this.filled,
      fillColor: fillColor ?? this.fillColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
