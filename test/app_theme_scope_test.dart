import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const themeConfig = AppThemeConfig(
    primary: Color(0xFF112233),
    secondary: Color(0xFF445566),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF0F0F0),
    error: Color(0xFFAA0000),
    onSurface: Colors.black,
    darkSurface: Color(0xFF1E1E1E),
    onDarkSurface: Colors.white,
  );

  /// Mirrors the real app's setup: [AppThemeScope] wrapping
  /// `MaterialApp`, with both `theme`/`darkTheme` supplied and
  /// [themeMode] controlling which is active — exactly the setup that
  /// exposed the original bug.
  Widget wrap(ThemeMode themeMode, WidgetBuilder builder) {
    return AppThemeScope(
      config: themeConfig,
      child: MaterialApp(
        theme: themeConfig.toThemeData(),
        darkTheme: themeConfig.toThemeData(brightness: Brightness.dark),
        themeMode: themeMode,
        home: Builder(builder: builder),
      ),
    );
  }

  group('AppThemeScope.of — brightness resolution (regression)', () {
    testWidgets('returns the light surface/onSurface in light mode', (
      tester,
    ) async {
      late AppThemeConfig resolved;
      await tester.pumpWidget(
        wrap(ThemeMode.light, (context) {
          resolved = AppThemeScope.of(context);
          return const SizedBox.shrink();
        }),
      );

      expect(resolved.surface, themeConfig.surface);
      expect(resolved.onSurface, themeConfig.onSurface);
    });

    testWidgets(
      'returns the DARK surface/onSurface in dark mode — this was the bug: '
      'it previously always returned the light values, making text '
      'invisible against dark-mode backgrounds',
      (tester) async {
        late AppThemeConfig resolved;
        await tester.pumpWidget(
          wrap(ThemeMode.dark, (context) {
            resolved = AppThemeScope.of(context);
            return const SizedBox.shrink();
          }),
        );

        expect(resolved.surface, themeConfig.darkSurface);
        expect(resolved.onSurface, themeConfig.onDarkSurface);
      },
    );

    testWidgets(
      'a widget built with it renders readable contrast in dark mode',
      (tester) async {
        await tester.pumpWidget(
          wrap(ThemeMode.dark, (context) {
            final config = AppThemeScope.of(context);
            // Simulates what AppCard/AppEmptyState do: background from
            // config.surface, foreground from config.onSurface.
            return ColoredBox(
              key: const Key('contrast-test-box'),
              color: config.surface,
              child: Text(
                'Settings',
                style: TextStyle(color: config.onSurface),
              ),
            );
          }),
        );

        final coloredBox = tester.widget<ColoredBox>(
          find.byKey(const Key('contrast-test-box')),
        );
        final text = tester.widget<Text>(find.text('Settings'));

        expect(coloredBox.color, themeConfig.darkSurface);
        expect(text.style?.color, themeConfig.onDarkSurface);
        // The two must not be equal, or the text would be invisible.
        expect(coloredBox.color, isNot(text.style?.color));
      },
    );
  });
}
