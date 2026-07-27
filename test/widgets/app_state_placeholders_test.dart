import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppEmptyState', () {
    testWidgets('shows title and message', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppEmptyState(
            title: 'No leads yet',
            message: 'New leads will show up here.',
          ),
        ),
      );

      expect(find.text('No leads yet'), findsOneWidget);
      expect(find.text('New leads will show up here.'), findsOneWidget);
    });

    testWidgets('shows an action button only when both label and '
        'callback are provided', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppEmptyState(
            title: 'No leads yet',
            actionLabel: 'Add lead',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Add lead'), findsOneWidget);
      await tester.tap(find.text('Add lead'));
      expect(tapped, isTrue);
    });

    testWidgets('does not show an action button when onAction is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppEmptyState(title: 'No leads yet', actionLabel: 'Add')),
      );

      expect(find.text('Add'), findsNothing);
    });
  });

  group('AppErrorState', () {
    testWidgets('shows the failure message and a retry button', (
      tester,
    ) async {
      var retried = false;
      await tester.pumpWidget(
        wrap(
          AppErrorState(
            message: 'No internet connection.',
            onRetry: () => retried = true,
          ),
        ),
      );

      expect(find.text('No internet connection.'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });

    testWidgets('does not show a retry button when onRetry is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppErrorState(message: 'No internet connection.')),
      );

      expect(find.text('Retry'), findsNothing);
    });
  });
}
