import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScaffold(
      title: 'Privacidade',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PrivacySection(
            title: 'Política de Privacidade',
            body:
                'Esta página é apenas um exemplo para representar como a política de privacidade do QuantumBank pode aparecer no app.',
          ),
          _PrivacySection(
            title: 'Dados coletados',
            body:
                'Podemos usar dados como nome, e-mail, telefone, preferências de idioma e configurações de segurança para melhorar sua experiência.',
          ),
          _PrivacySection(
            title: 'Como usamos seus dados',
            body:
                'As informações são usadas para identificar sua conta, personalizar telas, proteger o acesso e oferecer recursos bancários dentro do aplicativo.',
          ),
          _PrivacySection(
            title: 'Compartilhamento',
            body:
                'Este exemplo considera que seus dados não são vendidos. Compartilhamentos reais devem ser descritos quando a integração com backend estiver finalizada.',
          ),
          _PrivacySection(
            title: 'Controle do usuário',
            body:
                'Você poderá revisar preferências, biometria e dados pessoais nas telas de configurações e perfil.',
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: profileText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: profileMutedText,
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
