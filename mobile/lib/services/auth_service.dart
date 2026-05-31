import 'dart:convert';
import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/models/user_settings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LastLoginUser {
  const LastLoginUser({
    required this.nome,
    required this.email,
    this.cpf,
    this.fotoPerfil,
  });

  final String nome;
  final String email;
  final String? cpf;
  final String? fotoPerfil;

  String get displayName => nome.trim().isEmpty ? email : nome.trim();

  String get maskedDocument {
    final digits = (cpf ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 11) {
      return '***.${digits.substring(3, 6)}.${digits.substring(6, 9)}-**';
    }

    final parts = email.split('@');
    if (parts.length != 2 || parts.first.length < 3) {
      return email;
    }

    return '${parts.first.substring(0, 3)}***@${parts.last}';
  }
}

class AuthService {
  static const _lastLoginNameKey = 'last_login_name';
  static const _lastLoginEmailKey = 'last_login_email';
  static const _lastLoginCpfKey = 'last_login_cpf';
  static const _lastLoginPhotoKey = 'last_login_photo';

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

    await _saveSession(body);
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

    await _saveSession(body);
    return body;
  }

  static Future<LastLoginUser?> getLastLoginUser() async {
    final preferences = await SharedPreferences.getInstance();
    final email = preferences.getString(_lastLoginEmailKey);

    if (email == null || email.trim().isEmpty) {
      return null;
    }

    return LastLoginUser(
      nome: preferences.getString(_lastLoginNameKey) ?? '',
      email: email,
      cpf: preferences.getString(_lastLoginCpfKey),
      fotoPerfil: preferences.getString(_lastLoginPhotoKey),
    );
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

  static Future<void> _saveSession(Map<String, dynamic> body) async {
    _token = body['token']?.toString() ?? body['idToken']?.toString();
    _refreshToken = body['refreshToken']?.toString();

    final user = body['user'];
    if (user is Map<String, dynamic>) {
      _currentUser = UserProfile.fromJson(user);
      await _saveLastLoginUser(_currentUser!);
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

  static Future<void> _saveLastLoginUser(UserProfile user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_lastLoginNameKey, user.nome);
    await preferences.setString(_lastLoginEmailKey, user.email);
    await preferences.setString(_lastLoginCpfKey, user.cpf ?? '');
    await preferences.setString(_lastLoginPhotoKey, user.fotoPerfil);
  }
}
