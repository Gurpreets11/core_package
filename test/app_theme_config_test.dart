import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const config = AppThemeConfig(
    primary: Color(0xFF112233),
    secondary: Color(0xFF445566),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF0F0F0),
    error: Color(0xFFAA0000),
  );

  group('AppThemeConfig.toThemeData', () {
    test('light mode uses light background/surface colors', () {
      final theme = config.toThemeData();
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, config.background);
      expect(theme.colorScheme.surface, config.surface);
    });

    test('dark mode uses dark background/surface colors', () {
      final theme = config.toThemeData(brightness: Brightness.dark);
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, config.darkBackground);
      expect(theme.colorScheme.surface, config.darkSurface);
    });

    test(
      'brand colors (primary/secondary/error) stay the same across modes',
      () {
        final light = config.toThemeData();
        final dark = config.toThemeData(brightness: Brightness.dark);
        expect(light.colorScheme.primary, dark.colorScheme.primary);
        expect(light.colorScheme.secondary, dark.colorScheme.secondary);
        expect(light.colorScheme.error, dark.colorScheme.error);
      },
    );
  });

  group('AppThemeConfig.spacing', () {
    test('derives the named scale from spacingUnit', () {
      final custom = config.copyWith(spacingUnit: 10);
      expect(custom.spacing.xs, 5);
      expect(custom.spacing.sm, 10);
      expect(custom.spacing.md, 20);
      expect(custom.spacing.lg, 30);
      expect(custom.spacing.xl, 40);
    });
  });

  group('AppThemeConfig.copyWith', () {
    test('overrides only the specified fields', () {
      final updated = config.copyWith(primary: const Color(0xFF000000));
      expect(updated.primary, const Color(0xFF000000));
      expect(updated.secondary, config.secondary);
      expect(updated.background, config.background);
    });
  });

  group('AppThemeConfig — resolved card/field styling', () {
    test('resolvedCardBorderRadius falls back to borderRadius when unset', () {
      expect(config.resolvedCardBorderRadius, config.borderRadius);
    });

    test('cardStyle.borderRadius overrides the shared borderRadius', () {
      final custom = config.copyWith(
        cardStyle: const AppCardStyle(borderRadius: 20),
      );
      expect(custom.resolvedCardBorderRadius, 20);
      // The shared value is untouched — only cards are affected.
      expect(custom.borderRadius, config.borderRadius);
    });

    test('resolvedCardBackgroundColor falls back to surface when unset', () {
      expect(config.resolvedCardBackgroundColor, config.surface);
    });

    test('cardStyle.backgroundColor overrides the shared surface color', () {
      final custom = config.copyWith(
        cardStyle: const AppCardStyle(backgroundColor: Color(0xFF00FF00)),
      );
      expect(custom.resolvedCardBackgroundColor, const Color(0xFF00FF00));
    });

    test('resolvedFieldBorderRadius falls back to borderRadius when unset', () {
      expect(config.resolvedFieldBorderRadius, config.borderRadius);
    });

    test('fieldStyle.borderRadius overrides the shared borderRadius', () {
      final custom = config.copyWith(
        fieldStyle: const AppFieldStyle(borderRadius: 4),
      );
      expect(custom.resolvedFieldBorderRadius, 4);
    });
  });

  group('AppThemeConfig.resolvedFor', () {
    test('is a no-op for Brightness.light', () {
      final resolved = config.resolvedFor(Brightness.light);
      expect(resolved.surface, config.surface);
      expect(resolved.background, config.background);
      expect(resolved.onSurface, config.onSurface);
      expect(resolved.onBackground, config.onBackground);
    });

    test('swaps surface/background/onSurface/onBackground for dark', () {
      final resolved = config.resolvedFor(Brightness.dark);
      expect(resolved.surface, config.darkSurface);
      expect(resolved.background, config.darkBackground);
      expect(resolved.onSurface, config.onDarkSurface);
      expect(resolved.onBackground, config.onDarkBackground);
    });

    test('does not alter brand colors or explicit cardStyle overrides', () {
      final withCardOverride = config.copyWith(
        cardStyle: const AppCardStyle(backgroundColor: Color(0xFF123456)),
      );
      final resolved = withCardOverride.resolvedFor(Brightness.dark);

      expect(resolved.primary, config.primary);
      expect(resolved.secondary, config.secondary);
      expect(
        resolved.cardStyle.backgroundColor,
        const Color(0xFF123456),
      );
    });
  });
}
