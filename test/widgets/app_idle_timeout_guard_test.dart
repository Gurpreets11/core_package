import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppIdleTimeoutGuard', () {
    testWidgets('calls onTimeout after the timeout with no interaction', (
      tester,
    ) async {
      var timedOut = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AppIdleTimeoutGuard(
            timeout: const Duration(milliseconds: 100),
            onTimeout: () => timedOut = true,
            child: const Scaffold(body: Text('content')),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 150));
      expect(timedOut, isTrue);
    });

    testWidgets('a tap resets the timer, delaying onTimeout', (tester) async {
      var timedOut = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AppIdleTimeoutGuard(
            timeout: const Duration(milliseconds: 100),
            onTimeout: () => timedOut = true,
            child: Scaffold(
              body: TextButton(onPressed: () {}, child: const Text('tap')),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 60));
      await tester.tap(find.text('tap'));
      await tester.pump(const Duration(milliseconds: 60));
      // 120ms have elapsed in total, but the tap at 60ms reset the
      // clock, so only 60ms have passed since — not yet timed out.
      expect(timedOut, isFalse);

      await tester.pump(const Duration(milliseconds: 50));
      expect(timedOut, isTrue);
    });

    testWidgets('does not call onTimeout when enabled is false', (
      tester,
    ) async {
      var timedOut = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AppIdleTimeoutGuard(
            enabled: false,
            timeout: const Duration(milliseconds: 100),
            onTimeout: () => timedOut = true,
            child: const Scaffold(body: Text('content')),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 150));
      expect(timedOut, isFalse);
    });
  });
}
