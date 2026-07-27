import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';
import '../buttons/app_button.dart';

/// A themed empty-state placeholder for lists/screens with no data yet
/// (e.g. "No leads assigned to you").
///
/// ```dart
/// if (leads.isEmpty) {
///   return AppEmptyState(
///     icon: Icons.inbox_outlined,
///     title: 'No leads yet',
///     message: 'New leads assigned to you will show up here.',
///   );
/// }
/// ```
class AppEmptyState extends StatelessWidget {
  /// Creates an [AppEmptyState].
  const AppEmptyState({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// The primary heading (e.g. "No leads yet").
  final String title;

  /// Optional supporting text.
  final String? message;

  /// The icon shown above the title.
  final IconData icon;

  /// If provided (with [onAction]), shows a button below the message.
  final String? actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(config.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: config.onSurface.withOpacity(0.4)),
            SizedBox(height: config.spacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: config.spacing.xs),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: config.onSurface.withOpacity(0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: config.spacing.md),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A themed error-state placeholder, typically shown when a `Failure`
/// prevents a screen from loading data, with a retry action.
///
/// ```dart
/// result.when(
///   onSuccess: (leads) => LeadsList(leads),
///   onFailure: (failure) => AppErrorState(
///     message: failure.message,
///     onRetry: () => ref.refresh(leadsProvider),
///   ),
/// );
/// ```
class AppErrorState extends StatelessWidget {
  /// Creates an [AppErrorState].
  const AppErrorState({
    required this.message,
    this.title = 'Something went wrong',
    this.onRetry,
    super.key,
  });

  /// The heading shown above [message].
  final String title;

  /// The failure's user-facing message.
  final String message;

  /// Called when the retry button is tapped. If `null`, no retry
  /// button is shown.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(config.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: config.error),
            SizedBox(height: config.spacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: config.spacing.xs),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: config.onSurface.withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: config.spacing.md),
              AppButton(
                label: 'Retry',
                onPressed: onRetry,
                variant: AppButtonVariant.outlined,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
