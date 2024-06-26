import 'package:flutter/material.dart';
import 'package:flutter_create/pages/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class Settings extends ChangeNotifier {
  static final Settings _singleton = Settings._internal();

  factory Settings() {
    return _singleton;
  }

  Settings._internal();

  static late SharedPreferences _prefs;
  static ThemeMode _theme = ThemeMode.system;
  static String themeModeKey = 'themeMode';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    loadTheme();
  }

  static ThemeMode get getTheme => _theme;

  static void setTheme(ThemeMode theme) {
    _theme = theme;
    bool isDark = theme == ThemeMode.dark;
    _prefs.setBool(themeModeKey, isDark);
    AppTheme.isDark = isDark;
    _singleton.notify();
  }

  static Future<void> loadTheme() async {
    final bool isDark = _prefs.getBool(themeModeKey) ?? false;
    _theme = isDark == true ? ThemeMode.dark : ThemeMode.light;
    AppTheme.isDark = isDark;
    setTheme(_theme);
  }

  static void clear() {
    _prefs.clear();
  }

  void notify() {
    notifyListeners();
  }
}
