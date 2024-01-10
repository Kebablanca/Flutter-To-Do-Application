import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_app/session_manager.dart';

class ApiService {
  static const String baseUrl = "https://10.0.2.2:7163/api"; 

  static Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/User/ChangePassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'UserId': SessionManager.loggedInUser?.userId ?? "",
          'CurrentPassword': currentPassword,
          'NewPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // ignore: avoid_print
        print("Şifre değiştirilirken bir hata oluştu. ${response.body}");
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Hata: $e");
      return false;
    }
  }

  static Future<bool> changeUsername(String newUsername) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/User/ChangeUsername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'UserId': SessionManager.loggedInUser?.userId ?? "",
          'NewUsername': newUsername,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // ignore: avoid_print
        print("Kullanıcı adı değiştirilirken bir hata oluştu. ${response.body}");
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Hata: $e");
      return false;
    }
  }
}
