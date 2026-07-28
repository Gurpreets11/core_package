import 'dart:async';

/// Delays running [run]'s callback until [delay] has passed without
/// another call — cancelling any pending call each time a new one comes
/// in. Used for search-as-you-type, autosave, and similar patterns
/// where you don't want to act on every single keystroke.
///
/// ```dart
/// final debouncer = Debouncer();
///
/// TextField(
///   onChanged: (value) => debouncer.run(() => search(value)),
/// )
/// ```
///
/// Call [dispose] when the owning widget is disposed, so a pending
/// timer doesn't fire after the widget is gone.
class Debouncer {
  /// Creates a [Debouncer] with the given [delay] (defaults to 400ms).
  Debouncer({this.delay = const Duration(milliseconds: 400)});

  /// How long to wait after the last call before running the action.
  final Duration delay;

  Timer? _timer;

  /// Schedules [action] to run after [delay], cancelling any
  /// previously scheduled call.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending call without running it.
  void cancel() => _timer?.cancel();

  /// Cancels any pending call. Call this when the owning widget is
  /// disposed.
  void dispose() => _timer?.cancel();
}
