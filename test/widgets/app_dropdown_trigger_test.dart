import 'dart:async';

import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppDropdownTrigger', () {
    testWidgets('shows the label', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppDropdownTrigger(
            label: 'Sort by: Newest',
            onTap: () async {},
          ),
        ),
      );

      expect(find.text('Sort by: Newest'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        wrap(
          AppDropdownTrigger(
            label: 'Sort by',
            onTap: () async => tapCount++,
          ),
        ),
      );

      await tester.tap(find.text('Sort by'));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    });

    testWidgets('rotates the arrow open while onTap is pending, closed after', (
      tester,
    ) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        wrap(
          AppDropdownTrigger(
            label: 'Sort by',
            onTap: () => completer.future,
          ),
        ),
      );

      AnimatedRotation findRotation() =>
          tester.widget<AnimatedRotation>(find.byType(AnimatedRotation));

      expect(findRotation().turns, 0);

      await tester.tap(find.text('Sort by'));
      await tester.pump();
      expect(findRotation().turns, 0.5);

      completer.complete();
      await tester.pumpAndSettle();
      expect(findRotation().turns, 0);
    });
  });
}
