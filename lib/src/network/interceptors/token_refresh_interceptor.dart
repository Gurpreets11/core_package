import 'package:dio/dio.dart';

/// Refreshes an expired access token and retries the failed request,
/// instead of logging the user out on the first `401`.
///
/// On a `401` it calls [refreshToken] (a single refresh is shared by all
/// requests that fail at the same time). If a new token comes back, the
/// original request is retried once with it. If refreshing fails (returns
/// `null` or throws), [onSessionExpired] is called so the app can sign
/// the user out and explain why.
///
/// Add it **before** [AuthInterceptor] and give [AuthInterceptor] a no-op
/// `onUnauthorized`, so a `401` isn't treated as a logout before the
/// refresh has had a chance:
///
/// ```dart
/// dio.interceptors.addAll([
///   TokenRefreshInterceptor(
///     dio: dio,
///     refreshToken: authService.refreshToken,
///     onSessionExpired: () async => authController.expireSession(),
///   ),
///   AuthInterceptor(
///     getToken: authService.readToken,
///     onUnauthorized: () async {},
///   ),
/// ]);
/// ```
///
/// [refreshToken] must not use the same [Dio] instance (or at least not
/// these interceptors), otherwise a failing refresh would trigger itself.
class TokenRefreshInterceptor extends Interceptor {
  /// Creates a [TokenRefreshInterceptor].
  TokenRefreshInterceptor({
    required Dio dio,
    required Future<String?> Function() refreshToken,
    required Future<void> Function() onSessionExpired,
    this.skipPaths = const [],
  })  : _dio = dio,
        _refreshToken = refreshToken,
        _onSessionExpired = onSessionExpired;

  final Dio _dio;
  final Future<String?> Function() _refreshToken;
  final Future<void> Function() _onSessionExpired;

  /// Request paths (substring match) that never trigger a refresh, such
  /// as the login and refresh endpoints themselves.
  final List<String> skipPaths;

  static const _retriedKey = '_core_package_token_refreshed';

  Future<String?>? _refreshing;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = request.extra[_retriedKey] == true;
    final skipped = skipPaths.any(request.path.contains);

    if (!isUnauthorized || alreadyRetried || skipped) {
      handler.next(err);
      return;
    }

    String? newToken;
    try {
      newToken = await _refreshOnce();
    } catch (_) {
      newToken = null;
    }

    if (newToken == null || newToken.isEmpty) {
      await _onSessionExpired();
      handler.next(err);
      return;
    }

    try {
      request.headers['Authorization'] = 'Bearer $newToken';
      request.extra[_retriedKey] = true;
      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshOnce() {
    final inFlight = _refreshing;
    if (inFlight != null) return inFlight;

    final future = _refreshToken().whenComplete(() => _refreshing = null);
    _refreshing = future;
    return future;
  }
}
