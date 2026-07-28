import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFormatters.date', () {
    test('formats using the given pattern', () {
      final date = DateTime(2026, 7, 28);
      expect(AppFormatters.date(date), '2026-07-28');
      expect(AppFormatters.date(date, pattern: 'dd/MM/yyyy'), '28/07/2026');
    });
  });

  group('AppFormatters.relativeDate', () {
    test('returns "just now" for the current moment', () {
      final now = DateTime(2026, 7, 28, 12);
      expect(AppFormatters.relativeDate(now, now: now), 'just now');
    });

    test('returns hours-ago for a time earlier today', () {
      final now = DateTime(2026, 7, 28, 12);
      final earlier = DateTime(2026, 7, 28, 10);
      expect(AppFormatters.relativeDate(earlier, now: now), '2h ago');
    });

    test('returns days-ago for a time within the last week', () {
      final now = DateTime(2026, 7, 28);
      final earlier = DateTime(2026, 7, 26);
      expect(AppFormatters.relativeDate(earlier, now: now), '2d ago');
    });

    test('falls back to friendlyDate beyond a week', () {
      final now = DateTime(2026, 7, 28);
      final longAgo = DateTime(2026, 7, 1);
      expect(
        AppFormatters.relativeDate(longAgo, now: now),
        AppFormatters.friendlyDate(longAgo),
      );
    });
  });

  group('AppFormatters.currency', () {
    test('formats with the default symbol and 2 decimal digits', () {
      expect(AppFormatters.currency(1234.5), '\$1,234.50');
    });

    test('applies a custom symbol', () {
      expect(AppFormatters.currency(10, symbol: '€'), '€10.00');
    });
  });

  group('AppFormatters.number', () {
    test('adds thousands separators', () {
      expect(AppFormatters.number(12345), '12,345');
    });

    test('applies the requested decimal digits', () {
      expect(AppFormatters.number(12345.678, decimalDigits: 2), '12,345.68');
    });
  });

  group('AppFormatters.compactNumber', () {
    test('abbreviates large numbers', () {
      expect(AppFormatters.compactNumber(1200), '1.2K');
      expect(AppFormatters.compactNumber(3400000), '3.4M');
    });
  });
}
