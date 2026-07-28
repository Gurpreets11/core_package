import 'dart:async';

import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginationController.loadNextPage', () {
    test(
      'calls onLoadMore and toggles isLoadingMore around the call',
      () async {
        var loadCallCount = 0;
        final loadingStates = <bool>[];

        final controller = PaginationController(
          onLoadMore: () async {
            loadCallCount++;
            await Future<void>.delayed(Duration.zero);
          },
        );
        addTearDown(controller.dispose);
        controller.addListener(
          () => loadingStates.add(controller.isLoadingMore),
        );

        await controller.loadNextPage();

        expect(loadCallCount, 1);
        expect(loadingStates, [true, false]);
        expect(controller.isLoadingMore, isFalse);
      },
    );

    test('does not call onLoadMore again while already loading', () async {
      var loadCallCount = 0;
      final completer = Completer<void>();

      final controller = PaginationController(
        onLoadMore: () {
          loadCallCount++;
          return completer.future;
        },
      );
      addTearDown(controller.dispose);

      final first = controller.loadNextPage();
      final second = controller.loadNextPage();
      completer.complete();
      await Future.wait([first, second]);

      expect(loadCallCount, 1);
    });

    test('does not call onLoadMore once hasMore is false', () async {
      var loadCallCount = 0;
      final controller = PaginationController(
        onLoadMore: () async => loadCallCount++,
      );
      addTearDown(controller.dispose);

      controller.setHasMore(false);
      await controller.loadNextPage();

      expect(loadCallCount, 0);
    });
  });

  group('PaginationController.setHasMore', () {
    test('notifies listeners only when the value actually changes', () {
      final controller = PaginationController(onLoadMore: () async {});
      addTearDown(controller.dispose);

      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.setHasMore(true); // unchanged (already true)
      expect(notifyCount, 0);

      controller.setHasMore(false);
      expect(notifyCount, 1);
    });
  });

  group('PaginationController.reset', () {
    test('restores hasMore to true and isLoadingMore to false', () async {
      final controller = PaginationController(onLoadMore: () async {});
      addTearDown(controller.dispose);

      controller.setHasMore(false);
      controller.reset();

      expect(controller.hasMore, isTrue);
      expect(controller.isLoadingMore, isFalse);
    });
  });
}
