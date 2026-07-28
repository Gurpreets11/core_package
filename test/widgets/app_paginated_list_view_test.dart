import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('AppPaginatedListView', () {
    testWidgets('shows shimmer placeholders while loading the first page', (
      tester,
    ) async {
      final controller = PaginationController(onLoadMore: () async {});
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          AppPaginatedListView<String>(
            items: const [],
            controller: controller,
            isLoadingFirstPage: true,
            itemBuilder: (context, item) => Text(item),
          ),
        ),
      );

      expect(find.byType(AppShimmerListTile), findsWidgets);
    });

    testWidgets('shows the empty state when items is empty', (tester) async {
      final controller = PaginationController(onLoadMore: () async {});
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          AppPaginatedListView<String>(
            items: const [],
            controller: controller,
            itemBuilder: (context, item) => Text(item),
          ),
        ),
      );

      expect(find.byType(AppEmptyState), findsOneWidget);
    });

    testWidgets('renders each item via itemBuilder', (tester) async {
      final controller = PaginationController(onLoadMore: () async {});
      addTearDown(controller.dispose);
      controller.setHasMore(false);

      await tester.pumpWidget(
        wrap(
          AppPaginatedListView<String>(
            items: const ['Alpha', 'Beta'],
            controller: controller,
            itemBuilder: (context, item) => Text(item),
          ),
        ),
      );

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('shows a loading footer while hasMore is true', (
      tester,
    ) async {
      final controller = PaginationController(onLoadMore: () async {});
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          AppPaginatedListView<String>(
            items: const ['Alpha'],
            controller: controller,
            itemBuilder: (context, item) => Text(item),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
