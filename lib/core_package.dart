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
