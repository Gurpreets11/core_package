# Changelog

## 0.6.1

- **Fix**: dark mode made text invisible on cards and several other widgets (`AppCard`, `AppEmptyState`, `AppErrorState`, `AppChip`, `AppShimmer`, and anything else reading `AppThemeConfig.surface`/`onSurface`/`background`/`onBackground` via `AppThemeScope.of`). Root cause: `AppThemeScope.of` always returned the *light-mode* values for those four fields regardless of which mode was actually active, while `Theme.of(context).textTheme` (used for most text) correctly flipped to dark-mode colors — so widgets ended up rendering dark-mode text against light-mode backgrounds, or vice versa.
    - Fixed centrally: `AppThemeConfig.resolvedFor(Brightness)` normalizes `surface`/`background`/`onSurface`/`onBackground` to the dark variants when needed; `AppThemeScope.of` now calls this automatically using `Theme.of(context).brightness`. No widget-level changes were needed — every widget reading `AppThemeScope.of(context)` is fixed by this one change.
    - Explicit `cardStyle`/`fieldStyle` overrides are untouched by this fix, since those are absolute choices, not light/dark-relative ones.
- **Testing**: added `app_theme_scope_test.dart` (a true regression test — simulates a real `MaterialApp` with `theme`/`darkTheme`/`themeMode`, confirms `AppThemeScope.of` returns dark-mode colors when dark mode is active, and confirms the resulting background/foreground colors are actually distinct) and extended `app_theme_config_test.dart` with `resolvedFor` coverage.

## 0.6.0

- **New widget**: `AppExitGuard` — wraps a root screen with either a confirm-dialog or "tap back again to exit" back-press behavior, via `PopScope`.
- **`AppCommonBar`**: now supports an `overflowMenuItems` parameter — a 3-dot menu (`AppOverflowMenuItem`, with an optional destructive/error-colored style) rendered as the last action.
- **New**: `AppPreferencesService` (+ `AppPreferencesServiceImpl`, backed by `shared_preferences`) — non-sensitive settings storage (theme mode, font scale, notification toggles), kept separate from `SecureStorageService` since secrets and simple settings shouldn't share a storage mechanism.
- **Theming**: `AppThemeConfig` gains `cardStyle` (`AppCardStyle`) and `fieldStyle` (`AppFieldStyle`) — component-level overrides (elevation, border radius, background/fill color, padding) independent of the shared `borderRadius`/`surface`. `AppCard` and all form fields (`AppTextField`, `AppDropdownField`, `AppDateField`, `AppSearchField`) now consume these via new `resolvedCardBorderRadius`/`resolvedCardBackgroundColor`/`resolvedFieldBorderRadius` getters.
- **New**: `AppBreakpoints`, `AppResponsive` (`isMobile`/`isTablet`/`isDesktop`, a per-breakpoint `value<T>` picker), and `AppResponsiveBuilder` — screen-width-based responsive helpers.
- **Fix**: `pubspec.yaml` had an accidental duplicate `intl` dependency entry from an earlier round — removed. If you pulled a previous round's `pubspec.yaml`, check your local copy for this duplicate too.
- **Testing**: added coverage for both `AppExitGuard` behaviors, `AppCommonBar`, `AppPreferencesServiceImpl`, the new resolved card/field style getters, `AppCard`'s style overrides, and `AppResponsive`/`AppResponsiveBuilder` at multiple simulated widths. Note: `SystemNavigator.pop()` is a real platform call inside `AppExitGuard`'s exit path — verify that test file locally, since it wasn't possible to run against a real Flutter SDK in this environment.

## 0.5.0

- **Buttons**: `AppButton` gains a `gradient` variant (custom or default primary→secondary gradient, built via a hand-rolled `Material`+`InkWell` since `ElevatedButton` has no native gradient support) plus `backgroundColor`/`foregroundColor` overrides for one-off custom-color buttons that don't fit the theme's two brand colors.
- **New widget**: `AppLoadingSpinner` — a themed circular spinner with a visible background track ring (default/`.small`/`.large` size presets), now also used internally by `AppButton`'s loading state instead of a bare `CircularProgressIndicator`.
- **New widget**: `AppDropdownTrigger` — a compact "Sort by ▾" / "Status ▾" style trigger button with an arrow that animates open/closed automatically around the `Future` returned by its `onTap`, no external open/close state needed.
- **Testing**: added coverage for the gradient variant, custom color overrides, `AppLoadingSpinner`'s size presets, and `AppDropdownTrigger`'s tap handling and arrow animation.

## 0.4.0

- **Utils**: `AppFormatters` (date, friendly/relative date, currency, number, compact number — via `intl`), `Debouncer`, `AppStringX`/`AppContextX` extensions, and `PaginationController` (infinite-scroll state machine, testable without a real attached `Scrollable`).
- **Widgets**: `AppSnackbar` (success/error/warning/neutral toasts), `AppSearchField` (debounced, with a clear button), `AppBottomNavBar`, `AppPaginatedListView` (pull-to-refresh + infinite scroll + shimmer first-load state + empty state, built on `PaginationController`).
- **Testing**: added coverage for `Debouncer`, the string/context extensions, `PaginationController`'s full state machine, `AppFormatters`, and widget tests for `AppSnackbar`, `AppSearchField`, `AppBottomNavBar`, and `AppPaginatedListView`.

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