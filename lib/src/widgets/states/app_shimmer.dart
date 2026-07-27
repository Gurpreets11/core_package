import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A themed shimmer/skeleton loading placeholder — a self-contained
/// gradient animation with no extra package dependency, so it stays
/// lightweight for a package meant to be widely reused.
///
/// Wrap a placeholder shape (usually a colored [Container]) in
/// [AppShimmer] to animate it:
///
/// ```dart
/// AppShimmer(
///   child: Container(
///     height: 16,
///     decoration: BoxDecoration(
///       color: Colors.white, // any solid color — the shimmer masks it
///       borderRadius: BorderRadius.circular(4),
///     ),
///   ),
/// )
/// ```
///
/// For a full list-row skeleton, see [AppShimmerListTile].
class AppShimmer extends StatefulWidget {
  /// Creates an [AppShimmer] wrapping [child].
  const AppShimmer({
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    super.key,
  });

  /// The placeholder shape to animate a shimmer sweep across.
  final Widget child;

  /// How long one shimmer sweep takes.
  final Duration duration;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final base = config.onSurface.withOpacity(0.08);
    final highlight = config.onSurface.withOpacity(0.16);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final slide = _controller.value;
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              begin: Alignment(-1 - slide * 2, 0),
              end: Alignment(1 - slide * 2, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A ready-made shimmering placeholder shaped like a typical list row
/// (leading circle avatar + two lines of text), for list screens
/// showing a loading state before real data arrives.
class AppShimmerListTile extends StatelessWidget {
  /// Creates an [AppShimmerListTile].
  const AppShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: config.spacing.md,
        vertical: config.spacing.sm,
      ),
      child: AppShimmer(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: config.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: config.spacing.xs),
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
