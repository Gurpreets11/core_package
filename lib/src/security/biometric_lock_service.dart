/// An abstraction over biometric/PIN device authentication, so app
/// code depends on this small interface rather than directly on
/// `local_auth` — same reasoning as [PermissionService].
abstract interface class BiometricLockService {
  /// Whether this device supports and has biometric/PIN
  /// authentication set up (e.g. fingerprint, Face ID, device
  /// passcode). Returns `false` on failure rather than throwing —
  /// callers should treat "unavailable" and "not set up" the same way
  /// (skip the lock, or prompt the user to set one up, per the app's
  /// own policy).
  Future<bool> get isAvailable;

  /// Prompts the user to authenticate (biometric or device
  /// credential), showing [reason] as the rationale text where the
  /// platform supports it. Returns `true` only on successful
  /// authentication — cancellation, failure, or an unavailable
  /// authenticator all return `false` rather than throwing.
  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
  });
}
