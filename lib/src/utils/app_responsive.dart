import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';

/// Screen-width-based responsive helpers, built on [AppBreakpoints].
///
/// ```dart
/// final columns = AppResponsive.value(
///   context,
///   mobile: 1,
///   tablet: 2,
///   desktop: 3,
/// );
///
/// final padding = AppResponsive.isDesktop(context)
///     ? config.spacing.xl
///     : config.spacing.md;
/// ```
abstract final class AppResponsive {
  /// Whether the current screen width is below [AppBreakpoints.mobile].
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;
  }

  /// Whether the current screen width is between [AppBreakpoints.mobile]
  /// and [AppBreakpoints.tablet].
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppBreakpoints.mobile && width < AppBreakpoints.tablet;
  }

  /// Whether the current screen width is at/above
  /// [AppBreakpoints.tablet].
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
  }

  /// Picks a value based on the current breakpoint. [tablet] falls
  /// back to [mobile] if omitted; [desktop] falls back to [tablet]
  /// (or [mobile]) if omitted — so you only need to specify the
  /// breakpoints where the value actually changes.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.tablet) return desktop ?? tablet ?? mobile;
    if (width >= AppBreakpoints.mobile) return tablet ?? mobile;
    return mobile;
  }
}
