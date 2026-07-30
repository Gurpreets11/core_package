import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences_service.dart';

/// The real [AppPreferencesService] implementation, backed by
/// `shared_preferences`.
///
/// Lazily obtains the singleton [SharedPreferences] instance on first
/// use, so this class can be constructed synchronously and handed to a
/// dependency graph (e.g. a Riverpod provider) without an `async`
/// provider.
///
/// ```dart
/// final prefs = AppPreferencesServiceImpl();
/// await prefs.setBool(key: 'dark_mode_enabled', value: true);
/// ```
class AppPreferencesServiceImpl implements AppPreferencesService {
  Future<SharedPreferences>? _instanceFuture;

  Future<SharedPreferences> get _instance =>
      _instanceFuture ??= SharedPreferences.getInstance();

  @override
  Future<void> setString({required String key, required String value}) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getString({required String key}) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  @override
  Future<void> setBool({required String key, required bool value}) async {
    final prefs = await _instance;
    await prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool({required String key}) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }

  @override
  Future<void> setDouble({required String key, required double value}) async {
    final prefs = await _instance;
    await prefs.setDouble(key, value);
  }

  @override
  Future<double?> getDouble({required String key}) async {
    final prefs = await _instance;
    return prefs.getDouble(key);
  }

  @override
  Future<void> remove({required String key}) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}
