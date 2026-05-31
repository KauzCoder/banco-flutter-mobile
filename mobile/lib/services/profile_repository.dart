import 'dart:convert';

import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/models/user_settings.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  Future<UserProfile> getCurrentUser() async {
    final cachedUser = AuthService.currentUser;
    if (cachedUser != null) {
      return cachedUser;
    }

    return AuthService.fetchCurrentUser();
  }

  Future<UserSettings> getUserSettings() async {
    final cachedSettings = AuthService.currentSettings;
    if (cachedSettings != null) {
      return cachedSettings;
    }

    return AuthService.fetchUserSettings();
  }

  Future<Map<String, dynamic>?> getAccount() async {
    final cachedAccount = AuthService.currentAccount;
    if (cachedAccount != null) {
      return cachedAccount;
    }

    final summary = await AuthService.fetchAccountSummary();
    final account = summary['account'];
    return account is Map<String, dynamic> ? account : null;
  }

  Future<UserSettings> updateUserSettings(UserSettings settings) async {
    final response = await http
        .patch(
          Uri.parse(ApiConstants.userSettingsUrl),
          headers: AuthService.authHeaders,
          body: jsonEncode({
            'biometriaAtiva': settings.biometriaAtiva,
            'idioma': settings.idioma,
            'notificacoesAtivas': settings.notificacoesAtivas,
            'temaEscuro': settings.temaEscuro,
          }),
        )
        .timeout(const Duration(seconds: 10));

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

    if (response.statusCode != 200 || body is! Map<String, dynamic>) {
      final message = body is Map<String, dynamic>
          ? body['message']?.toString()
          : null;
      throw Exception(message ?? 'Erro ao atualizar configuracoes.');
    }

    final updatedSettings = UserSettings.fromJson(body);
    AuthService.updateCurrentSettings(updatedSettings);
    return updatedSettings;
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    throw UnimplementedError('Atualizacao de perfil ainda nao existe na API.');
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    throw UnimplementedError('Troca de senha ainda nao existe na API.');
  }
}
