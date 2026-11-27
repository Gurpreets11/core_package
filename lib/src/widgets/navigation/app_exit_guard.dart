import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dialogs/app_dialogs.dart';

/// How [AppExitGuard] should respond to a back gesture/button press at
/// the root of the app (i.e. when there's nothing left to pop).
enum AppExitBehavior {
  /// Show a confirm/cancel dialog (via [AppDialogs.showConfirm]) before
  /// exiting.
  confirmDialog,

  /// Require a second back press within [AppExitGuard.doubleTapWindow]
  /// to actually exit - the common "Tap back again to exit" pattern -
  /// showing a brief hint snackbar on the first press.
  doubleTapToExit,
}

/// Wraps the app's root screen (or any screen where "back" should exit
/// the app rather than pop to nothing) with a confirmation step before
/// actually exiting.
///
/// Place this around the shell that hosts your tabs:
///
/// ```dart
/// AppExitGuard(
///   behavior: AppExitBehavior.doubleTapToExit,
///   isAtRoot: currentTab == 0,
///   onBackFromNonRoot: () => goToFirstTab(),
///   child: const TabsScaffold(),
/// )
/// ```
///
/// When [isAtRoot] is `false` (for example the user is on a secondary
/// tab), back calls [onBackFromNonRoot] instead of starting the exit
/// flow. If [onBackFromNonRoot] is `null`, back pops normally.
///
/// This only affects the Android back gesture/button when there's
/// nothing left for the enclosing [Navigator] to pop - screens reached
/// via push still pop normally and are unaffected by this widget.
class AppExitGuard extends StatefulWidget {
  /// Creates an [AppExitGuard].
  const AppExitGuard({
    required this.child,
    this.behavior = AppExitBehavior.confirmDialog,
    this.confirmTitle = 'Exit app?',
    this.confirmMessage = 'Are you sure you want to exit?',
    this.doubleTapHint = 'Tap back again to exit',
    this.doubleTapWindow = const Duration(seconds: 2),
    this.hintDuration = const Duration(seconds: 2),
    this.hintMargin,
    this.isAtRoot = true,
    this.onBackFromNonRoot,
    super.key,
  });

  /// The screen to wrap.
  final Widget child;

  /// Which exit UX to use.
  final AppExitBehavior behavior;

  /// Dialog title, used when [behavior] is
  /// [AppExitBehavior.confirmDialog].
  final String confirmTitle;

  /// Dialog message, used when [behavior] is
  /// [AppExitBehavior.confirmDialog].
  final String confirmMessage;

  /// The hint text shown on the first back press, used when [behavior]
  /// is [AppExitBehavior.doubleTapToExit].
  final String doubleTapHint;

  /// How long after the first press a second press still exits, used
  /// when [behavior] is [AppExitBehavior.doubleTapToExit].
  final Duration doubleTapWindow;

  /// How long the hint snackbar stays visible. Independent of
  /// [doubleTapWindow], so a long window doesn't leave the hint on
  /// screen for as long.
  final Duration hintDuration;

  /// Optional margin for the hint snackbar. When set, the snackbar
  /// floats with this margin - use it to lift the hint above a
  /// floating bottom navigation bar.
  final EdgeInsetsGeometry? hintMargin;

  /// Whether the guarded screen is the app's root screen. When `false`,
  /// back triggers [onBackFromNonRoot] instead of the exit flow.
  final bool isAtRoot;

  /// Called when back is pressed while [isAtRoot] is `false`, typically
  /// to navigate to the root screen.
  final VoidCallback? onBackFromNonRoot;

  @override
  State<AppExitGuard> createState() => _AppExitGuardState();
}

class _AppExitGuardState extends State<AppExitGuard> {
  DateTime? _firstBackPressAt;

  @override
  Widget build(BuildContext context) {
    final letRouteHandleBack =
        !widget.isAtRoot && widget.onBackFromNonRoot == null;

    return PopScope(
      canPop: letRouteHandleBack,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!widget.isAtRoot) {
          widget.onBackFromNonRoot?.call();
          return;
        }
        final shouldExit = await _handleBackPress(context);
        if (shouldExit) {
          await SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }

  Future<bool> _handleBackPress(BuildContext context) async {
    switch (widget.behavior) {
      case AppExitBehavior.confirmDialog:
        return AppDialogs.showConfirm(
          context,
          title: widget.confirmTitle,
          message: widget.confirmMessage,
          confirmLabel: 'Exit',
        );

      case AppExitBehavior.doubleTapToExit:
        final now = DateTime.now();
        final withinWindow = _firstBackPressAt != null &&
            now.difference(_firstBackPressAt!) <= widget.doubleTapWindow;

        if (withinWindow) return true;

        _firstBackPressAt = now;
        final margin = widget.hintMargin;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(widget.doubleTapHint),
              duration: widget.hintDuration,
              behavior: margin != null ? SnackBarBehavior.floating : null,
              margin: margin,
            ),
          );
        return false;
    }
  }
}
