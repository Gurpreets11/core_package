/// A marker interface for repository contracts defined in the `domain`
/// layer and implemented in the `data` layer.
///
/// This doesn't prescribe any methods — every app's repositories differ
/// (an `AuthRepository`, a `LeadsRepository`, a `CatalogRepository`, ...).
/// Its purpose is purely to document the architectural convention:
///
/// ```dart
/// // domain/repositories/auth_repository.dart
/// abstract class AuthRepository implements Repository {
///   Future<Result<AuthUser>> login(String email, String password);
///   Future<Result<void>> logout();
/// }
///
/// // data/repositories/auth_repository_impl.dart
/// class AuthRepositoryImpl implements AuthRepository {
///   AuthRepositoryImpl(this._remoteDataSource);
///   final AuthRemoteDataSource _remoteDataSource;
///   // ...
/// }
/// ```
abstract interface class Repository {}
