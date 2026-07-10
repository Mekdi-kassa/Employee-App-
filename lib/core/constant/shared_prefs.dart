import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyDarkMode = 'is_dark_mode';

  static Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(_keyIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<bool> setDarkMode(bool value) async {
    return await _prefs.setBool(_keyDarkMode, value);
  }

  static bool? getDarkMode() {
    return _prefs.getBool(_keyDarkMode);
  }

  static Future<void> clearAuthData() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
  }
}