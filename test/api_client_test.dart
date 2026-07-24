import 'package:core_package/core_package.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiClient apiClient;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dioAdapter = DioAdapter(dio: dio);
    apiClient = ApiClient(dio);
  });

  group('ApiClient.get', () {
    test('parses a successful response through fromJson', () async {
      dioAdapter.onGet(
        '/leads/1',
        (server) => server.reply(200, {'id': 1, 'name': 'Test Lead'}),
      );

      final result = await apiClient.get<String>(
        '/leads/1',
        fromJson: (json) => (json as Map<String, dynamic>)['name'] as String,
      );

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).value, 'Test Lead');
    });

    test('maps a 401 response to UnauthorizedFailure', () async {
      dioAdapter.onGet(
        '/leads/1',
        (server) => server.reply(401, {'message': 'Unauthorized'}),
      );

      final result = await apiClient.get<dynamic>(
        '/leads/1',
        fromJson: (json) => json,
      );

      expect(result, isA<Failed<dynamic>>());
      expect((result as Failed<dynamic>).failure, isA<UnauthorizedFailure>());
    });

    test('maps a connection error to NetworkFailure', () async {
      dioAdapter.onGet(
        '/leads/1',
        (server) => server.throws(
          0,
          DioException.connectionError(
            requestOptions: RequestOptions(path: '/leads/1'),
            reason: 'no connection',
          ),
        ),
      );

      final result = await apiClient.get<dynamic>(
        '/leads/1',
        fromJson: (json) => json,
      );

      expect(result, isA<Failed<dynamic>>());
      expect((result as Failed<dynamic>).failure, isA<NetworkFailure>());
    });
  });

  group('ApiClient.post', () {
    test('sends the request body and parses the response', () async {
      dioAdapter.onPost(
        '/leads',
        (server) => server.reply(201, {'id': 2, 'name': 'New Lead'}),
        data: {'name': 'New Lead'},
      );

      final result = await apiClient.post<int>(
        '/leads',
        data: {'name': 'New Lead'},
        fromJson: (json) => (json as Map<String, dynamic>)['id'] as int,
      );

      expect(result, isA<Success<int>>());
      expect((result as Success<int>).value, 2);
    });
  });
}
