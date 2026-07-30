import 'package:core_package/core_package.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // shared_preferences ships a built-in in-memory mock for tests —
    // no platform-channel mocking needed, unlike SecureStorageService
    // or ConnectivityService.
    SharedPreferences.setMockInitialValues({});
  });

  late AppPreferencesServiceImpl service;

  setUp(() {
    service = AppPreferencesServiceImpl();
  });

  group('AppPreferencesServiceImpl — string', () {
    test('getString returns null before anything is set', () async {
      expect(await service.getString(key: 'name'), isNull);
    });

    test('setString/getString round-trip', () async {
      await service.setString(key: 'name', value: 'Jane');
      expect(await service.getString(key: 'name'), 'Jane');
    });
  });

  group('AppPreferencesServiceImpl — bool', () {
    test('setBool/getBool round-trip', () async {
      await service.setBool(key: 'dark_mode_enabled', value: true);
      expect(await service.getBool(key: 'dark_mode_enabled'), isTrue);
    });
  });

  group('AppPreferencesServiceImpl — double', () {
    test('setDouble/getDouble round-trip', () async {
      await service.setDouble(key: 'font_scale', value: 1.2);
      expect(await service.getDouble(key: 'font_scale'), 1.2);
    });
  });

  group('AppPreferencesServiceImpl — remove/clear', () {
    test('remove deletes only the given key', () async {
      await service.setString(key: 'a', value: '1');
      await service.setString(key: 'b', value: '2');

      await service.remove(key: 'a');

      expect(await service.getString(key: 'a'), isNull);
      expect(await service.getString(key: 'b'), '2');
    });

    test('clear deletes every stored value', () async {
      await service.setString(key: 'a', value: '1');
      await service.setBool(key: 'b', value: true);

      await service.clear();

      expect(await service.getString(key: 'a'), isNull);
      expect(await service.getBool(key: 'b'), isNull);
    });
  });
}
