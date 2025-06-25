import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandlerGhibli {
  static const String _loginKey = "login";
  static const String _tokenKey = "token";

  static void saveLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginKey, login);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static void deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
