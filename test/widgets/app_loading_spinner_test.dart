import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppLoadingSpinner', () {
    testWidgets('default constructor sizes to 24 logical pixels', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const AppLoadingSpinner()));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 24);
      expect(sizedBox.height, 24);
    });

    testWidgets('.small sizes to 16 logical pixels', (tester) async {
      await tester.pumpWidget(wrap(const AppLoadingSpinner.small()));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 16);
      expect(sizedBox.height, 16);
    });

    testWidgets('.large sizes to 40 logical pixels', (tester) async {
      await tester.pumpWidget(wrap(const AppLoadingSpinner.large()));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 40);
      expect(sizedBox.height, 40);
    });

    testWidgets('applies a custom color to the arc', (tester) async {
      await tester.pumpWidget(
        wrap(const AppLoadingSpinner(color: Colors.red)),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(
        (indicator.valueColor as AlwaysStoppedAnimation<Color>?)?.value,
        Colors.red,
      );
    });
  });
}
