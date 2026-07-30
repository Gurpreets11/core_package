/// A reusable Flutter foundation: networking, error handling, logging,
/// validation, storage, connectivity, permissions, a configurable
/// theming contract, and base architecture classes for Clean
/// Architecture apps.
library core_package;

// Base architecture classes.
export 'src/base/repository.dart';
export 'src/base/result.dart';
export 'src/base/use_case.dart';

// Connectivity.
export 'src/connectivity/connectivity_service.dart';
export 'src/connectivity/connectivity_service_impl.dart';

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

// Permissions.
export 'src/permissions/permission_flow.dart';
export 'src/permissions/permission_service.dart';
export 'src/permissions/permission_service_impl.dart';

// Preferences.
export 'src/preferences/app_preferences_service.dart';
export 'src/preferences/app_preferences_service_impl.dart';

// Storage.
export 'src/storage/secure_storage_service.dart';
export 'src/storage/secure_storage_service_impl.dart';

// Theming.
export 'src/theme/app_spacing.dart';
export 'src/theme/app_theme_config.dart';
export 'src/theme/app_theme_scope.dart';

// Utils.
export 'src/utils/debouncer.dart';
export 'src/utils/extensions.dart';
export 'src/utils/formatters.dart';
export 'src/utils/pagination_controller.dart';

// Validation.
export 'src/validators/validators.dart';

// Widgets — buttons.
export 'src/widgets/buttons/app_button.dart';
export 'src/widgets/buttons/app_dropdown_trigger.dart';
export 'src/widgets/buttons/app_loading_spinner.dart';

// Widgets — cards, chips, badges.
export 'src/widgets/cards/app_card.dart';

// Widgets — dialogs & bottom sheets.
export 'src/widgets/dialogs/app_dialogs.dart';
export 'src/widgets/dialogs/app_snackbar.dart';

// Widgets — form fields.
export 'src/widgets/form_fields/app_date_field.dart';
export 'src/widgets/form_fields/app_dropdown_field.dart';
export 'src/widgets/form_fields/app_search_field.dart';
export 'src/widgets/form_fields/app_selection_fields.dart';
export 'src/widgets/form_fields/app_text_field.dart';

// Widgets — navigation.
export 'src/widgets/navigation/app_bottom_nav_bar.dart';
export 'src/widgets/navigation/app_common_bar.dart';
export 'src/widgets/navigation/app_exit_guard.dart';
export 'src/widgets/navigation/app_navigation_drawer.dart';

// Widgets — empty/error/loading/connectivity/pagination states.
export 'src/widgets/states/app_connectivity_banner.dart';
export 'src/widgets/states/app_paginated_list_view.dart';
export 'src/widgets/states/app_shimmer.dart';
export 'src/widgets/states/app_state_placeholders.dart';
