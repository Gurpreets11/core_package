import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStringX.isBlank / isNotBlank', () {
    test('isBlank is true for empty and whitespace-only strings', () {
      expect(''.isBlank, isTrue);
      expect('   '.isBlank, isTrue);
      expect('a'.isBlank, isFalse);
    });

    test('isNotBlank is the inverse of isBlank', () {
      expect('hello'.isNotBlank, isTrue);
      expect('   '.isNotBlank, isFalse);
    });
  });

  group('AppStringX.capitalize', () {
    test('capitalizes the first letter', () {
      expect('leads'.capitalize(), 'Leads');
    });

    test('leaves an empty string unchanged', () {
      expect(''.capitalize(), '');
    });

    test('leaves an already-capitalized string unchanged', () {
      expect('Leads'.capitalize(), 'Leads');
    });
  });

  group('AppStringX.initials', () {
    test('returns both initials for a two-word name', () {
      expect('Jane Doe'.initials, 'JD');
    });

    test('returns a single initial for a one-word name', () {
      expect('Jane'.initials, 'J');
    });

    test('collapses extra whitespace between words', () {
      expect('  Jane   Doe  '.initials, 'JD');
    });

    test('returns an empty string for an empty name', () {
      expect(''.initials, '');
    });
  });
}
