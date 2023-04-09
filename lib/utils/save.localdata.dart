import 'package:shared_preferences/shared_preferences.dart';

class SaveLocalData {
  static Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  //Boolean
  static Future<void> saveDataBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    prefs.setBool(key, value);
  }

  static Future<bool> getDataBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    return prefs.getBool(key) ?? false;
  }

  //Clear
  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }

  //reload
  static Future<void> reload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
  }
}
