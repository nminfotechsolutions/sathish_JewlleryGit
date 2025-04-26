  import 'package:agni_chit_saving/routes/app_export.dart';

  class SharedPreferencesHelper {
    static SharedPreferences? _prefs;

    static Future<void> init() async {
      _prefs = await SharedPreferences.getInstance();
    }

    static Future<bool> saveString(String key, String value) async {
      return await _prefs!.setString(key, value);
    }

    static String getString(String key) {
      return _prefs!.getString(key) ?? "";
    }

    static Future<bool> saveBool(String key, bool value) async {
      return await _prefs!.setBool(key, value);
    }

    static bool getBool(String key) {
      return _prefs!.getBool(key) ?? false;
    }

    static Future<bool> saveInt(String key, int value) async {
      return await _prefs!.setInt(key, value);
    }

    static int getInt(String key) {
      return _prefs!.getInt(key) ?? 0;
    }

    static Future<bool> saveDouble(String key, double value) async {
      return await _prefs!.setDouble(key, value);
    }

    static double getDouble(String key) {
      return _prefs!.getDouble(key) ?? 0.0;
    }

    static Future<bool> removeKey(String key) async {
      return await _prefs!.remove(key);
    }

  }
