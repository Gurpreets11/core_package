import 'package:flutter/widgets.dart';

/// Drives infinite-scroll pagination: watches a [ScrollController] and
/// calls [onLoadMore] when the user nears the bottom, tracking loading
/// and "has more pages" state so a list widget can react to it.
///
/// [loadNextPage] is public and safe to call directly (from a "Load
/// more" button, a test, or the scroll listener) — it doesn't require
/// [scrollController] to be attached to a real [Scrollable], since the
/// scroll-position check only happens inside the internal listener.
///
/// ```dart
/// final controller = PaginationController(
///   onLoadMore: () => leadsController.loadNextPage(),
/// );
///
/// ListView.builder(
///   controller: controller.scrollController,
///   itemCount: leads.length + (controller.hasMore ? 1 : 0),
///   itemBuilder: (context, index) {
///     if (index >= leads.length) return const AppShimmerListTile();
///     return LeadTile(leads[index]);
///   },
/// )
/// ```
class PaginationController extends ChangeNotifier {
  /// Creates a [PaginationController].
  ///
  /// [onLoadMore] is called when more items should be fetched.
  /// [scrollThreshold] is how close (in logical pixels) to the bottom
  /// of the scroll extent triggers the next page.
  PaginationController({
    required this.onLoadMore,
    this.scrollThreshold = 200,
  }) {
    scrollController.addListener(_handleScroll);
  }

  /// Called to fetch the next page. Should update whatever list state
  /// the caller owns, and call [setHasMore] once it knows whether more
  /// pages remain.
  final Future<void> Function() onLoadMore;

  /// Distance from the bottom (in logical pixels) that triggers
  /// loading the next page.
  final double scrollThreshold;

  /// The scroll controller to attach to the list widget.
  final ScrollController scrollController = ScrollController();

  /// Whether a page load is currently in flight.
  bool isLoadingMore = false;

  /// Whether more pages are believed to be available. Starts `true`;
  /// call [setHasMore] with `false` once the caller detects the last
  /// page.
  bool hasMore = true;

  void _handleScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - scrollThreshold) {
      loadNextPage();
    }
  }

  /// Triggers [onLoadMore] if not already loading and [hasMore] is
  /// `true`. Safe to call repeatedly — a call while already loading,
  /// or after [hasMore] is `false`, is a no-op.
  Future<void> loadNextPage() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      await onLoadMore();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Updates whether more pages remain. Call this from [onLoadMore]
  /// once you know the fetched page was the last one.
  void setHasMore(bool value) {
    if (hasMore == value) return;
    hasMore = value;
    notifyListeners();
  }

  /// Resets pagination state (e.g. after a pull-to-refresh), so the
  /// next scroll-triggered load starts from a clean slate.
  void reset() {
    hasMore = true;
    isLoadingMore = false;
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.dispose();
  }
}
