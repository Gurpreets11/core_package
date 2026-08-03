import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapAtWidth(double width, Widget child) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: MaterialApp(home: child),
    );
  }

  group('AppResponsiveBuilder', () {
    testWidgets('passes isMobile=true at a narrow width', (tester) async {
      await tester.pumpWidget(
        wrapAtWidth(
          400,
          AppResponsiveBuilder(
            builder: (context, isMobile, isTablet, isDesktop) {
              return Text(isMobile ? 'mobile' : 'not-mobile');
            },
          ),
        ),
      );

      expect(find.text('mobile'), findsOneWidget);
    });

    testWidgets('passes isDesktop=true at a wide width', (tester) async {
      await tester.pumpWidget(
        wrapAtWidth(
          1200,
          AppResponsiveBuilder(
            builder: (context, isMobile, isTablet, isDesktop) {
              return Text(isDesktop ? 'desktop' : 'not-desktop');
            },
          ),
        ),
      );

      expect(find.text('desktop'), findsOneWidget);
    });
  });
}
