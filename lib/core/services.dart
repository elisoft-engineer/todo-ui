import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/auth/services.dart';
import 'package:todo/main.dart';

class APIService {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;

  static Future<dynamic> get(String path, {bool auth = false}) async {
    try {
      final Uri url = Uri.parse('$baseUrl$path');
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (auth) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("access_token");
        if (token != null) {
          headers["Authorization"] = 'Bearer $token';
        }
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool success = await TokenService.refresh();
        if (success) {
          return await get(path, auth: true);
        } else {
          navigatorKey.currentState?.pushReplacementNamed('signin');
          return null;
        }
      } else {
        return {'error': jsonDecode(response.body)['detail']};
      }
    } catch (e) {
      return {'app_error': "An error occured"};
    }
  }

  static Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    try {
      final Uri url = Uri.parse('$baseUrl$path');
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (auth) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("access_token");
        if (token != null) {
          headers["Authorization"] = 'Bearer $token';
        }
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool success = await TokenService.refresh();
        if (success) {
          return await post(path, body, auth: true);
        } else {
          navigatorKey.currentState?.pushReplacementNamed('signin');
          return null;
        }
      } else {
        return {'error': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'app_error': 'An error occured'};
    }
  }

  static Future<dynamic> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    try {
      final Uri url = Uri.parse('$baseUrl$path');
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (auth) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("access_token");
        if (token != null) {
          headers["Authorization"] = 'Bearer $token';
        }
      }

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool success = await TokenService.refresh();
        if (success) {
          return await put(path, body, auth: true);
        } else {
          navigatorKey.currentState?.pushReplacementNamed('signin');
          return null;
        }
      } else {
        return {'error': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'app_error': 'An error occured'};
    }
  }

  static Future<dynamic> delete(String path, {bool auth = false}) async {
    try {
      final Uri url = Uri.parse('$baseUrl$path');
      Map<String, String> headers = {"Content-Type": "application/json"};
      if (auth) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("access_token");
        if (token != null) {
          headers["Authorization"] = 'Bearer $token';
        }
      }

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool success = await TokenService.refresh();
        if (success) {
          return await delete(path, auth: true);
        } else {
          navigatorKey.currentState?.pushReplacementNamed('signin');
          return null;
        }
      } else {
        return {'error': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'app_error': 'An error occured'};
    }
  }
}
