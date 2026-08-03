import 'package:flutter/widgets.dart';

import '../../utils/app_responsive.dart';

/// Wraps [builder], handing it the current mobile/tablet/desktop
/// classification directly — a convenience over calling
/// [AppResponsive]'s static methods three times in a row.
///
/// ```dart
/// AppResponsiveBuilder(
///   builder: (context, isMobile, isTablet, isDesktop) {
///     if (isMobile) return const _MobileLayout();
///     return const _WideLayout();
///   },
/// )
/// ```
class AppResponsiveBuilder extends StatelessWidget {
  /// Creates an [AppResponsiveBuilder].
  const AppResponsiveBuilder({required this.builder, super.key});

  /// Builds the widget tree given the current breakpoint.
  final Widget Function(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      AppResponsive.isMobile(context),
      AppResponsive.isTablet(context),
      AppResponsive.isDesktop(context),
    );
  }
}
