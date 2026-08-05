/// Compares dot-separated version strings (`"1.4.2"` vs `"1.10.0"`) by
/// numeric segment rather than lexically — so `"1.10.0"` correctly
/// compares as newer than `"1.9.0"` (a plain string comparison would
/// get this wrong).
///
/// A small, optional helper for apps implementing `UpdateCheckService`
/// — computing `updateRequired` is that interface's job, not this
/// package's, but most implementations end up needing exactly this
/// comparison.
///
/// ```dart
/// final updateRequired = AppVersionComparator.isBelow(
///   currentVersion,
///   minimumSupportedVersion,
/// );
/// ```
abstract final class AppVersionComparator {
  /// Returns `true` if [current] is strictly below [minimum].
  static bool isBelow(String current, String minimum) {
    final currentParts = _parse(current);
    final minimumParts = _parse(minimum);
    final length = currentParts.length > minimumParts.length
        ? currentParts.length
        : minimumParts.length;

    for (var i = 0; i < length; i++) {
      final currentSegment = i < currentParts.length ? currentParts[i] : 0;
      final minimumSegment = i < minimumParts.length ? minimumParts[i] : 0;
      if (currentSegment != minimumSegment) {
        return currentSegment < minimumSegment;
      }
    }
    return false;
  }

  static List<int> _parse(String version) {
    return version
        .split('.')
        .map((segment) => int.tryParse(segment) ?? 0)
        .toList();
  }
}
