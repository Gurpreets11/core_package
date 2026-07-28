import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AppLogger.detachSink());

  group('AppLogger sink', () {
    test('forwards log entries to an attached sink', () {
      final received = <LogEntry>[];
      AppLogger.attachSink(received.add);

      AppLogger.info('hello', tag: 'test');
      AppLogger.error('boom', tag: 'test', error: Exception('x'));

      expect(received, hasLength(2));
      expect(received[0].level, LogLevel.info);
      expect(received[0].message, 'hello');
      expect(received[1].level, LogLevel.error);
      expect(received[1].error, isA<Exception>());
    });

    test('stops forwarding after detachSink', () {
      final received = <LogEntry>[];
      AppLogger.attachSink(received.add);
      AppLogger.detachSink();

      AppLogger.info('should not be received');

      expect(received, isEmpty);
    });

    test('does nothing when no sink is attached', () {
      expect(() => AppLogger.debug('no sink attached'), returnsNormally);
    });
  });
}
