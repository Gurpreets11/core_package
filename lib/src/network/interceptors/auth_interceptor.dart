import 'package:dio/dio.dart';

/// Injects an Authorization header on every request and invokes
/// [onUnauthorized] whenever the server responds with `401`.
///
/// The token source and the unauthorized-handling behavior (e.g. clearing
/// session, navigating to login) are left to the consuming app — this
/// class only wires the hooks.
class AuthInterceptor extends Interceptor {
  /// Creates an [AuthInterceptor].
  ///
  /// [getToken] should return the current access token, or `null` if the
  /// user isn't authenticated. [onUnauthorized] is called once, before
  /// the error is rethrown, whenever a `401` response is received.
  AuthInterceptor({
    required Future<String?> Function() getToken,
    required Future<void> Function() onUnauthorized,
  })  : _getToken = getToken,
        _onUnauthorized = onUnauthorized;

  final Future<String?> Function() _getToken;
  final Future<void> Function() _onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _onUnauthorized();
    }
    handler.next(err);
  }
}
