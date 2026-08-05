import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFeatureFlags', () {
    test('every flag defaults to false', () {
      const flags = AppFeatureFlags();
      expect(flags.enableForceUpdateCheck, isFalse);
      expect(flags.enableLocalization, isFalse);
      expect(flags.enableBiometricLock, isFalse);
      expect(flags.enableIdleTimeout, isFalse);
    });

    test('copyWith overrides only the specified fields', () {
      const flags = AppFeatureFlags(enableBiometricLock: true);
      final updated = flags.copyWith(enableIdleTimeout: true);

      expect(updated.enableBiometricLock, isTrue);
      expect(updated.enableIdleTimeout, isTrue);
      expect(updated.enableForceUpdateCheck, isFalse);
      expect(updated.enableLocalization, isFalse);
    });
  });
}
