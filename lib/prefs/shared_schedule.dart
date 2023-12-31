import 'package:shared_preferences/shared_preferences.dart';

class SharedSchedule {
  static Future<void> saveSchedule(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Mengambil nilai String dari SharedPreferences
  static Future<bool> getSchedule(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
