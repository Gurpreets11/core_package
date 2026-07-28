import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppSearchField', () {
    testWidgets('calls onChanged after the debounce delay', (tester) async {
      final received = <String>[];
      await tester.pumpWidget(
        wrap(
          AppSearchField(
            onChanged: received.add,
            debounceDuration: const Duration(milliseconds: 50),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'leads');
      expect(received, isEmpty);

      await tester.pump(const Duration(milliseconds: 100));
      expect(received, ['leads']);
    });

    testWidgets('only fires once for rapid typing within the debounce window', (
      tester,
    ) async {
      final received = <String>[];
      await tester.pumpWidget(
        wrap(
          AppSearchField(
            onChanged: received.add,
            debounceDuration: const Duration(milliseconds: 50),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'l');
      await tester.pump(const Duration(milliseconds: 10));
      await tester.enterText(find.byType(TextField), 'le');
      await tester.pump(const Duration(milliseconds: 10));
      await tester.enterText(find.byType(TextField), 'lea');
      await tester.pump(const Duration(milliseconds: 100));

      expect(received, ['lea']);
    });

    testWidgets('the clear button appears once text is entered and clears it', (
      tester,
    ) async {
      final received = <String>[];
      await tester.pumpWidget(
        wrap(
          AppSearchField(
            onChanged: received.add,
            debounceDuration: const Duration(milliseconds: 10),
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'lea');
      await tester.pump();
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump(const Duration(milliseconds: 20));

      expect(find.text('lea'), findsNothing);
      expect(received.last, '');
    });
  });
}
