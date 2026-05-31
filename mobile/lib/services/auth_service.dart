import 'dart:convert';
import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/models/user_settings.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;
  static String? _refreshToken;
  static UserProfile? _currentUser;
  static UserSettings? _currentSettings;
  static Map<String, dynamic>? _currentAccount;

  static String? get token => _token;
  static String? get refreshToken => _refreshToken;
  static UserProfile? get currentUser => _currentUser;
  static UserSettings? get currentSettings => _currentSettings;
  static Map<String, dynamic>? get currentAccount => _currentAccount;
  static bool get isAuthenticated => _token != null;

  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http
        .post(
          Uri.parse(ApiConstants.loginUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Erro ao fazer login.');
    }

    _saveSession(body);
    return body;
  }

  static Future<Map<String, dynamic>> register(
    String nome,
    String email,
    String password,
  ) async {
    final response = await http
        .post(
          Uri.parse(ApiConstants.registerUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nome': nome,
            'email': email,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(body['message'] ?? 'Erro ao criar conta.');
    }

    _saveSession(body);
    return body;
  }

  static Future<UserProfile> fetchCurrentUser() async {
    final response = await http
        .get(Uri.parse(ApiConstants.meUrl), headers: authHeaders)
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Erro ao buscar usuario.');
    }

    _currentUser = UserProfile.fromJson(body);
    return _currentUser!;
  }

  static Future<Map<String, dynamic>> fetchAccountSummary() async {
    final response = await http
        .get(Uri.parse(ApiConstants.summaryUrl), headers: authHeaders)
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Erro ao buscar conta.');
    }

    final account = body['account'];
    _currentAccount = account is Map<String, dynamic> ? account : null;
    return body;
  }

  static Future<UserSettings> fetchUserSettings() async {
    final response = await http
        .get(Uri.parse(ApiConstants.userSettingsUrl), headers: authHeaders)
        .timeout(const Duration(seconds: 10));

    final body = _decodeBody(response.body);

    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Erro ao buscar configuracoes.');
    }

    _currentSettings = UserSettings.fromJson(body);
    return _currentSettings!;
  }

  static void logout() {
    _token = null;
    _refreshToken = null;
    _currentUser = null;
    _currentSettings = null;
    _currentAccount = null;
  }

  static void updateCurrentSettings(UserSettings settings) {
    _currentSettings = settings;
  }

  static Map<String, dynamic> _decodeBody(String responseBody) {
    if (responseBody.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(responseBody);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  static void _saveSession(Map<String, dynamic> body) {
    _token = body['token']?.toString() ?? body['idToken']?.toString();
    _refreshToken = body['refreshToken']?.toString();

    final user = body['user'];
    if (user is Map<String, dynamic>) {
      _currentUser = UserProfile.fromJson(user);
    }

    final account = body['account'];
    if (account is Map<String, dynamic>) {
      _currentAccount = account;
    }

    final settings = body['settings'];
    if (settings is Map<String, dynamic>) {
      _currentSettings = UserSettings.fromJson(settings);
    }
  }
}
