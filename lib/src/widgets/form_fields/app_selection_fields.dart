import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A themed checkbox with a tappable label, using the theme's primary
/// color for the checked state.
///
/// ```dart
/// AppCheckbox(
///   label: 'I agree to the Terms of Service',
///   value: agreed,
///   onChanged: (value) => setState(() => agreed = value),
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  /// Creates an [AppCheckbox].
  const AppCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The label shown next to the checkbox; tapping it also toggles.
  final String label;

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called with the new value when toggled.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(config.borderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: config.spacing.xs),
        child: Row(
          children: [
            Checkbox(
              value: value,
              activeColor: config.primary,
              onChanged: (checked) => onChanged(checked ?? false),
            ),
            SizedBox(width: config.spacing.xs),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}

/// A themed radio button group for selecting one value out of several.
///
/// ```dart
/// AppRadioGroup<Priority>(
///   value: selectedPriority,
///   options: Priority.values,
///   optionLabel: (p) => p.label,
///   onChanged: (p) => setState(() => selectedPriority = p),
/// )
/// ```
class AppRadioGroup<T> extends StatelessWidget {
  /// Creates an [AppRadioGroup].
  const AppRadioGroup({
    required this.options,
    required this.optionLabel,
    required this.onChanged,
    this.value,
    super.key,
  });

  /// The currently selected value, if any.
  final T? value;

  /// The full list of selectable options.
  final List<T> options;

  /// Renders an option as display text.
  final String Function(T option) optionLabel;

  /// Called when the selection changes.
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options
          .map(
            (option) => RadioListTile<T>(
              value: option,
              groupValue: value,
              activeColor: config.primary,
              title: Text(optionLabel(option)),
              onChanged: onChanged,
              contentPadding: EdgeInsets.zero,
            ),
          )
          .toList(),
    );
  }
}
