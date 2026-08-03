import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const baseConfig = AppThemeConfig(
    primary: Color(0xFF112233),
    secondary: Color(0xFF445566),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFEEEEEE),
    error: Color(0xFFAA0000),
  );

  Widget wrap(AppThemeConfig config, Widget child) {
    return MaterialApp(
      home: AppThemeScope(config: config, child: Scaffold(body: child)),
    );
  }

  group('AppCard', () {
    testWidgets('uses the theme surface color and default elevation', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(baseConfig, const AppCard(child: Text('x'))),
      );

      final material = tester.widget<Material>(find.byType(Material).last);
      expect(material.color, baseConfig.surface);
      expect(material.elevation, 1);
    });

    testWidgets('cardStyle.backgroundColor overrides the surface color', (
      tester,
    ) async {
      final config = baseConfig.copyWith(
        cardStyle: const AppCardStyle(backgroundColor: Color(0xFF00FF00)),
      );

      await tester.pumpWidget(wrap(config, const AppCard(child: Text('x'))));

      final material = tester.widget<Material>(find.byType(Material).last);
      expect(material.color, const Color(0xFF00FF00));
    });

    testWidgets('cardStyle.elevation overrides the default elevation', (
      tester,
    ) async {
      final config = baseConfig.copyWith(
        cardStyle: const AppCardStyle(elevation: 6),
      );

      await tester.pumpWidget(wrap(config, const AppCard(child: Text('x'))));

      final material = tester.widget<Material>(find.byType(Material).last);
      expect(material.elevation, 6);
    });

    testWidgets('an explicit padding parameter wins over cardStyle.padding', (
      tester,
    ) async {
      final config = baseConfig.copyWith(
        cardStyle: const AppCardStyle(padding: EdgeInsets.all(2)),
      );

      await tester.pumpWidget(
        wrap(
          config,
          const AppCard(padding: EdgeInsets.all(40), child: Text('x')),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.all(40));
    });
  });
}
