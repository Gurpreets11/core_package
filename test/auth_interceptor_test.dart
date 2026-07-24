import 'package:core_package/core_package.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('AuthInterceptor', () {
    test('injects the Authorization header when a token is available',
        () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      final dioAdapter = DioAdapter(dio: dio);

      String? capturedHeader;
      dioAdapter.onGet(
        '/me',
        (server) => server.reply(200, {'ok': true}),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedHeader = options.headers['Authorization'] as String?;
            handler.next(options);
          },
        ),
      );
      dio.interceptors.add(
        AuthInterceptor(
          getToken: () async => 'abc123',
          onUnauthorized: () async {},
        ),
      );

      await dio.get<dynamic>('/me');
      expect(capturedHeader, 'Bearer abc123');
    });

    test('calls onUnauthorized exactly once on a 401 response', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      final dioAdapter = DioAdapter(dio: dio);
      var unauthorizedCallCount = 0;

      dioAdapter.onGet(
        '/me',
        (server) => server.reply(401, {'message': 'no'}),
      );

      dio.interceptors.add(
        AuthInterceptor(
          getToken: () async => null,
          onUnauthorized: () async => unauthorizedCallCount++,
        ),
      );

      await expectLater(
        () => dio.get<dynamic>('/me'),
        throwsA(isA<DioException>()),
      );
      expect(unauthorizedCallCount, 1);
    });
  });
}
