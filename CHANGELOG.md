# Changelog

## 0.3.0

- **Storage**: `SecureStorageService` interface + `SecureStorageServiceImpl` (backed by `flutter_secure_storage`), so consuming apps depend on an abstraction instead of the plugin directly — makes anything built on it (e.g. an auth data source) unit-testable with a fake, no platform channel needed.
- **Connectivity**: `ConnectivityService` interface + `ConnectivityServiceImpl` (backed by `connectivity_plus`), plus `AppConnectivityBanner` — a themed slide-down "No internet connection" banner widget.
- **Permissions**: `PermissionService` + `PermissionServiceImpl` (backed by `permission_handler`, with its own `AppPermission`/`AppPermissionStatus` enums so `permission_handler`'s types never leak into consuming apps), plus `PermissionFlow.ensureGranted` — a ready-made check → rationale dialog → request → "open Settings" flow.
- **Logging**: `AppLogger` now supports `attachSink`/`detachSink` — an attached `LogSink` receives every log entry in every build mode (including release), for one-line Crashlytics/Sentry wiring later. Developer-console output remains debug-only, unchanged.
- **Testing**: added coverage for `AppLogger`'s sink, `PermissionFlow` (via a mocked `PermissionService`), and `AppConnectivityBanner` (via a fake `ConnectivityService`). `SecureStorageServiceImpl`/`ConnectivityServiceImpl`/`PermissionServiceImpl` themselves aren't unit-tested here, since they wrap real platform plugins — the abstractions they implement are the testable surface.

## 0.2.1

- **Fix**: `UseCase.call`'s return type still referenced `Type` (Dart's built-in `Type` class) instead of the renamed generic parameter `T`, breaking every subclass override. `v0.2.0` should not be used — depend on `v0.2.1` or later.

## 0.2.0

Phase 2 — common widgets, all consuming `AppThemeConfig`/`AppThemeScope` exclusively (no hardcoded colors):

- **Buttons**: `AppButton` (primary/secondary/outlined/text variants, built-in loading state).
- **Form fields**: `AppTextField`, `AppDropdownField<T>`, `AppDateField`, `AppCheckbox`, `AppRadioGroup<T>`.
- **Cards/chips/badges**: `AppCard`, `AppChip` (`AppStatusTone`: neutral/success/warning/danger), `AppBadge`.
- **Dialogs/sheets**: `AppDialogs.showConfirm/showAlert/showActionSheet`, `AppConfirmSheet`.
- **States**: `AppEmptyState`, `AppErrorState`, `AppShimmer` + `AppShimmerListTile` (custom-built, no extra dependency).
- **Navigation**: `AppCommonBar`, `AppNavigationDrawer` + `AppDrawerItem`.
- **Testing**: widget tests for `AppButton`, `AppEmptyState`/`AppErrorState`, `AppTextField`'s validator integration.

## 0.1.0

Phase 1 scaffold, hardened before first publish:

- **Networking**: `ApiClient` with typed generic methods (`get<T>`, `post<T>`, `put<T>`, `patch<T>`, `delete<T>`, `raw`) taking a required `fromJson` mapper, so every app parses responses the same way. `AuthInterceptor`, `LoggingInterceptor`, and a configurable `RetryInterceptor` (exponential backoff, transient-failure detection).
- **Result**: extracted into its own file with full chaining support — `map`, `flatMap`, `getOrElse`, `valueOrNull`, `failureOrNull` — in addition to `when`.
- **Exceptions/Failures**: `AppException` hierarchy, `Failure` hierarchy, `ExceptionMapper`.
- **Logging**: `AppLogger` (silent in release builds).
- **Validation**: `Validators` (required, email, phone, min/max length, password, matches, compose).
- **Theming**: `AppThemeConfig` supports light **and dark mode** from a single config (`toThemeData(brightness: ...)`), a wired-up `textTheme`, and an `AppSpacing` scale (`xs`/`sm`/`md`/`lg`/`xl`) derived from `spacingUnit`. `AppThemeScope` exposes it via `InheritedWidget`.
- **Base architecture**: `UseCase<T, Params>`, `Repository` marker interface.
- **Testing**: coverage for `Result` chaining, `ApiClient` (via mocked Dio adapter — success, 401 mapping, network-error mapping), `AuthInterceptor`, and `AppThemeConfig` (light/dark derivation, spacing scale).
- **CI**: GitHub Actions running `flutter analyze`, `flutter test`, format checks, and a `dart_apitool`-based check that flags undeclared breaking API changes on PRs.
