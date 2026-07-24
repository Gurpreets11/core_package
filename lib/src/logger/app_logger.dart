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

/// A thin logging wrapper that is silent in release builds.
///
/// All apps built on this package should log exclusively through
/// [AppLogger] rather than `print`, so logging behavior is centrally
/// controlled and never leaks into production console output.
abstract final class AppLogger {
  /// Logs a debug-level message. No-op outside of debug builds.
  static void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  /// Logs an info-level message. No-op in release builds.
  static void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);

  /// Logs a warning-level message. No-op in release builds.
  static void warning(String message, {String? tag}) =>
      _log(LogLevel.warning, message, tag: tag);

  /// Logs an error-level message with an optional [error] and
  /// [stackTrace]. No-op in release builds.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Never log in release builds — avoids leaking internal details and
    // keeps release console output clean.
    if (kReleaseMode) return;

    developer.log(
      message,
      name: tag ?? 'core_package',
      level: _priorityFor(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static int _priorityFor(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };
}
