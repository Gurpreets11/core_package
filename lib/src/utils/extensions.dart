import 'package:flutter/material.dart';

import '../theme/app_theme_config.dart';
import '../theme/app_theme_scope.dart';

/// Common string helpers used across screens.
extension AppStringX on String {
  /// Whether this string is empty after trimming whitespace.
  bool get isBlank => trim().isEmpty;

  /// Whether this string has non-whitespace content.
  bool get isNotBlank => !isBlank;

  /// Returns this string with its first character upper-cased (e.g.
  /// "leads" → "Leads"). Leaves an already-capitalized or empty string
  /// unchanged.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns up to 2 initials derived from this string, treated as a
  /// name (e.g. "Jane Doe" → "JD", "Jane" → "J").
  String get initials {
    final parts = trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// Common [BuildContext] helpers, mainly shortcuts for values shared
/// widgets already read via [AppThemeScope]/[MediaQuery]/[Theme].
extension AppContextX on BuildContext {
  /// Shortcut for `AppThemeScope.of(this)`.
  AppThemeConfig get appTheme => AppThemeScope.of(this);

  /// Shortcut for `MediaQuery.sizeOf(this)`.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Whether the current [Theme] is in dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Dismisses the on-screen keyboard, if visible.
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
