import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  String apiUrl; 

  AuthService(this.apiUrl);

  Future<bool> postMethod(String email, String password) async {
    final response = await http.post(
      Uri.parse(
          '$apiUrl/Auth/Authenticate'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body) as bool;
    } else {

      throw Exception('Failed to authenticate user');
    }
  }

  Future<int> getUserId(String email) async {
    final response = await http.post(
      Uri.parse('$apiUrl/Auth/GetUserId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body) as int;
    } else {

      throw Exception('Failed');
    }
  }

  Future<String> getName(String email) async {
    final response = await http.post(
      Uri.parse('$apiUrl/Auth/GetName'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {

      return(response.body);
    } else {
      throw Exception('Failed');
    }
  }
}
