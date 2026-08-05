# core_package

A reusable Flutter foundation for building Clean Architecture apps quickly:
networking, error handling, logging, validation, a configurable theming
contract, and base architecture classes — with zero business logic baked in,
so it's safe to reuse across any number of apps.

This package is deliberately unopinionated about *what* your app does — it
only standardizes *how* the plumbing works, so every app built on it shares
the same network layer, error handling, and design-token-driven theming.

## Status

🚧 Early development (`0.7.0`) — API may still change before a `1.0.0`
release. Currently distributed via GitHub; will move to
[pub.dev](https://pub.dev) once the API is stable.

## Install

```yaml
dependencies:
  core_package:
    git:
      url: https://github.com/your-org/core-package.git
      ref: main
```

## What's included

- **Networking** — `ApiClient`, a Dio wrapper with **typed** generic methods
  (`get<T>`, `post<T>`, ...) that take a `fromJson` mapper and return a
  `Result<T>`, so callers never need try/catch and never parse raw
  `dynamic` inconsistently. `AuthInterceptor`, `LoggingInterceptor`, and a
  configurable `RetryInterceptor` (exponential backoff on transient
  failures).
- **Result** — a chainable success/failure type: `when`, `map`, `flatMap`,
  `getOrElse`, `valueOrNull`, `failureOrNull` — for composing use cases
  without nested boilerplate.
- **Errors** — an `AppException` hierarchy (data layer) mapped via
  `ExceptionMapper` to a `Failure` hierarchy (domain/presentation layer).
- **Logging** — `AppLogger`, with console output silent in release builds
  and an optional `attachSink` hook so a crash-reporting service (once you
  add one) receives every log entry in every build mode.
- **Storage** — `SecureStorageService` (+ real `flutter_secure_storage`
  impl), so anything built on top is testable against a fake instead of a
  platform channel.
- **Preferences** — `AppPreferencesService` (+ real `shared_preferences`
  impl) for non-sensitive settings (theme mode, font scale, notification
  toggles) — kept separate from secure storage, and fully testable via
  `shared_preferences`' built-in mock support.
- **Connectivity** — `ConnectivityService` (+ real `connectivity_plus`
  impl) and `AppConnectivityBanner`, a themed offline banner.
- **Permissions** — `PermissionService` (+ real `permission_handler` impl,
  with its own enums so that package's types never leak out) and
  `PermissionFlow.ensureGranted` — a ready-made check → rationale →
  request → "open Settings" flow.
- **Utils** — `AppFormatters` (date, relative date, currency, number,
  compact number), `Debouncer`, `AppStringX`/`AppContextX` extensions, and
  `PaginationController` (infinite-scroll state machine).
- **Validation** — composable `Validators` (email, phone, password,
  required, min/max length, matches).
- **Theming** — `AppThemeConfig`, a design-token contract with **built-in
  light/dark mode support**, a wired-up `TextTheme`, a named
  `AppSpacing` scale (`xs`/`sm`/`md`/`lg`/`xl`), and component-level
  overrides (`cardStyle`/`fieldStyle`) for cards and form fields
  independent of the shared border radius/surface color. Shared widgets
  read exclusively from this, so each app can be branded differently
  without touching this package's code. `AppThemeScope` exposes it via
  `InheritedWidget`.
- **Responsive** — `AppBreakpoints`, `AppResponsive` (breakpoint checks,
  a per-breakpoint `value<T>` picker), and `AppResponsiveBuilder`.
- **Widgets** — buttons (including a gradient variant, custom-color
  overrides, and a themed loading spinner), form fields (including a
  debounced search field), cards/chips/badges, dialogs/action sheets,
  snackbars, a dropdown trigger button, empty/error/shimmer-loading/
  paginated-list states, a common app bar, a navigation drawer, and a
  bottom nav bar — see `lib/src/widgets/`.
- **Base classes** — `UseCase<T, Params>` and a `Repository` marker
  interface for Clean Architecture layering.
- **Feature flags** — `AppFeatureFlags`, opt-in gates for idle timeout,
  biometric lock, force-update checking, and localization.
- **Idle timeout** — `AppIdleTimeoutGuard`, auto-triggers a callback
  (e.g. logout) after a period of no activity.
- **Biometric lock** — `BiometricLockService` (+ real `local_auth` impl)
  for re-authentication on app resume.
- **Update checking** — `UpdateCheckService` (interface only — no
  universal backend exists) + `AppVersionComparator`.

## Quick start

```dart
import 'package:core_package/core_package.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// 1. Configure Dio for this app's environment.
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
dio.interceptors.addAll([
AuthInterceptor(
getToken: () async => tokenStorage.readToken(),
onUnauthorized: () async => authController.logout(),
),
RetryInterceptor(dio: dio, maxAttempts: 2),
LoggingInterceptor(),
]);

final apiClient = ApiClient(dio);

// 2. Call it with a typed fromJson mapper — no raw dynamic, no try/catch.
final result = await apiClient.get<Lead>(
'/leads/42',
fromJson: (json) => Lead.fromJson(json as Map<String, dynamic>),
);
result.when(
onSuccess: (lead) => print(lead.name),
onFailure: (failure) => print(failure.message),
);

// 3. Wrap the app root with this app's brand theme (light + dark).
void main() {
final themeConfig = AppThemeConfig(
primary: const Color(0xFF1A237E),
secondary: const Color(0xFF00897B),
background: const Color(0xFFF5F5F5),
surface: Colors.white,
error: const Color(0xFFD32F2F),
);

runApp(
AppThemeScope(
config: themeConfig,
child: MaterialApp(
theme: themeConfig.toThemeData(),
darkTheme: themeConfig.toThemeData(brightness: Brightness.dark),
themeMode: ThemeMode.system,
home: const HomeScreen(),
),
),
);
}
```

## Roadmap

See the project's architecture guide for the full phased plan (common
widgets, storage, connectivity, and the companion starter template repo).

## Contributing

Issues and PRs welcome — see `CONTRIBUTING.md` (coming soon).

## License

MIT — see `LICENSE`.