import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'failure.dart';

/// Converts thrown exceptions (Dio errors, [AppException]s, or anything
/// unexpected) into a [Failure] value that the `domain`/`presentation`
/// layers can handle uniformly.
///
/// Typical usage inside a repository implementation:
/// ```dart
/// try {
///   final result = await remoteDataSource.fetchLeads();
///   return Right(result);
/// } catch (error) {
///   return Left(ExceptionMapper.toFailure(error));
/// }
/// ```
abstract final class ExceptionMapper {
  /// Maps [error] to the most appropriate [Failure].
  static Failure toFailure(Object error) {
    if (error is AppException) {
      return _fromAppException(error);
    }
    if (error is DioException) {
      return _fromDioException(error);
    }
    return UnknownFailure(error.toString());
  }

  static Failure _fromAppException(AppException exception) {
    return switch (exception) {
      NetworkException() => NetworkFailure(exception.message),
      TimeoutException() => TimeoutFailure(exception.message),
      UnauthorizedException() => UnauthorizedFailure(exception.message),
      CacheException() => CacheFailure(exception.message),
      ServerException() => ServerFailure(exception.message),
      _ => UnknownFailure(exception.message),
    };
  }

  static Failure _fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return const UnauthorizedFailure();
        }
        return ServerFailure(
          error.response?.statusMessage ?? 'Server error ($statusCode).',
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownFailure(error.message ?? 'Something went wrong.');
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError(error.message ?? 'Unimplemented error.');
    }
  }
}
