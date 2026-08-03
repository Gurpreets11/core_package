import 'package:flutter/material.dart';

import 'app_card_style.dart';
import 'app_field_style.dart';
import 'app_spacing.dart';

/// The full set of design tokens a consuming app supplies to brand the
/// shared widgets in this package.
///
/// **This is the mechanism that makes the package reusable across many
/// differently-branded apps.** Nothing in `widgets/` ever hardcodes a
/// color or text style directly — everything reads from an
/// [AppThemeConfig] supplied by the app at startup. Changing an app's
/// entire look is a one-file change here, not an edit to shared code.
///
/// Supports both light and dark mode from a single config: brand colors
/// ([primary], [secondary], [error]) stay constant across both, while
/// [toThemeData] derives the correct background/surface/on-colors for
/// whichever [Brightness] you ask for.
@immutable
class AppThemeConfig {
  /// Creates an [AppThemeConfig].
  const AppThemeConfig({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    this.onPrimary = Colors.white,
    this.onSecondary = Colors.white,
    this.onBackground = Colors.black,
    this.onSurface = Colors.black,
    this.onError = Colors.white,
    this.darkBackground = const Color(0xFF121212),
    this.darkSurface = const Color(0xFF1E1E1E),
    this.onDarkBackground = Colors.white,
    this.onDarkSurface = Colors.white,
    this.fontFamily,
    this.textTheme,
    this.spacingUnit = 8.0,
    this.borderRadius = 8.0,
    this.cardStyle = const AppCardStyle(),
    this.fieldStyle = const AppFieldStyle(),
  });

  /// A sensible neutral default — apps should override this with their
  /// own brand palette.
  factory AppThemeConfig.fallback() => const AppThemeConfig(
        primary: Color(0xFF1565C0),
        secondary: Color(0xFF00897B),
        background: Color(0xFFFAFAFA),
        surface: Colors.white,
        error: Color(0xFFD32F2F),
      );

  /// Primary brand color. Used as-is in both light and dark mode.
  final Color primary;

  /// Secondary/accent brand color. Used as-is in both light and dark mode.
  final Color secondary;

  /// Scaffold background color in light mode.
  final Color background;

  /// Card/sheet/dialog surface color in light mode.
  final Color surface;

  /// Error/destructive color. Used as-is in both light and dark mode.
  final Color error;

  /// Color used for content on top of [primary].
  final Color onPrimary;

  /// Color used for content on top of [secondary].
  final Color onSecondary;

  /// Color used for content on top of [background] in light mode.
  final Color onBackground;

  /// Color used for content on top of [surface] in light mode.
  final Color onSurface;

  /// Color used for content on top of [error].
  final Color onError;

  /// Scaffold background color in dark mode.
  final Color darkBackground;

  /// Card/sheet/dialog surface color in dark mode.
  final Color darkSurface;

  /// Color used for content on top of [darkBackground].
  final Color onDarkBackground;

  /// Color used for content on top of [darkSurface].
  final Color onDarkSurface;

  /// Optional custom font family; falls back to the platform default.
  final String? fontFamily;

  /// Optional custom text style scale. If omitted, Material's default
  /// [TextTheme] is used (with [fontFamily] applied on top of it).
  final TextTheme? textTheme;

  /// Base spacing unit (in logical pixels). Prefer reading spacing via
  /// [spacing] (e.g. `config.spacing.md`) rather than this raw value
  /// directly, for consistent naming across the app.
  final double spacingUnit;

  /// Default corner radius for buttons, cards, and form fields.
  final double borderRadius;

  /// Component-level style overrides for [AppCard]. Defaults to
  /// [AppCardStyle]'s own defaults, which fall back to this config's
  /// shared [borderRadius]/[surface].
  final AppCardStyle cardStyle;

  /// Component-level style overrides for form fields ([AppTextField],
  /// [AppDropdownField], [AppDateField]). Defaults to [AppFieldStyle]'s
  /// own defaults, which fall back to this config's shared
  /// [borderRadius].
  final AppFieldStyle fieldStyle;

  /// A named spacing scale (`xs`/`sm`/`md`/`lg`/`xl`) derived from
  /// [spacingUnit], so widgets reference `config.spacing.md` instead of
  /// re-deriving multiples of the raw unit inline.
  AppSpacing get spacing => AppSpacing(spacingUnit);

  /// The corner radius [AppCard] should actually use — [cardStyle]'s
  /// override if set, otherwise the shared [borderRadius].
  double get resolvedCardBorderRadius => cardStyle.borderRadius ?? borderRadius;

  /// The background color [AppCard] should actually use —
  /// [cardStyle]'s override if set, otherwise the shared [surface].
  Color get resolvedCardBackgroundColor => cardStyle.backgroundColor ?? surface;

  /// The corner radius form fields should actually use —
  /// [fieldStyle]'s override if set, otherwise the shared
  /// [borderRadius].
  double get resolvedFieldBorderRadius =>
      fieldStyle.borderRadius ?? borderRadius;

  /// Builds a Material [ThemeData] for the given [brightness] (defaults
  /// to light). Pass this to both `MaterialApp.theme` (light) and
  /// `MaterialApp.darkTheme` (dark) to support system-driven dark mode:
  ///
  /// ```dart
  /// MaterialApp(
  ///   theme: themeConfig.toThemeData(),
  ///   darkTheme: themeConfig.toThemeData(brightness: Brightness.dark),
  ///   themeMode: ThemeMode.system,
  /// )
  /// ```
  ThemeData toThemeData({Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: primary,
            secondary: secondary,
            surface: darkSurface,
            error: error,
            onPrimary: onPrimary,
            onSecondary: onSecondary,
            onSurface: onDarkSurface,
            onError: onError,
          )
        : ColorScheme.light(
            primary: primary,
            secondary: secondary,
            surface: surface,
            error: error,
            onPrimary: onPrimary,
            onSecondary: onSecondary,
            onSurface: onSurface,
            onError: onError,
          );

    final resolvedBackground = isDark ? darkBackground : background;
    final resolvedTextTheme = (textTheme ?? const TextTheme()).apply(
      bodyColor: isDark ? onDarkBackground : onBackground,
      displayColor: isDark ? onDarkBackground : onBackground,
      fontFamily: fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: resolvedBackground,
      fontFamily: fontFamily,
      textTheme: resolvedTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Returns a copy of this config with [surface]/[background]/
  /// [onSurface]/[onBackground] normalized to the dark variants when
  /// [brightness] is dark (a no-op for [Brightness.light]).
  ///
  /// This is what makes widgets reading `config.surface`/
  /// `config.onSurface` (via [AppThemeScope.of], which calls this
  /// automatically) always get the color appropriate for whichever
  /// mode is currently active — without each widget needing its own
  /// light/dark branching. Explicit overrides on [cardStyle]/
  /// [fieldStyle] are left untouched, since those are absolute
  /// choices, not light/dark-relative ones.
  AppThemeConfig resolvedFor(Brightness brightness) {
    if (brightness == Brightness.light) return this;
    return copyWith(
      background: darkBackground,
      surface: darkSurface,
      onBackground: onDarkBackground,
      onSurface: onDarkSurface,
    );
  }

  /// Returns a copy of this config with the given fields replaced.
  AppThemeConfig copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onBackground,
    Color? onSurface,
    Color? onError,
    Color? darkBackground,
    Color? darkSurface,
    Color? onDarkBackground,
    Color? onDarkSurface,
    String? fontFamily,
    TextTheme? textTheme,
    double? spacingUnit,
    double? borderRadius,
    AppCardStyle? cardStyle,
    AppFieldStyle? fieldStyle,
  }) {
    return AppThemeConfig(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      onError: onError ?? this.onError,
      darkBackground: darkBackground ?? this.darkBackground,
      darkSurface: darkSurface ?? this.darkSurface,
      onDarkBackground: onDarkBackground ?? this.onDarkBackground,
      onDarkSurface: onDarkSurface ?? this.onDarkSurface,
      fontFamily: fontFamily ?? this.fontFamily,
      textTheme: textTheme ?? this.textTheme,
      spacingUnit: spacingUnit ?? this.spacingUnit,
      borderRadius: borderRadius ?? this.borderRadius,
      cardStyle: cardStyle ?? this.cardStyle,
      fieldStyle: fieldStyle ?? this.fieldStyle,
    );
  }
}
