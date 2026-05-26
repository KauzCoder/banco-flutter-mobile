import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/widgets/feedback/feature_placeholder_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Perfil',
      icon: Icons.person_outline,
      message: 'Tela reservada para dados pessoais e configurações.',
    );
  }
}
