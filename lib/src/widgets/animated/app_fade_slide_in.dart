import 'package:flutter/material.dart';

/// Fades and slides [child] into place once, after an optional [delay].
/// Respects the system "reduce motion" setting.
class AppFadeSlideIn extends StatefulWidget {
  const AppFadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 450),
    this.offset = const Offset(0, 24),
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Starting offset in logical pixels; animates to [Offset.zero].
  final Offset offset;
  final Curve curve;

  @override
  State<AppFadeSlideIn> createState() => _AppFadeSlideInState();
}

class _AppFadeSlideInState extends State<AppFadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    final total = widget.delay + widget.duration;
    _controller = AnimationController(vsync: this, duration: total);
    final start = total.inMilliseconds == 0
        ? 0.0
        : widget.delay.inMilliseconds / total.inMilliseconds;
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1.0, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return AnimatedBuilder(
      animation: _progress,
      child: widget.child,
      builder: (context, child) {
        final t = _progress.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset:
                Offset(widget.offset.dx * (1 - t), widget.offset.dy * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}

/// A [Column] whose children animate in one after another.
class AppStaggeredColumn extends StatelessWidget {
  const AppStaggeredColumn({
    super.key,
    required this.children,
    this.stagger = const Duration(milliseconds: 70),
    this.initialDelay = Duration.zero,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final Duration stagger;
  final Duration initialDelay;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (var i = 0; i < children.length; i++)
          AppFadeSlideIn(delay: initialDelay + stagger * i, child: children[i]),
      ],
    );
  }
}
