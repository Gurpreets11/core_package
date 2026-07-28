import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const items = [
    AppBottomNavItem(label: 'Home', icon: Icons.home_outlined),
    AppBottomNavItem(label: 'Leads', icon: Icons.people_outline),
    AppBottomNavItem(label: 'Profile', icon: Icons.person_outline),
  ];

  group('AppBottomNavBar', () {
    testWidgets('shows all destination labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              items: items,
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Leads'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('calls onTap with the tapped index', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              items: items,
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Leads'));
      expect(tappedIndex, 1);
    });
  });
}
