import 'package:meta/meta.dart';

/// A named spacing scale derived from a single base [unit], so shared
/// widgets reference `spacing.md` instead of re-deriving multiples of a
/// raw number inline. Access via `AppThemeConfig.spacing`.
@immutable
class AppSpacing {
  /// Creates an [AppSpacing] scale from the given base [unit].
  const AppSpacing(this.unit);

  /// The base spacing unit (in logical pixels) this scale derives from.
  final double unit;

  /// Half the base unit — for tight gaps (e.g. icon-to-label spacing).
  double get xs => unit * 0.5;

  /// The base unit itself — the default gap between related elements.
  double get sm => unit;

  /// Double the base unit — the default gap between unrelated sections.
  double get md => unit * 2;

  /// Triple the base unit — for larger section separation.
  double get lg => unit * 3;

  /// Quadruple the base unit — for page-level padding/margins.
  double get xl => unit * 4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AppSpacing && unit == other.unit);

  @override
  int get hashCode => unit.hashCode;
}
