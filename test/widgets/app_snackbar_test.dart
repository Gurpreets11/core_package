import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(WidgetBuilder builder) {
    return MaterialApp(home: Scaffold(body: Builder(builder: builder)));
  }

  group('AppSnackbar', () {
    testWidgets('showSuccess displays the given message', (tester) async {
      await tester.pumpWidget(
        wrap(
          (context) => ElevatedButton(
            onPressed: () => AppSnackbar.showSuccess(context, 'Saved!'),
            child: const Text('trigger'),
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();

      expect(find.text('Saved!'), findsOneWidget);
    });

    testWidgets('showError displays the given message', (tester) async {
      await tester.pumpWidget(
        wrap(
          (context) => ElevatedButton(
            onPressed: () => AppSnackbar.showError(context, 'Failed to save'),
            child: const Text('trigger'),
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();

      expect(find.text('Failed to save'), findsOneWidget);
    });

    testWidgets('a new snackbar replaces a currently showing one', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          (context) => ElevatedButton(
            onPressed: () {
              AppSnackbar.show(context, 'first');
              AppSnackbar.show(context, 'second');
            },
            child: const Text('trigger'),
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();

      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);
    });
  });
}
