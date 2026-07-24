import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.required', () {
    final validate = Validators.required();

    test('returns error for null', () {
      expect(validate(null), isNotNull);
    });

    test('returns error for empty/whitespace', () {
      expect(validate('   '), isNotNull);
    });

    test('returns null for non-empty value', () {
      expect(validate('hello'), isNull);
    });
  });

  group('Validators.email', () {
    final validate = Validators.email();

    test('accepts a well-formed email', () {
      expect(validate('user@example.com'), isNull);
    });

    test('rejects a malformed email', () {
      expect(validate('not-an-email'), isNotNull);
    });

    test('treats empty as valid (combine with required() to force it)', () {
      expect(validate(''), isNull);
    });
  });

  group('Validators.password', () {
    final validate = Validators.password();

    test('rejects passwords without a digit', () {
      expect(validate('onlyletters'), isNotNull);
    });

    test('rejects passwords shorter than minLength', () {
      expect(validate('a1'), isNotNull);
    });

    test('accepts a valid password', () {
      expect(validate('password1'), isNull);
    });
  });

  group('Validators.compose', () {
    test('returns the first failing validator\'s message', () {
      final validate = Validators.compose([
        Validators.required(message: 'Required!'),
        Validators.email(message: 'Bad email!'),
      ]);

      expect(validate(null), 'Required!');
      expect(validate('bad'), 'Bad email!');
      expect(validate('user@example.com'), isNull);
    });
  });
}
