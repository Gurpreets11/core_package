import 'package:flutter/material.dart';

import '../../theme/app_theme_config.dart';
import '../../theme/app_theme_scope.dart';

/// A themed card — a [Container] with the theme's surface color, border
/// radius, and consistent internal padding, so list items and detail
/// sections look consistent without repeating decoration per screen.
///
/// ```dart
/// AppCard(
///   onTap: () => context.push('/leads/${lead.id}'),
///   child: Text(lead.name),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// Creates an [AppCard].
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    super.key,
  });

  /// The card's content.
  final Widget child;

  /// Called when the card is tapped. If `null`, the card isn't
  /// interactive (no ripple/highlight).
  final VoidCallback? onTap;

  /// Overrides the default padding (`EdgeInsets.all(spacing.md)`).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    final content = Padding(
      padding: padding ?? EdgeInsets.all(config.spacing.md),
      child: child,
    );

    return Material(
      color: config.surface,
      borderRadius: BorderRadius.circular(config.borderRadius),
      elevation: 1,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(config.borderRadius),
              child: content,
            )
          : content,
    );
  }
}

/// The visual emphasis of an [AppChip]/[AppBadge].
enum AppStatusTone {
  /// Neutral/default emphasis (uses theme surface/secondary tones).
  neutral,

  /// Positive/success emphasis (green).
  success,

  /// Cautionary emphasis (amber).
  warning,

  /// Negative/error emphasis (uses the theme's error color).
  danger,
}

/// A themed chip for tags/filters/status labels.
///
/// ```dart
/// AppChip(label: 'Qualified', tone: AppStatusTone.success)
/// ```
class AppChip extends StatelessWidget {
  /// Creates an [AppChip].
  const AppChip({
    required this.label,
    this.tone = AppStatusTone.neutral,
    this.onTap,
    super.key,
  });

  /// The chip's text.
  final String label;

  /// The visual emphasis to apply.
  final AppStatusTone tone;

  /// Called when the chip is tapped, if interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final (background, foreground) = _colorsFor(tone, config);

    final chip = Container(
      padding: EdgeInsets.symmetric(
        horizontal: config.spacing.sm,
        vertical: config.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(config.borderRadius * 2),
      ),
      child: Text(
        label,
        style: TextStyle(color: foreground, fontSize: 12),
      ),
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: chip) : chip;
  }

  static (Color, Color) _colorsFor(AppStatusTone tone, AppThemeConfig config) {
    return switch (tone) {
      AppStatusTone.neutral => (
          config.onSurface.withValues(alpha: 0.08),
          config.onSurface,
        ),
      AppStatusTone.success => (
          const Color(0xFFE6F4EA),
          const Color(0xFF1E7E34),
        ),
      AppStatusTone.warning => (
          const Color(0xFFFFF4E5),
          const Color(0xFF9A6700),
        ),
      AppStatusTone.danger => (
          config.error.withValues(alpha: 0.1),
          config.error
        ),
    };
  }
}

/// A small badge — typically a count or a single status dot — for
/// overlaying on icons or list items.
///
/// ```dart
/// AppBadge(count: unreadCount)
/// ```
class AppBadge extends StatelessWidget {
  /// Creates an [AppBadge] showing [count]. Renders nothing if
  /// [count] is 0 and [showZero] is `false` (the default).
  const AppBadge({
    required this.count,
    this.showZero = false,
    this.tone = AppStatusTone.danger,
    super.key,
  });

  /// The number to display.
  final int count;

  /// Whether to render when [count] is 0.
  final bool showZero;

  /// The visual emphasis to apply.
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) return const SizedBox.shrink();

    final config = AppThemeScope.of(context);
    final color = tone == AppStatusTone.danger ? config.error : config.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
