# Changelog

## 0.1.0 (unreleased)

Phase 1 scaffold, hardened before first publish:

- **Networking**: `ApiClient` with typed generic methods (`get<T>`, `post<T>`, `put<T>`, `patch<T>`, `delete<T>`, `raw`) taking a required `fromJson` mapper, so every app parses responses the same way. `AuthInterceptor`, `LoggingInterceptor`, and a new configurable `RetryInterceptor` (exponential backoff, transient-failure detection).
- **Result**: extracted into its own file with full chaining support — `map`, `flatMap`, `getOrElse`, `valueOrNull`, `failureOrNull` — in addition to `when`.
- **Exceptions/Failures**: `AppException` hierarchy, `Failure` hierarchy, `ExceptionMapper`.
- **Logging**: `AppLogger` (silent in release builds).
- **Validation**: `Validators` (required, email, phone, min/max length, password, matches, compose).
- **Theming**: `AppThemeConfig` now supports light **and dark mode** from a single config (`toThemeData(brightness: ...)`), a wired-up `textTheme`, and a new `AppSpacing` scale (`xs`/`sm`/`md`/`lg`/`xl`) derived from `spacingUnit`. `AppThemeScope` exposes it via `InheritedWidget`.
- **Base architecture**: `UseCase<Type, Params>`, `Repository` marker interface.
- **Testing**: added coverage for `Result` chaining, `ApiClient` (via mocked Dio adapter — success, 401 mapping, network-error mapping), `AuthInterceptor`, and `AppThemeConfig` (light/dark derivation, spacing scale).
- **CI**: GitHub Actions running `flutter analyze`, `flutter test`, format checks, and a `dart_apitool`-based check that flags undeclared breaking API changes on PRs.
