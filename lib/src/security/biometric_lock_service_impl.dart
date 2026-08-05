import 'package:local_auth/local_auth.dart';

import '../logger/app_logger.dart';
import 'biometric_lock_service.dart';

/// The real [BiometricLockService] implementation, backed by
/// `local_auth`.
///
/// Both methods catch every exception and fall back to `false` rather
/// than propagating a platform exception — a device with no
/// biometrics configured, an unsupported platform, or a user
/// cancellation are all just "not authenticated," not error
/// conditions the caller needs to handle separately.
class BiometricLockServiceImpl implements BiometricLockService {
  /// Creates a [BiometricLockServiceImpl].
  ///
  /// Pass a custom [auth] instance in tests; defaults to a real
  /// [LocalAuthentication].
  BiometricLockServiceImpl({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> get isAvailable async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics || isDeviceSupported;
    } catch (error) {
      AppLogger.warning(
        'BiometricLockService.isAvailable failed: $error',
        tag: 'security',
      );
      return false;
    }
  }

  @override
  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      return await _auth.authenticate(localizedReason: reason);
    } catch (error) {
      AppLogger.warning(
        'BiometricLockService.authenticate failed: $error',
        tag: 'security',
      );
      return false;
    }
  }
}
