import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/shared/widgets/feature_placeholder_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Perfil',
      icon: Icons.person_outline,
      message: 'Tela reservada para dados pessoais e configurações.',
    );
  }
}
