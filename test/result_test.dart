import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.when', () {
    test('calls onSuccess for a Success', () {
      final Result<int> result = Result.success(2);
      final output = result.when(
        onSuccess: (value) => 'value: $value',
        onFailure: (failure) => 'failure',
      );
      expect(output, 'value: 2');
    });

    test('calls onFailure for a Failed', () {
      final Result<int> result = Result<int>.failure(const ServerFailure());
      final output = result.when(
        onSuccess: (value) => 'value',
        onFailure: (failure) => 'failure: ${failure.message}',
      );
      expect(output, contains('failure:'));
    });
  });

  group('Result.map', () {
    test('transforms a successful value', () {
      final Result<int> result = Result.success(2);
      final mapped = result.map((value) => value * 10);
      expect(mapped, isA<Success<int>>());
      expect((mapped as Success<int>).value, 20);
    });

    test('passes a failure through unchanged', () {
      const failure = ServerFailure('boom');
      final Result<int> result = Result<int>.failure(failure);
      final mapped = result.map((value) => value * 10);
      expect(mapped, isA<Failed<int>>());
      expect((mapped as Failed<int>).failure, failure);
    });
  });

  group('Result.flatMap', () {
    test('chains a successful result into another Result', () {
      final Result<int> result = Result.success(2);
      final chained = result.flatMap((value) => Result.success(value + 1));
      expect(chained, isA<Success<int>>());
      expect((chained as Success<int>).value, 3);
    });

    test('short-circuits on failure without calling transform', () {
      var called = false;
      final Result<int> result = Result<int>.failure(const NetworkFailure());
      final chained = result.flatMap((value) {
        called = true;
        return Result.success(value + 1);
      });
      expect(called, isFalse);
      expect(chained, isA<Failed<int>>());
    });
  });

  group('Result.getOrElse / valueOrNull / failureOrNull', () {
    test('getOrElse returns the value for Success', () {
      final Result<int> result = Result.success(5);
      expect(result.getOrElse((_) => -1), 5);
    });

    test('getOrElse returns the fallback for Failed', () {
      final Result<int> result = Result<int>.failure(const CacheFailure());
      expect(result.getOrElse((_) => -1), -1);
    });

    test('valueOrNull / failureOrNull reflect the correct branch', () {
      final Result<int> success = Result.success(1);
      final Result<int> failure = Result<int>.failure(const UnknownFailure());

      expect(success.valueOrNull, 1);
      expect(success.failureOrNull, isNull);
      expect(failure.valueOrNull, isNull);
      expect(failure.failureOrNull, isA<UnknownFailure>());
    });
  });
}
