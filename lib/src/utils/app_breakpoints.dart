/// Standard width breakpoints (in logical pixels) used by
/// [AppResponsive] to distinguish mobile/tablet/desktop layouts.
///
/// These follow common Material guidance: below [mobile] is a phone in
/// portrait, [mobile]–[tablet] is a phone in landscape or a small
/// tablet, and above [tablet] is a large tablet or desktop.
abstract final class AppBreakpoints {
  /// Below this width is considered "mobile."
  static const double mobile = 600;

  /// Below this width (and at/above [mobile]) is considered "tablet."
  /// At/above this width is considered "desktop."
  static const double tablet = 1024;
}
