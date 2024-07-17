import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? cache;

  static Future<void> initalCache() async {
    cache = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(String key, dynamic value) async {
    if (value is String) {
      return await cache!.setString(key, value);
    } else if (value is int) {
      return await cache!.setInt(key, value);
    } else if (value is double) {
      return await cache!.setDouble(key, value);
    } else {
      return await cache!.setBool(key, value);
    }
  }

  static dynamic getData(String key) {
    return cache!.get(key);
  }

  static Future<bool> removeData(String key) async {
    return await cache!.remove(key);
  }
}
