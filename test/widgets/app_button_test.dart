import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppButton', () {
    testWidgets('shows the label and calls onPressed when tapped', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(AppButton(label: 'Sign in', onPressed: () => tapped = true)),
      );

      expect(find.text('Sign in'), findsOneWidget);
      await tester.tap(find.text('Sign in'));
      expect(tapped, isTrue);
    });

    testWidgets('shows a spinner and hides the label while loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AppButton(label: 'Sign in', isLoading: true, onPressed: () {}),
        ),
      );

      expect(find.text('Sign in'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not call onPressed while loading', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppButton(
            label: 'Sign in',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isFalse);
    });

    testWidgets('renders as disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        wrap(const AppButton(label: 'Sign in', onPressed: null)),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('gradient variant renders a container with a gradient', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AppButton(
            label: 'Upgrade',
            variant: AppButtonVariant.gradient,
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Upgrade'), findsOneWidget);
      final gradientContainers = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            (widget.decoration as BoxDecoration?)?.gradient != null,
      );
      expect(gradientContainers, findsOneWidget);
    });

    testWidgets('gradient variant calls onPressed when tapped', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppButton(
            label: 'Upgrade',
            variant: AppButtonVariant.gradient,
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Upgrade'));
      expect(tapped, isTrue);
    });

    testWidgets('applies a custom backgroundColor for the primary variant', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AppButton(
            label: 'Add to cart',
            backgroundColor: Colors.deepOrange,
            onPressed: () {},
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final resolvedColor = button.style!.backgroundColor!.resolve({});
      expect(resolvedColor, Colors.deepOrange);
    });
  });
}
