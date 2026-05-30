import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/models/user_settings.dart';

class ProfileRepository {
  UserProfile _profile = UserProfile(
    id: 'mock-user-1',
    nome: 'Kauã M. Fragoso',
    email: 'kauamendes714@gmail.com',
    telefone: '+8801712663389',
    fotoPerfil: '',
    cpf: null,
    dataCriacao: DateTime(2021, 1, 28),
    dataNascimentoDia: '28',
    dataNascimentoMes: 'Setembro',
    dataNascimentoAno: '2000',
  );

  UserSettings _settings = const UserSettings(
    id: 'mock-settings-1',
    userId: 'mock-user-1',
    biometriaAtiva: false,
    idioma: 'pt-BR',
    notificacoesAtivas: true,
    temaEscuro: true,
  );

  Future<UserProfile> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _profile;
  }

  Future<UserSettings> getUserSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _settings;
  }

  Future<UserSettings> updateUserSettings(UserSettings settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _settings = settings;
    return _settings;
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _profile = profile;
    return _profile;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
