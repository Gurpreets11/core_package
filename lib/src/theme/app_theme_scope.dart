import 'package:flutter/material.dart';

import 'app_theme_config.dart';

/// Makes an [AppThemeConfig] available to the widget tree below it.
///
/// Wrap the app's root widget once:
/// ```dart
/// AppThemeScope(
///   config: myAppThemeConfig,
///   child: MaterialApp(
///     theme: myAppThemeConfig.toThemeData(),
///     home: const HomeScreen(),
///   ),
/// )
/// ```
/// Then read it anywhere with `AppThemeScope.of(context)`.
class AppThemeScope extends InheritedWidget {
  /// Creates an [AppThemeScope] exposing [config] to descendants.
  const AppThemeScope({
    required this.config,
    required super.child,
    super.key,
  });

  /// The active theme configuration.
  final AppThemeConfig config;

  /// Retrieves the nearest [AppThemeConfig] above [context], resolved
  /// for the currently active [Brightness] (see
  /// [AppThemeConfig.resolvedFor]) — so `config.surface`/
  /// `config.onSurface`/etc. always reflect light or dark mode
  /// correctly, whichever is active, with no special-casing needed at
  /// the call site.
  ///
  /// Falls back to [AppThemeConfig.fallback] if no [AppThemeScope] is
  /// found, so shared widgets never crash when used outside a fully
  /// configured app (e.g. in isolated widget tests).
  static AppThemeConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    final config = scope?.config ?? AppThemeConfig.fallback();
    return config.resolvedFor(Theme.of(context).brightness);
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) =>
      config != oldWidget.config;
}
