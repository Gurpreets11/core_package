/// A validator function: takes the field value, returns an error message
/// or `null` if valid. Matches the signature expected by
/// `FormField.validator` / `TextFormField.validator`.
typedef Validator = String? Function(String? value);

/// A collection of common, composable field validators.
///
/// Validators can be chained with [Validators.compose]:
/// ```dart
/// TextFormField(
///   validator: Validators.compose([
///     Validators.required(),
///     Validators.email(),
///   ]),
/// )
/// ```
abstract final class Validators {
  /// Validates that the value is not null/empty.
  static Validator required({String message = 'This field is required.'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  /// Validates that the value is a well-formed email address.
  static Validator email({String message = 'Enter a valid email address.'}) {
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!pattern.hasMatch(value)) return message;
      return null;
    };
  }

  /// Validates that the value is a well-formed phone number
  /// (digits, optional leading `+`, 7–15 digits).
  static Validator phone({String message = 'Enter a valid phone number.'}) {
    final pattern = RegExp(r'^\+?[0-9]{7,15}$');
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!pattern.hasMatch(value)) return message;
      return null;
    };
  }

  /// Validates a minimum string length.
  static Validator minLength(int length, {String? message}) {
    return (value) {
      if (value == null) return null;
      if (value.length < length) {
        return message ?? 'Must be at least $length characters.';
      }
      return null;
    };
  }

  /// Validates a maximum string length.
  static Validator maxLength(int length, {String? message}) {
    return (value) {
      if (value == null) return null;
      if (value.length > length) {
        return message ?? 'Must be no more than $length characters.';
      }
      return null;
    };
  }

  /// Validates password strength: at least [minLength] characters, one
  /// letter, and one digit.
  static Validator password({
    int minLength = 8,
    String? message,
  }) {
    final pattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < minLength || !pattern.hasMatch(value)) {
        return message ??
            'Password must be at least $minLength characters and include a letter and a number.';
      }
      return null;
    };
  }

  /// Validates that [value] matches [other] (e.g. confirm-password fields).
  /// [other] is evaluated lazily so it can read current form state.
  static Validator matches(
    String? Function() other, {
    String message = 'Values do not match.',
  }) {
    return (value) {
      if (value != other()) return message;
      return null;
    };
  }

  /// Combines multiple validators; returns the first non-null error.
  static Validator compose(List<Validator> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
