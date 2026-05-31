import 'dart:convert';
import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;

  static String? get token => _token;

  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Erro ao fazer login.');
    }

    _token = body['token'] ?? body['idToken'];
    return body;
  }

  static Future<Map<String, dynamic>> register(String nome, String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Erro ao criar conta.');
    }

    _token = body['token'] ?? body['idToken'];
    return body;
  }

  static void logout() {
    _token = null;
  }
}