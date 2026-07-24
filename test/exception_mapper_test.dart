import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExceptionMapper.toFailure', () {
    test('maps NetworkException to NetworkFailure', () {
      final failure = ExceptionMapper.toFailure(const NetworkException());
      expect(failure, isA<NetworkFailure>());
    });

    test('maps UnauthorizedException to UnauthorizedFailure', () {
      final failure = ExceptionMapper.toFailure(const UnauthorizedException());
      expect(failure, isA<UnauthorizedFailure>());
    });

    test('maps an unrecognized error to UnknownFailure', () {
      final failure = ExceptionMapper.toFailure(Exception('boom'));
      expect(failure, isA<UnknownFailure>());
    });
  });
}
