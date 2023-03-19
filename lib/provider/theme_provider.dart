import 'package:flutter/material.dart';
// import 'package:juconfession/utils/save.localdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  ThemeProvider() {
    _loadThemeMode();
  }

  _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var themeMode = prefs.getString('themeMode');
    if (themeMode != null) {
      if (themeMode == 'ThemeMode.system') {
        _themeMode = ThemeMode.system;
      } else if (themeMode == 'ThemeMode.light') {
        _themeMode = ThemeMode.light;
      } else if (themeMode == 'ThemeMode.dark') {
        _themeMode = ThemeMode.dark;
      }
    }
    notifyListeners();
  }

  void saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themeMode == ThemeMode.system) {
      prefs.setString('themeMode', 'ThemeMode.system');
    } else if (themeMode == ThemeMode.light) {
      prefs.setString('themeMode', 'ThemeMode.light');
    } else if (themeMode == ThemeMode.dark) {
      prefs.setString('themeMode', 'ThemeMode.dark');
    }
  }

  // var _themeMode = ThemeMode.light;

  // ThemeMode get themeMode => _themeMode;

  // void setThemeMode(ThemeMode themeMode) {
  //   _themeMode = themeMode;
  //   notifyListeners();
  // }
}
