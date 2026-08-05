import 'dart:async';

import 'package:flutter/widgets.dart';

/// Wraps [child] and calls [onTimeout] after [timeout] has passed with
/// no pointer activity (taps, drags, scroll/hover) anywhere inside it
/// — the common "log out after 5 minutes of inactivity" pattern for
/// apps handling sensitive data.
///
/// Place this near the root of the authenticated part of the app —
/// wrapping the routed content inside your shell, not each individual
/// screen:
///
/// ```dart
/// AppIdleTimeoutGuard(
///   enabled: featureFlags.enableIdleTimeout,
///   timeout: const Duration(minutes: 5),
///   onTimeout: () => authController.logout(),
///   child: MaterialApp.router(routerConfig: router),
/// )
/// ```
///
/// This only detects activity within its own subtree — pointer events
/// are observed via [Listener] with [HitTestBehavior.translucent], so
/// taps still reach [child] normally; this widget never intercepts or
/// blocks input, it only watches for it.
class AppIdleTimeoutGuard extends StatefulWidget {
  /// Creates an [AppIdleTimeoutGuard].
  const AppIdleTimeoutGuard({
    required this.child,
    required this.onTimeout,
    this.timeout = const Duration(minutes: 5),
    this.enabled = true,
    super.key,
  });

  /// The content to watch for activity within.
  final Widget child;

  /// Called once when [timeout] elapses with no activity. Does not
  /// repeat on its own — if you want to re-arm it (e.g. after showing
  /// a "session expired" screen), that's up to the caller.
  final VoidCallback onTimeout;

  /// How long to wait after the last detected activity before calling
  /// [onTimeout].
  final Duration timeout;

  /// When `false`, the timer is disabled entirely (no-op wrapper) —
  /// wire this to a feature flag rather than conditionally omitting
  /// this widget, so toggling it doesn't require restructuring the
  /// widget tree.
  final bool enabled;

  @override
  State<AppIdleTimeoutGuard> createState() => _AppIdleTimeoutGuardState();
}

class _AppIdleTimeoutGuardState extends State<AppIdleTimeoutGuard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void didUpdateWidget(covariant AppIdleTimeoutGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled ||
        widget.timeout != oldWidget.timeout) {
      _resetTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    if (!widget.enabled) return;
    _timer = Timer(widget.timeout, widget.onTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      onPointerSignal: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
