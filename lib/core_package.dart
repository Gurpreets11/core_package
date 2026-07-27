/// A reusable Flutter foundation: networking, error handling, logging,
/// validation, a configurable theming contract, and base architecture
/// classes for Clean Architecture apps.
library core_package;

// Base architecture classes.
export 'src/base/repository.dart';
export 'src/base/result.dart';
export 'src/base/use_case.dart';

// Exceptions & failures.
export 'src/exceptions/app_exception.dart';
export 'src/exceptions/exception_mapper.dart';
export 'src/exceptions/failure.dart';

// Logging.
export 'src/logger/app_logger.dart';

// Networking.
export 'src/network/api_client.dart';
export 'src/network/api_response.dart';
export 'src/network/interceptors/auth_interceptor.dart';
export 'src/network/interceptors/logging_interceptor.dart';
export 'src/network/interceptors/retry_interceptor.dart';

// Theming.
export 'src/theme/app_spacing.dart';
export 'src/theme/app_theme_config.dart';
export 'src/theme/app_theme_scope.dart';

// Validation.
export 'src/validators/validators.dart';

// Widgets — buttons.
export 'src/widgets/buttons/app_button.dart';

// Widgets — cards, chips, badges.
export 'src/widgets/cards/app_card.dart';

// Widgets — dialogs & bottom sheets.
export 'src/widgets/dialogs/app_dialogs.dart';

// Widgets — form fields.
export 'src/widgets/form_fields/app_date_field.dart';
export 'src/widgets/form_fields/app_dropdown_field.dart';
export 'src/widgets/form_fields/app_selection_fields.dart';
export 'src/widgets/form_fields/app_text_field.dart';

// Widgets — navigation.
export 'src/widgets/navigation/app_common_bar.dart';
export 'src/widgets/navigation/app_navigation_drawer.dart';

// Widgets — empty/error/loading states.
export 'src/widgets/states/app_shimmer.dart';
export 'src/widgets/states/app_state_placeholders.dart';
