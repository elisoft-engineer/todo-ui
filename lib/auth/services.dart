import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/services.dart';

class TokenService {
  static Future<bool> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) {
      return false;
    }

    final response = await APIService.post("token/refresh/", {
      "refresh": refreshToken,
    });
    if (response != null && response.containsKey('access')) {
      await prefs.setString('access_token', response['access']);
      return true;
    } else {
      signout();
      return false;
    }
  }

  static Future<void> signout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.clear();
  }
}
