/// Base class for all exceptions thrown within the data layer.
///
/// These are internal to the `data` layer and should be caught and mapped
/// to a [Failure] before crossing into `domain`/`presentation`.
abstract class AppException implements Exception {
  /// Creates an [AppException] with a human-readable [message].
  const AppException(this.message, {this.statusCode});

  /// A human-readable description of what went wrong.
  final String message;

  /// The HTTP status code associated with this exception, if any.
  final int? statusCode;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a request fails due to no network connectivity.
class NetworkException extends AppException {
  /// Creates a [NetworkException].
  const NetworkException([super.message = 'No internet connection.']);
}

/// Thrown when the server responds with an error status code.
class ServerException extends AppException {
  /// Creates a [ServerException] with the given [message] and [statusCode].
  const ServerException(super.message, {super.statusCode});
}

/// Thrown when a request exceeds the configured timeout.
class TimeoutException extends AppException {
  /// Creates a [TimeoutException].
  const TimeoutException([super.message = 'The request timed out.']);
}

/// Thrown when reading/writing local cache or secure storage fails.
class CacheException extends AppException {
  /// Creates a [CacheException].
  const CacheException([super.message = 'Local storage operation failed.']);
}

/// Thrown when the current session/token is invalid or expired.
class UnauthorizedException extends AppException {
  /// Creates an [UnauthorizedException].
  const UnauthorizedException([String message = 'Session expired.'])
      : super(message, statusCode: 401);
}

/// Thrown for any exception that doesn't map to a known category.
class UnknownException extends AppException {
  /// Creates an [UnknownException].
  const UnknownException([super.message = 'Something went wrong.']);
}
