import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapAtWidth(double width, WidgetBuilder builder) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: MaterialApp(home: Builder(builder: builder)),
    );
  }

  group('AppResponsive.isMobile / isTablet / isDesktop', () {
    testWidgets('classifies a narrow width as mobile', (tester) async {
      late bool mobile, tablet, desktop;
      await tester.pumpWidget(
        wrapAtWidth(400, (context) {
          mobile = AppResponsive.isMobile(context);
          tablet = AppResponsive.isTablet(context);
          desktop = AppResponsive.isDesktop(context);
          return const SizedBox.shrink();
        }),
      );

      expect(mobile, isTrue);
      expect(tablet, isFalse);
      expect(desktop, isFalse);
    });

    testWidgets('classifies a mid-range width as tablet', (tester) async {
      late bool mobile, tablet, desktop;
      await tester.pumpWidget(
        wrapAtWidth(800, (context) {
          mobile = AppResponsive.isMobile(context);
          tablet = AppResponsive.isTablet(context);
          desktop = AppResponsive.isDesktop(context);
          return const SizedBox.shrink();
        }),
      );

      expect(mobile, isFalse);
      expect(tablet, isTrue);
      expect(desktop, isFalse);
    });

    testWidgets('classifies a wide width as desktop', (tester) async {
      late bool mobile, tablet, desktop;
      await tester.pumpWidget(
        wrapAtWidth(1200, (context) {
          mobile = AppResponsive.isMobile(context);
          tablet = AppResponsive.isTablet(context);
          desktop = AppResponsive.isDesktop(context);
          return const SizedBox.shrink();
        }),
      );

      expect(mobile, isFalse);
      expect(tablet, isFalse);
      expect(desktop, isTrue);
    });
  });

  group('AppResponsive.value', () {
    testWidgets('returns mobile value below the mobile breakpoint', (
      tester,
    ) async {
      late int result;
      await tester.pumpWidget(
        wrapAtWidth(400, (context) {
          result = AppResponsive.value(
            context,
            mobile: 1,
            tablet: 2,
            desktop: 3,
          );
          return const SizedBox.shrink();
        }),
      );
      expect(result, 1);
    });

    testWidgets('returns tablet value at tablet width', (tester) async {
      late int result;
      await tester.pumpWidget(
        wrapAtWidth(800, (context) {
          result = AppResponsive.value(
            context,
            mobile: 1,
            tablet: 2,
            desktop: 3,
          );
          return const SizedBox.shrink();
        }),
      );
      expect(result, 2);
    });

    testWidgets('falls back to mobile when tablet/desktop are omitted', (
      tester,
    ) async {
      late int result;
      await tester.pumpWidget(
        wrapAtWidth(1200, (context) {
          result = AppResponsive.value(context, mobile: 1);
          return const SizedBox.shrink();
        }),
      );
      expect(result, 1);
    });
  });
}
