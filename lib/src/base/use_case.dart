import 'result.dart';

/// A marker type for use cases that take no parameters.
final class NoParams {
  const NoParams._();

  /// The singleton [NoParams] instance.
  static const instance = NoParams._();
}

/// Base class for a single, focused unit of business logic.
///
/// Every use case takes exactly one [Params] object (use [NoParams] if
/// none are needed) and returns a [Result], keeping success/failure
/// handling uniform across the whole app.
///
/// ```dart
/// class LoginUseCase extends UseCase<AuthUser, LoginParams> {
///   LoginUseCase(this._repository);
///   final AuthRepository _repository;
///
///   @override
///   Future<Result<AuthUser>> call(LoginParams params) {
///     return _repository.login(params.email, params.password);
///   }
/// }
/// ```
abstract class UseCase<T, Params> {
  /// Executes the use case with the given [params].
  Future<Result<Type>> call(Params params);
}
