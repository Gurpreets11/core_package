/// An abstraction over secure key-value storage (tokens, cached user
/// info, "remember me" flags), so the `data` layer depends on this
/// interface rather than directly on `flutter_secure_storage`.
///
/// This is what makes `AuthLocalDataSource` (and anything else that
/// needs persisted secrets) unit-testable without a platform channel —
/// tests provide a fake [SecureStorageService] instead of talking to
/// the real secure storage plugin.
abstract interface class SecureStorageService {
  /// Writes [value] under [key], overwriting any existing value.
  Future<void> write({required String key, required String value});

  /// Reads the value stored under [key], or `null` if nothing is
  /// stored there.
  Future<String?> read({required String key});

  /// Deletes the value stored under [key], if any.
  Future<void> delete({required String key});

  /// Deletes every value this service has stored.
  Future<void> deleteAll();
}
