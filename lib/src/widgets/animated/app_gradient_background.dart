import 'package:flutter/material.dart';

/// Soft pastel gradient backdrop with two blurred decorative blobs.
///
/// Colors come from the active [ColorScheme], so it follows the app's
/// `AppThemeConfig` (light and dark) without extra setup.
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.showBlobs = true,
  });

  final Widget child;

  /// Overrides the default theme-derived gradient colors.
  final List<Color>? colors;
  final bool showBlobs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = colors ??
        (isDark
            ? [
                scheme.surface,
                Color.alphaBlend(
                    scheme.primary.withValues(alpha: 0.14), scheme.surface),
              ]
            : [
                Color.alphaBlend(
                    scheme.primary.withValues(alpha: 0.14), Colors.white),
                Color.alphaBlend(
                    scheme.tertiary.withValues(alpha: 0.10), Colors.white),
                Color.alphaBlend(
                    scheme.secondary.withValues(alpha: 0.14), Colors.white),
              ]);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        if (showBlobs) ...[
          _Blob(
              top: -80,
              right: -60,
              size: 240,
              color: scheme.primary.withValues(alpha: 0.20)),
          _Blob(
              bottom: -100,
              left: -80,
              size: 280,
              color: scheme.secondary.withValues(alpha: 0.20)),
        ],
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob(
      {this.top,
      this.bottom,
      this.left,
      this.right,
      required this.size,
      required this.color});

  final double? top, bottom, left, right;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                RadialGradient(colors: [color, color.withValues(alpha: 0)]),
          ),
        ),
      ),
    );
  }
}
