import 'package:dio/dio.dart';

import '../../logger/app_logger.dart';

/// Logs request/response/error details through [AppLogger], which is
/// itself a no-op in release builds — so this interceptor is safe to
/// leave attached in every environment.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    AppLogger.debug(
      '→ ${options.method} ${options.uri}',
      tag: 'network',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.debug(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      tag: 'network',
    );
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    AppLogger.error(
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri}',
      tag: 'network',
      error: err.message,
    );
    handler.next(err);
  }
}
