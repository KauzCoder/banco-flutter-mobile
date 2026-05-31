import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<ProfileController>().loadProfileDataIfNeeded();
    });
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.signIn,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final settings = controller.settings;

        return ProfileScaffold(
          title: 'Configuracoes',
          trailing: ProfileRoundButton(
            icon: Icons.logout_rounded,
            color: Colors.transparent,
            iconColor: profileRed,
            borderColor: profileRed.withValues(alpha: 0.5),
            onTap: _logout,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isLoading && settings == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: CircularProgressIndicator(color: profileBlue),
                  ),
                )
              else ...[
                if (controller.error != null) ...[
                  _SettingsMessage(
                    message: 'Nao foi possivel carregar as configuracoes.',
                    onRetry: controller.loadProfileData,
                  ),
                  const SizedBox(height: 24),
                ],
                const Text(
                  'Geral',
                  style: TextStyle(
                    color: profileMutedText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ProfileMenuRow(
                  title: 'Idioma',
                  value: languageLabel(settings?.idioma ?? 'pt-BR'),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.language),
                ),
                ProfileMenuRow(
                  title: 'Meu Perfil',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
                ProfileMenuRow(title: 'Fale Conosco', onTap: () {}),
                const SizedBox(height: 56),
                const Text(
                  'Seguranca',
                  style: TextStyle(
                    color: profileMutedText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ProfileMenuRow(
                  title: 'Alterar Senha',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.changePassword),
                ),
                ProfileMenuRow(
                  title: 'Politica de Privacidade',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Escolha quais dados voce compartilha conosco',
                  style: TextStyle(
                    color: Color(0xFF858895),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 28),
                _SettingsSwitchRow(
                  title: 'Biometria',
                  value: settings?.biometriaAtiva ?? false,
                  enabled: settings != null && !controller.isSubmitting,
                  onChanged: controller.updateBiometrics,
                ),
                _SettingsSwitchRow(
                  title: 'Notificacoes',
                  value: settings?.notificacoesAtivas ?? true,
                  enabled: settings != null && !controller.isSubmitting,
                  onChanged: controller.updateNotifications,
                ),
                _SettingsSwitchRow(
                  title: 'Tema escuro',
                  value: settings?.temaEscuro ?? false,
                  enabled: settings != null && !controller.isSubmitting,
                  onChanged: controller.updateDarkTheme,
                ),
                if (controller.isSubmitting) ...[
                  const SizedBox(height: 20),
                  const LinearProgressIndicator(
                    color: profileBlue,
                    backgroundColor: profileDivider,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: profileDivider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: profileText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: profileText,
            activeTrackColor: profileBlue,
            inactiveThumbColor: profileText,
            inactiveTrackColor: const Color(0xFF9CA3AF),
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}

class _SettingsMessage extends StatelessWidget {
  const _SettingsMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7F1D1D)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: profileText, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Tentar novamente',
              style: TextStyle(color: profileText),
            ),
          ),
        ],
      ),
    );
  }
}
