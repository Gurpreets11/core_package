import 'package:dio/dio.dart';

import '../base/result.dart';
import '../exceptions/exception_mapper.dart';

/// A thin, app-agnostic wrapper around [Dio].
///
/// Configure once per app with the correct `baseUrl` for its environment,
/// attach whatever interceptors it needs (auth, logging, retry), and use
/// [get]/[post]/[put]/[delete]/[patch] from repository implementations.
/// Every method returns a [Result], so calling code never needs a
/// try/catch — failures are values, not thrown exceptions.
///
/// Each method takes a required [fromJson] mapper, so callers get back a
/// typed value instead of raw `dynamic` — this keeps response parsing
/// consistent across every app built on this package, instead of each
/// app inventing its own casting convention.
///
/// ```dart
/// final result = await apiClient.get<Lead>(
///   '/leads/42',
///   fromJson: (json) => Lead.fromJson(json as Map<String, dynamic>),
/// );
/// ```
///
/// If you genuinely don't need parsing (e.g. a `204 No Content` response,
/// or a file download), use [raw] instead.
class ApiClient {
  /// Creates an [ApiClient] wrapping the given [dio] instance.
  ///
  /// Pass a fully configured [Dio] (base URL, timeouts, interceptors
  /// already attached) — this class does not configure Dio itself, so
  /// each app controls its own environment/flavor setup.
  ApiClient(this._dio);

  final Dio _dio;

  /// Performs a typed GET request to [path], parsing the response body
  /// with [fromJson].
  Future<Result<T>> get<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        () => _dio.get(path, queryParameters: queryParameters),
        fromJson,
      );

  /// Performs a typed POST request to [path] with the given [data].
  Future<Result<T>> post<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        () => _dio.post(path, data: data, queryParameters: queryParameters),
        fromJson,
      );

  /// Performs a typed PUT request to [path] with the given [data].
  Future<Result<T>> put<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        () => _dio.put(path, data: data, queryParameters: queryParameters),
        fromJson,
      );

  /// Performs a typed PATCH request to [path] with the given [data].
  Future<Result<T>> patch<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        () => _dio.patch(path, data: data, queryParameters: queryParameters),
        fromJson,
      );

  /// Performs a typed DELETE request to [path].
  Future<Result<T>> delete<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        () => _dio.delete(path, data: data, queryParameters: queryParameters),
        fromJson,
      );

  /// Escape hatch for endpoints you don't want to parse at all (e.g.
  /// downloading a file, or a `204 No Content` response). Returns the
  /// raw [Response] wrapped in a [Result].
  Future<Result<Response<dynamic>>> raw(
    Future<Response<dynamic>> Function(Dio dio) request,
  ) async {
    try {
      final response = await request(_dio);
      return Result.success(response);
    } catch (error) {
      return Result.failure(ExceptionMapper.toFailure(error));
    }
  }

  Future<Result<T>> _request<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic json) fromJson,
  ) async {
    try {
      final response = await request();
      return Result.success(fromJson(response.data));
    } catch (error) {
      return Result.failure(ExceptionMapper.toFailure(error));
    }
  }
}
