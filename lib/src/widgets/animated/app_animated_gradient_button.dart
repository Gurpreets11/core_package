import 'package:flutter/material.dart';

import 'app_pressable_scale.dart';

/// Full-width gradient button with a press animation and a loading state.
/// Pass a null [onPressed] to disable it.
class AppAnimatedGradientButton extends StatelessWidget {
  const AppAnimatedGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient,
    this.height = 54,
    this.borderRadius = 16,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Gradient? gradient;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onPressed != null && !isLoading;
    final fill = gradient ??
        LinearGradient(
          colors: [
            Color.lerp(scheme.primary, scheme.secondary, 0.35)!,
            scheme.primary
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: AppPressableScale(
        onTap: enabled ? onPressed : null,
        child: AnimatedOpacity(
          opacity: onPressed == null && !isLoading ? 0.5 : 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: fill,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.30),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: scheme.onPrimary),
                    )
                  : Row(
                      key: const ValueKey('label'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: scheme.onPrimary, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
