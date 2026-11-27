import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  AppBottomNavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  AppBottomNavItem(
    label: 'Leads',
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
  ),
  AppBottomNavItem(
    label: 'Profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  ),
];

/// Hosts the bar and keeps its own selected index, like a real screen.
Widget _host({
  required bool floating,
  int initialIndex = 0,
  ValueChanged<int>? onTap,
}) {
  var index = initialIndex;
  return MaterialApp(
    home: StatefulBuilder(
      builder: (context, setState) => Scaffold(
        bottomNavigationBar: AppBottomNavBar(
          items: _items,
          currentIndex: index,
          floating: floating,
          onTap: (i) {
            onTap?.call(i);
            setState(() => index = i);
          },
        ),
      ),
    ),
  );
}

void main() {
  group('AppBottomNavBar (floating, the default)', () {
    testWidgets('shows the label of the selected destination only',
        (tester) async {
      await tester.pumpWidget(_host(floating: true));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Leads'), findsNothing);
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('shows the selected icon variant for the selection',
        (tester) async {
      await tester.pumpWidget(_host(floating: true));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('calls onTap with the tapped index', (tester) async {
      int? tapped;
      await tester.pumpWidget(_host(floating: true, onTap: (i) => tapped = i));

      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });

    testWidgets('moves the label to the newly selected destination',
        (tester) async {
      await tester.pumpWidget(_host(floating: true));

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });
  });

  group('AppBottomNavBar (floating: false)', () {
    testWidgets('shows all destination labels', (tester) async {
      await tester.pumpWidget(_host(floating: false));

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Leads'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('calls onTap with the tapped index', (tester) async {
      int? tapped;
      await tester.pumpWidget(_host(floating: false, onTap: (i) => tapped = i));

      await tester.tap(find.text('Leads'));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });
  });
}
