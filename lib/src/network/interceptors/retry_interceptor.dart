import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../logger/app_logger.dart';

/// Retries a request a limited number of times, with exponential
/// backoff, when it fails for a transient reason (timeout or connection
/// error). Does **not** retry on `4xx`/`5xx` responses by default, since
/// those are usually not fixed by simply trying again — override
/// [retryIf] if a specific backend needs different behavior (e.g.
/// retrying on `503`).
///
/// ```dart
/// dio.interceptors.add(
///   RetryInterceptor(dio: dio, maxAttempts: 3),
/// );
/// ```
class RetryInterceptor extends Interceptor {
  /// Creates a [RetryInterceptor].
  ///
  /// [dio] is the same instance this interceptor is attached to — needed
  /// to re-issue the request. [maxAttempts] is the number of *retries*
  /// (not counting the original attempt). [baseDelay] is the delay
  /// before the first retry; each subsequent retry doubles it.
  RetryInterceptor({
    required this.dio,
    this.maxAttempts = 2,
    this.baseDelay = const Duration(milliseconds: 500),
    bool Function(DioException error)? retryIf,
  }) : _retryIf = retryIf ?? _defaultRetryIf;

  /// The [Dio] instance used to re-issue retried requests.
  final Dio dio;

  /// Maximum number of retry attempts (beyond the original request).
  final int maxAttempts;

  /// Delay before the first retry; doubles with each subsequent attempt.
  final Duration baseDelay;

  final bool Function(DioException error) _retryIf;

  static bool _defaultRetryIf(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  static const _retryAttemptKey = '_core_package_retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra[_retryAttemptKey] as int?) ?? 0;

    if (attempt >= maxAttempts || !_retryIf(err)) {
      handler.next(err);
      return;
    }

    final delay = baseDelay * pow(2, attempt).toInt();
    AppLogger.warning(
      'Retrying request (${attempt + 1}/$maxAttempts) after ${delay.inMilliseconds}ms: '
      '${err.requestOptions.method} ${err.requestOptions.uri}',
      tag: 'network',
    );
    await Future<void>.delayed(delay);

    try {
      final options = err.requestOptions;
      options.extra[_retryAttemptKey] = attempt + 1;

      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
