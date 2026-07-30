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
  /// to actually exit — the common "Tap back again to exit" pattern —
  /// showing a brief hint snackbar on the first press.
  doubleTapToExit,
}

/// Wraps the app's root screen (or any screen where "back" should exit
/// the app rather than pop to nothing) with a confirmation step before
/// actually exiting.
///
/// Place this around whichever screen is the effective root of your
/// navigation stack — commonly the home screen inside your shell:
///
/// ```dart
/// AppExitGuard(
///   behavior: AppExitBehavior.doubleTapToExit,
///   child: const HomeScreen(),
/// )
/// ```
///
/// This only affects the Android back gesture/button when there's
/// nothing left for the enclosing [Navigator] to pop — screens reached
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

  /// How long the user has to press back again before the "first
  /// press" hint expires, used when [behavior] is
  /// [AppExitBehavior.doubleTapToExit].
  final Duration doubleTapWindow;

  @override
  State<AppExitGuard> createState() => _AppExitGuardState();
}

class _AppExitGuardState extends State<AppExitGuard> {
  DateTime? _firstBackPressAt;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(widget.doubleTapHint),
              duration: widget.doubleTapWindow,
            ),
          );
        return false;
    }
  }
}
