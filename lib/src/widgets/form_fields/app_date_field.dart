import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';

/// A themed date field: a read-only [TextFormField] that opens the
/// platform date picker on tap, so every app gets consistent date
/// selection UX instead of each screen wiring `showDatePicker` by hand.
///
/// ```dart
/// AppDateField(
///   label: 'Date of birth',
///   value: dob,
///   firstDate: DateTime(1900),
///   lastDate: DateTime.now(),
///   onChanged: (date) => setState(() => dob = date),
/// )
/// ```
class AppDateField extends StatefulWidget {
  /// Creates an [AppDateField].
  const AppDateField({
    required this.label,
    required this.onChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.enabled = true,
    super.key,
  });

  /// The floating label text.
  final String label;

  /// The currently selected date, if any.
  final DateTime? value;

  /// Called when a date is picked.
  final ValueChanged<DateTime> onChanged;

  /// The earliest selectable date. Defaults to 100 years before now.
  final DateTime? firstDate;

  /// The latest selectable date. Defaults to 5 years after now.
  final DateTime? lastDate;

  /// Formats [value] for display. Defaults to `yyyy-MM-dd`.
  final String Function(DateTime date)? dateFormat;

  /// Whether the field can be tapped to open the picker.
  final bool enabled;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formattedValue());
  }

  @override
  void didUpdateWidget(covariant AppDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = _formattedValue();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formattedValue() {
    final value = widget.value;
    if (value == null) return '';
    return (widget.dateFormat ?? _defaultFormat).call(value);
  }

  static String _defaultFormat(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final now = DateTime.now();

    return TextFormField(
      readOnly: true,
      enabled: widget.enabled,
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.resolvedFieldBorderRadius),
        ),
      ),
      onTap: widget.enabled
          ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: widget.value ?? now,
                firstDate: widget.firstDate ?? DateTime(now.year - 100),
                lastDate: widget.lastDate ?? DateTime(now.year + 5),
              );
              if (picked != null) widget.onChanged(picked);
            }
          : null,
    );
  }
}
