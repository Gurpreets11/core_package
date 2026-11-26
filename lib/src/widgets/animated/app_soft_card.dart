import 'package:flutter/material.dart';

import 'app_pressable_scale.dart';

/// Rounded card with a soft, primary-tinted shadow and an optional gradient.
class AppSoftCard extends StatelessWidget {
  const AppSoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient == null ? scheme.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
    return AppPressableScale(onTap: onTap, child: card);
  }
}
