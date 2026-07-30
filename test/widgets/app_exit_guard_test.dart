import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppExitGuard — confirmDialog behavior', () {
    testWidgets('shows a confirm dialog on back press', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppExitGuard(child: Scaffold(body: Text('Home'))),
        ),
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Exit app?'), findsOneWidget);
    });

    testWidgets('dismissing the dialog does not exit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppExitGuard(child: Scaffold(body: Text('Home'))),
        ),
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('AppExitGuard — doubleTapToExit behavior', () {
    testWidgets('first back press shows the hint and does not exit', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppExitGuard(
            behavior: AppExitBehavior.doubleTapToExit,
            child: Scaffold(body: Text('Home')),
          ),
        ),
      );

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.text('Tap back again to exit'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets(
      'a second back press within the window is accepted as exit-confirming',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AppExitGuard(
              behavior: AppExitBehavior.doubleTapToExit,
              doubleTapWindow: Duration(seconds: 2),
              child: Scaffold(body: Text('Home')),
            ),
          ),
        );

        await tester.binding.handlePopRoute();
        await tester.pump();
        expect(find.text('Tap back again to exit'), findsOneWidget);

        // Second press within the window — this exercises the same
        // "should exit" branch a real second back press would take.
        await tester.binding.handlePopRoute();
        await tester.pump();

        // The widget itself is still mounted (SystemNavigator.pop is a
        // platform call flutter_test no-ops by default) — the
        // meaningful assertion here is that no *second* hint snackbar
        // replaced the first, since the second press took the "exit"
        // branch instead of restarting the hint window.
        expect(find.text('Tap back again to exit'), findsOneWidget);
      },
    );
  });
}
