import 'dart:convert';

import 'package:assistant_client/core/errors.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  final String loginUrl;

  AuthService(this.baseUrl) : loginUrl = '$baseUrl/api/auth/login';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({'email': email, 'password': password}).toString(),
    );

    if (response.statusCode == 401) {
      throw AuthError(message: "Invalid credentials");
    } else if (response.statusCode != 200) {
      throw AuthError(
        message: "Failed to login",
        extra: {
          'status_code': response.statusCode,
          'body': response.body,
        }.toString(),
      );
    }

    var payload = jsonDecode(response.body) as Map<String, dynamic>;
    return payload['token'];
  }
}
