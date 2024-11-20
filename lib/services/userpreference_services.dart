import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  static Future<void> setRecentSearch(List<String> value) async {
    await _prefs?.setStringList('recentSearch', value);
  }

  static List<String> getRecentSearch() {
    if (_prefs?.containsKey('recentSearch') ?? false) {
      return _prefs!.getStringList('recentSearch')!;
    } else {
      return [];
    }
  }

  static Future<void> setValue(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? get(String key) {
    if (_prefs?.containsKey(key) ?? false) {
      return _prefs?.getString(key);
    } else {
      return null;
    }
  }

  static Future<void> setSetting(String key, bool val) async {
    await _prefs?.setBool(key, val);
  }

  static bool getSetting(String key) {
    if (!(_prefs?.containsKey(key) ?? false)) {
      setSetting(key, false);
    }
    return _prefs?.getBool(key) ?? false;
  }
}
