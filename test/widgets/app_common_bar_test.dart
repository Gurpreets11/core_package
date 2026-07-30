import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCommonBar', () {
    testWidgets('shows the title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppCommonBar(title: 'Leads')),
        ),
      );

      expect(find.text('Leads'), findsOneWidget);
    });

    testWidgets('does not show an overflow menu when items is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppCommonBar(title: 'Leads')),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsNothing);
    });

    testWidgets('shows an overflow menu with the given items', (
      tester,
    ) async {
      var settingsTapped = false;
      var logoutTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppCommonBar(
              title: 'Leads',
              overflowMenuItems: [
                AppOverflowMenuItem(
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  onTap: () => settingsTapped = true,
                ),
                AppOverflowMenuItem(
                  label: 'Log out',
                  icon: Icons.logout,
                  isDestructive: true,
                  onTap: () => logoutTapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(settingsTapped, isTrue);
      expect(logoutTapped, isFalse);
    });
  });
}
