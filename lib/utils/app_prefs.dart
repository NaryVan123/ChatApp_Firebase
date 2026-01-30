import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const isLoggedInKey = 'isLoggedIn';
  static const phoneNumberKey = 'phoneNumber';
  static const userNameKey = 'username';

  // Save login data
  static Future<void> savedData({
    required String phoneNumber,
    required String username,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, true);
    await prefs.setString(phoneNumberKey, phoneNumber);
    await prefs.setString(userNameKey, username);
  }

  // Check login status // Khi mở app lần đầu: Kiểm tra user đã login chưa
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  // Get phoneNumber
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(phoneNumberKey);
  }

  // Get username
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  // Logout
  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
