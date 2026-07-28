import 'package:intl/intl.dart';

/// Common date/number/currency formatters, so every app formats these
/// consistently instead of each screen writing its own `DateFormat`
/// pattern or manual currency string-building.
abstract final class AppFormatters {
  /// Formats [date] using [pattern] (defaults to `yyyy-MM-dd`).
  static String date(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
  }

  /// Formats [date] as a short, human-friendly string (e.g. "Jul 28, 2026").
  static String friendlyDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Formats [date] relative to now (e.g. "2 hours ago", "in 3 days").
  /// Falls back to [friendlyDate] beyond a week in either direction.
  static String relativeDate(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final difference = reference.difference(date);

    if (difference.inDays.abs() >= 7) return friendlyDate(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inDays < 0) return 'in ${-difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inHours < 0) return 'in ${-difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    if (difference.inMinutes < 0) return 'in ${-difference.inMinutes}m';
    return 'just now';
  }

  /// Formats [amount] as currency (e.g. "$1,234.50"). Pass [symbol] and
  /// [decimalDigits] to match the app's locale/currency.
  static String currency(
    num amount, {
    String symbol = '\$',
    int decimalDigits = 2,
  }) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  /// Formats [value] with thousands separators (e.g. "12,345").
  static String number(num value, {int decimalDigits = 0}) {
    final format = NumberFormat.decimalPattern()
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return format.format(value);
  }

  /// Formats [value] compactly (e.g. 1200 → "1.2K", 3400000 → "3.4M").
  static String compactNumber(num value) {
    return NumberFormat.compact().format(value);
  }
}
