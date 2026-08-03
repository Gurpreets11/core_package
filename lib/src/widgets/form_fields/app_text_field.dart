import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';
import '../../validators/validators.dart';

/// A themed text field, wrapping [TextFormField] so every app gets
/// consistent border radius, spacing, and error styling from
/// [AppThemeScope] without repeating decoration code per screen.
///
/// ```dart
/// AppTextField(
///   label: 'Email',
///   controller: emailController,
///   validator: Validators.compose([
///     Validators.required(),
///     Validators.email(),
///   ]),
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    required this.label,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onChanged,
    super.key,
  });

  /// The floating label / hint text.
  final String label;

  /// Controls the field's text. Optional if you're managing state
  /// another way (e.g. via `onChanged` alone).
  final TextEditingController? controller;

  /// A [Validator] run by the surrounding `Form` on submit.
  final Validator? validator;

  /// Whether to obscure input (for password fields).
  final bool obscureText;

  /// The keyboard type to show (e.g. `TextInputType.emailAddress`).
  final TextInputType? keyboardType;

  /// Optional helper text shown below the field.
  final String? helperText;

  /// An optional leading icon.
  final IconData? prefixIcon;

  /// An optional trailing icon (e.g. a show/hide-password toggle).
  final Widget? suffixIcon;

  /// Whether the field accepts input.
  final bool enabled;

  /// Called on every keystroke.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final fieldStyle = config.fieldStyle;

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        filled: fieldStyle.filled,
        fillColor: fieldStyle.filled
            ? fieldStyle.fillColor ?? config.onSurface.withValues(alpha: 0.04)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            config.resolvedFieldBorderRadius,
          ),
        ),
      ),
    );
  }
}
