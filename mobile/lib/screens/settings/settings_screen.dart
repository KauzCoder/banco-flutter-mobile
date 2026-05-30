import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final settings = controller.settings;

        return ProfileScaffold(
          title: 'Configurações',
          trailing: ProfileRoundButton(
            icon: Icons.logout_rounded,
            color: Colors.transparent,
            iconColor: profileRed,
            borderColor: profileRed.withValues(alpha: 0.5),
            onTap: () {},
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'Segurança',
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
                title: 'Política de Privacidade',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.privacyPolicy),
              ),
              const SizedBox(height: 24),
              const Text(
                'Escolha quais dados você compartilha conosco',
                style: TextStyle(
                  color: Color(0xFF858895),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 38),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Biometria',
                      style: TextStyle(
                        color: profileText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Switch(
                    value: settings?.biometriaAtiva ?? false,
                    activeThumbColor: profileText,
                    activeTrackColor: profileBlue,
                    inactiveThumbColor: profileText,
                    inactiveTrackColor: const Color(0xFF9CA3AF),
                    onChanged: controller.isSubmitting
                        ? null
                        : (value) => controller.updateBiometrics(value),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
