import 'package:flutter/foundation.dart';

/// A simple feature-flag container, supplied by each app at startup —
/// same pattern as [AppThemeConfig]: one object, read wherever a
/// decision needs to be made about whether a piece of optional
/// functionality is switched on.
///
/// This deliberately covers only the handful of genuinely optional
/// features this package ships alongside (force-update checking,
/// localization, biometric lock, idle timeout) — it isn't a general
/// remote-config system. Add fields here only for flags that gate
/// package-level functionality; app-specific feature flags belong in
/// the app itself.
///
/// ```dart
/// const featureFlags = AppFeatureFlags(
///   enableBiometricLock: true,
///   enableIdleTimeout: true,
/// );
/// ```
@immutable
class AppFeatureFlags {
  /// Creates an [AppFeatureFlags]. Every flag defaults to `false` —
  /// opt in explicitly per app.
  const AppFeatureFlags({
    this.enableForceUpdateCheck = false,
    this.enableLocalization = false,
    this.enableBiometricLock = false,
    this.enableIdleTimeout = false,
  });

  /// Whether the app should check for a required update on startup
  /// (see `UpdateCheckService`). Requires the app to supply its own
  /// implementation — this package only defines the contract.
  final bool enableForceUpdateCheck;

  /// Whether the app supports switching locale/language. This package
  /// only provides the flag and a place to persist the choice (via
  /// `AppPreferencesService`); the actual translation pipeline (ARB
  /// files, `AppLocalizations`) is the app's responsibility.
  final bool enableLocalization;

  /// Whether the app requires biometric/PIN authentication (see
  /// `BiometricLockService`) — typically checked on app resume.
  final bool enableBiometricLock;

  /// Whether the app should log the user out (or otherwise lock
  /// itself) after a period of inactivity (see
  /// `AppIdleTimeoutGuard`).
  final bool enableIdleTimeout;

  /// Returns a copy of this config with the given fields replaced.
  AppFeatureFlags copyWith({
    bool? enableForceUpdateCheck,
    bool? enableLocalization,
    bool? enableBiometricLock,
    bool? enableIdleTimeout,
  }) {
    return AppFeatureFlags(
      enableForceUpdateCheck:
          enableForceUpdateCheck ?? this.enableForceUpdateCheck,
      enableLocalization: enableLocalization ?? this.enableLocalization,
      enableBiometricLock: enableBiometricLock ?? this.enableBiometricLock,
      enableIdleTimeout: enableIdleTimeout ?? this.enableIdleTimeout,
    );
  }
}
