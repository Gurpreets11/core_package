import 'package:meta/meta.dart';

/// Base class for all failures surfaced to the `domain`/`presentation`
/// layers. Unlike [Exception]s, [Failure]s are values — returned from use
/// cases, not thrown.
@immutable
abstract class Failure {
  /// Creates a [Failure] with a user-facing [message].
  const Failure(this.message);

  /// A message suitable for showing directly to the user.
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message);

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType($message)';
}

/// No internet connection was available.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// The server returned an error response.
class ServerFailure extends Failure {
  /// Creates a [ServerFailure].
  const ServerFailure([super.message = 'Something went wrong on the server.']);
}

/// The request took too long to complete.
class TimeoutFailure extends Failure {
  /// Creates a [TimeoutFailure].
  const TimeoutFailure([super.message = 'The request timed out.']);
}

/// Reading/writing local data failed.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure].
  const CacheFailure([super.message = 'Local storage operation failed.']);
}

/// The user's session is invalid or has expired.
class UnauthorizedFailure extends Failure {
  /// Creates an [UnauthorizedFailure].
  const UnauthorizedFailure([super.message = 'Session expired.']);
}

/// Input failed validation before being sent anywhere.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure].
  const ValidationFailure(super.message);
}

/// Catch-all for anything that doesn't map to a known category.
class UnknownFailure extends Failure {
  /// Creates an [UnknownFailure].
  const UnknownFailure([super.message = 'Something went wrong.']);
}
