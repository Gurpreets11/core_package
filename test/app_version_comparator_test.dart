import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppVersionComparator.isBelow', () {
    test('returns true when current is a lower major/minor/patch', () {
      expect(AppVersionComparator.isBelow('1.0.0', '2.0.0'), isTrue);
      expect(AppVersionComparator.isBelow('1.0.0', '1.1.0'), isTrue);
      expect(AppVersionComparator.isBelow('1.0.0', '1.0.1'), isTrue);
    });

    test('returns false when current meets or exceeds the minimum', () {
      expect(AppVersionComparator.isBelow('2.0.0', '1.0.0'), isFalse);
      expect(AppVersionComparator.isBelow('1.0.0', '1.0.0'), isFalse);
    });

    test('compares numerically, not lexically', () {
      // A naive string comparison would say "1.9.0" > "1.10.0".
      expect(AppVersionComparator.isBelow('1.9.0', '1.10.0'), isTrue);
      expect(AppVersionComparator.isBelow('1.10.0', '1.9.0'), isFalse);
    });

    test('handles version strings of differing segment counts', () {
      expect(AppVersionComparator.isBelow('1.0', '1.0.1'), isTrue);
      expect(AppVersionComparator.isBelow('1.0.0', '1.0'), isFalse);
    });
  });
}
