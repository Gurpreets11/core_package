import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Severity level for a log entry.
enum LogLevel {
  /// Verbose diagnostic information.
  debug,

  /// Normal operational information.
  info,

  /// Something unexpected happened but execution continues.
  warning,

  /// An error occurred.
  error,
}

/// A single log entry, passed to any attached [LogSink].
class LogEntry {
  /// Creates a [LogEntry].
  const LogEntry({
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
  });

  /// The entry's severity.
  final LogLevel level;

  /// The log message.
  final String message;

  /// An optional tag/category for the entry.
  final String? tag;

  /// An optional error object (typically present for [LogLevel.error]).
  final Object? error;

  /// An optional stack trace (typically present for [LogLevel.error]).
  final StackTrace? stackTrace;
}

/// A callback that receives every [LogEntry], regardless of build mode.
///
/// Attach one via [AppLogger.attachSink] to forward logs to a crash
/// reporting or analytics service (Crashlytics, Sentry, etc.) — this is
/// the one place that wiring needs to happen, instead of touching every
/// [AppLogger] call site across every app.
typedef LogSink = void Function(LogEntry entry);

/// A thin logging wrapper.
///
/// All apps built on this package should log exclusively through
/// [AppLogger] rather than `print`, so logging behavior is centrally
/// controlled. The developer console output (via `dart:developer`) is
/// silent in release builds, to avoid leaking internal details and
/// keep production console output clean — but an attached [LogSink]
/// still receives every entry in every build mode, since that's the
/// whole point of forwarding logs to a crash-reporting service in
/// production.
abstract final class AppLogger {
  static LogSink? _sink;

  /// Attaches [sink] to receive every future log entry, in every build
  /// mode. Call this once, early in `main()`, after initializing
  /// whatever crash-reporting SDK the sink forwards to.
  static void attachSink(LogSink sink) => _sink = sink;

  /// Removes the currently attached sink, if any.
  static void detachSink() => _sink = null;

  /// Logs a debug-level message. Console output is a no-op outside of
  /// debug builds; an attached sink still receives it.
  static void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  /// Logs an info-level message. Console output is a no-op in release
  /// builds; an attached sink still receives it.
  static void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);

  /// Logs a warning-level message. Console output is a no-op in
  /// release builds; an attached sink still receives it.
  static void warning(String message, {String? tag}) =>
      _log(LogLevel.warning, message, tag: tag);

  /// Logs an error-level message with an optional [error] and
  /// [stackTrace]. Console output is a no-op in release builds; an
  /// attached sink still receives it — this is how production crashes
  /// reach a crash-reporting service.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(
        LogLevel.error,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      developer.log(
        message,
        name: tag ?? 'core_package',
        level: _priorityFor(level),
        error: error,
        stackTrace: stackTrace,
      );
    }

    _sink?.call(
      LogEntry(
        level: level,
        message: message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  static int _priorityFor(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };
}
