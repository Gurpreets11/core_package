/// An abstraction over simple, **non-sensitive** key-value settings
/// storage (theme mode, font scale, a notification toggle) —
/// deliberately separate from [SecureStorageService], which is for
/// secrets (tokens, credentials). Using secure storage for a boolean
/// toggle is slower than necessary and the wrong tool for the job;
/// this is the one to reach for instead.
abstract interface class AppPreferencesService {
  /// Stores a string [value] under [key].
  Future<void> setString({required String key, required String value});

  /// Reads the string stored under [key], or `null` if unset.
  Future<String?> getString({required String key});

  /// Stores a bool [value] under [key].
  Future<void> setBool({required String key, required bool value});

  /// Reads the bool stored under [key], or `null` if unset.
  Future<bool?> getBool({required String key});

  /// Stores a double [value] under [key].
  Future<void> setDouble({required String key, required double value});

  /// Reads the double stored under [key], or `null` if unset.
  Future<double?> getDouble({required String key});

  /// Removes the value stored under [key], if any.
  Future<void> remove({required String key});

  /// Removes every value this service has stored.
  Future<void> clear();
}
