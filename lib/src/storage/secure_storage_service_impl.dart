import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions/app_exception.dart';
import 'secure_storage_service.dart';

/// The real [SecureStorageService] implementation, backed by
/// `flutter_secure_storage` (Keychain on iOS, EncryptedSharedPreferences
/// on Android).
///
/// ```dart
/// final storage = SecureStorageServiceImpl();
/// await storage.write(key: 'auth_token', value: token);
/// ```
class SecureStorageServiceImpl implements SecureStorageService {
  /// Creates a [SecureStorageServiceImpl].
  ///
  /// Pass a custom [storage] instance in tests that need to fake the
  /// underlying plugin; defaults to a real [FlutterSecureStorage].
  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (error) {
      throw CacheException('Failed to write "$key": $error');
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      throw CacheException('Failed to read "$key": $error');
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (error) {
      throw CacheException('Failed to delete "$key": $error');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (error) {
      throw CacheException('Failed to clear storage: $error');
    }
  }
}
