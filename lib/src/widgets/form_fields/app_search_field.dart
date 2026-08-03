import 'package:flutter/material.dart';

import '../../theme/app_theme_scope.dart';
import '../../utils/debouncer.dart';

/// A themed search field with a debounced [onChanged] callback and a
/// clear button that appears once text is entered.
///
/// ```dart
/// AppSearchField(
///   hintText: 'Search leads',
///   onChanged: (query) => ref.read(leadsControllerProvider.notifier)
///       .search(query),
/// )
/// ```
class AppSearchField extends StatefulWidget {
  /// Creates an [AppSearchField].
  const AppSearchField({
    required this.onChanged,
    this.hintText = 'Search',
    this.debounceDuration = const Duration(milliseconds: 400),
    super.key,
  });

  /// Called with the current text after [debounceDuration] has passed
  /// since the last keystroke.
  final ValueChanged<String> onChanged;

  /// Placeholder text shown when empty.
  final String hintText;

  /// How long to wait after typing stops before calling [onChanged].
  final Duration debounceDuration;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final _controller = TextEditingController();
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: widget.debounceDuration);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    _debouncer.cancel();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);

    return TextField(
      controller: _controller,
      onChanged: (value) => _debouncer.run(() => widget.onChanged(value)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clear,
            );
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.resolvedFieldBorderRadius),
        ),
      ),
    );
  }
}
