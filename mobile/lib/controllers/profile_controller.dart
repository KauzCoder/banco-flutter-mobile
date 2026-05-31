import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/models/user_settings.dart';
import 'package:flutter_aplication_bank/services/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileRepository? repository})
    : _repository = repository ?? ProfileRepository();

  final ProfileRepository _repository;

  bool isLoading = false;
  bool isSubmitting = false;
  bool hasLoaded = false;
  String? error;
  UserProfile? profile;
  UserSettings? settings;

  Future<void> loadProfileDataIfNeeded() async {
    if (hasLoaded || isLoading) {
      return;
    }

    await loadProfileData();
  }

  Future<void> loadProfileData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getCurrentUser(),
        _repository.getUserSettings(),
      ]);
      profile = results[0] as UserProfile;
      settings = results[1] as UserSettings;
      hasLoaded = true;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserSettings(UserSettings nextSettings) async {
    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      settings = await _repository.updateUserSettings(nextSettings);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> updateLanguage(String idioma) async {
    final current = settings;
    if (current == null) {
      return;
    }
    await updateUserSettings(current.copyWith(idioma: idioma));
  }

  Future<void> updateBiometrics(bool enabled) async {
    final current = settings;
    if (current == null) {
      return;
    }
    await updateUserSettings(current.copyWith(biometriaAtiva: enabled));
  }

  Future<void> updateNotifications(bool enabled) async {
    final current = settings;
    if (current == null) {
      return;
    }
    await updateUserSettings(current.copyWith(notificacoesAtivas: enabled));
  }

  Future<void> updateDarkTheme(bool enabled) async {
    final current = settings;
    if (current == null) {
      return;
    }
    await updateUserSettings(current.copyWith(temaEscuro: enabled));
  }

  Future<void> updateProfile(UserProfile nextProfile) async {
    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      profile = await _repository.updateProfile(nextProfile);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
