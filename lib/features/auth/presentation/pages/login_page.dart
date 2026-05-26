import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/shared/widgets/feature_placeholder_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Entrar',
      icon: Icons.lock_outline,
      message: 'Tela reservada para login e cadastro do cliente.',
    );
  }
}
