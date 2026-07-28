import 'package:flutter/material.dart';

import '../../utils/pagination_controller.dart';
import '../states/app_shimmer.dart';
import '../states/app_state_placeholders.dart';

/// A themed list wrapper combining pull-to-refresh, infinite scroll
/// (via [PaginationController]), a shimmering first-load state, and an
/// empty state — the common shape of a leads list, a product catalog,
/// or any other paginated list screen.
///
/// ```dart
/// AppPaginatedListView<Lead>(
///   items: leads,
///   controller: paginationController,
///   isLoadingFirstPage: leads.isEmpty && isLoading,
///   onRefresh: () => leadsController.refresh(),
///   itemBuilder: (context, lead) => LeadTile(lead),
///   emptyState: const AppEmptyState(title: 'No leads yet'),
/// )
/// ```
class AppPaginatedListView<T> extends StatelessWidget {
  /// Creates an [AppPaginatedListView].
  const AppPaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.controller,
    this.onRefresh,
    this.isLoadingFirstPage = false,
    this.emptyState,
    super.key,
  });

  /// The currently loaded items.
  final List<T> items;

  /// Builds a widget for each item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Drives infinite-scroll loading. See [PaginationController].
  final PaginationController controller;

  /// Called on pull-to-refresh. If `null`, pull-to-refresh is disabled.
  final Future<void> Function()? onRefresh;

  /// Shows a shimmering placeholder list instead of [items] — set this
  /// while the very first page is loading (not subsequent pages, which
  /// show a small loading footer instead).
  final bool isLoadingFirstPage;

  /// Shown when [items] is empty and not [isLoadingFirstPage]. Defaults
  /// to a generic [AppEmptyState].
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    if (isLoadingFirstPage) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => const AppShimmerListTile(),
      );
    }

    if (items.isEmpty) {
      return emptyState ?? const AppEmptyState(title: 'Nothing here yet');
    }

    final listView = AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListView.builder(
          controller: controller.scrollController,
          itemCount: items.length + (controller.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            return itemBuilder(context, items[index]);
          },
        );
      },
    );

    if (onRefresh == null) return listView;
    return RefreshIndicator(onRefresh: onRefresh!, child: listView);
  }
}
