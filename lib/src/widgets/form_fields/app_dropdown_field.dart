import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A themed dropdown field, wrapping [DropdownButtonFormField] with the
/// same border/radius conventions as [AppTextField].
///
/// ```dart
/// AppDropdownField<Organization>(
///   label: 'Organization',
///   value: selectedOrg,
///   items: orgs,
///   itemLabel: (org) => org.name,
///   onChanged: (org) => setState(() => selectedOrg = org),
/// )
/// ```
class AppDropdownField<T> extends StatelessWidget {
  /// Creates an [AppDropdownField].
  const AppDropdownField({
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
    super.key,
  });

  /// The floating label text.
  final String label;

  /// The currently selected value, if any.
  final T? value;

  /// The full list of selectable items.
  final List<T> items;

  /// Renders an item as display text.
  final String Function(T item) itemLabel;

  /// Called when the selection changes.
  final ValueChanged<T?> onChanged;

  /// A validator run by the surrounding `Form` on submit.
  final String? Function(T? value)? validator;

  /// Whether the field accepts input.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ),
          )
          .toList(),
    );
  }
}
