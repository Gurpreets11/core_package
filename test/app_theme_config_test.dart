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

    test('brand colors (primary/secondary/error) stay the same across modes',
        () {
      final light = config.toThemeData();
      final dark = config.toThemeData(brightness: Brightness.dark);
      expect(light.colorScheme.primary, dark.colorScheme.primary);
      expect(light.colorScheme.secondary, dark.colorScheme.secondary);
      expect(light.colorScheme.error, dark.colorScheme.error);
    });
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
}
