import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('runs the action once after the delay', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      addTearDown(debouncer.dispose);

      var callCount = 0;
      debouncer.run(() => callCount++);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(callCount, 1);
    });

    test(
      'cancels a pending call when run again before the delay elapses',
      () async {
        final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
        addTearDown(debouncer.dispose);

        var callCount = 0;
        debouncer.run(() => callCount++);
        await Future<void>.delayed(const Duration(milliseconds: 20));
        debouncer.run(() => callCount++);

        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(callCount, 1);
      },
    );

    test('cancel() prevents the pending action from running', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      addTearDown(debouncer.dispose);

      var callCount = 0;
      debouncer.run(() => callCount++);
      debouncer.cancel();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(callCount, 0);
    });
  });
}
