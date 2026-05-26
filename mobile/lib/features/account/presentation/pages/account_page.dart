import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/shared/widgets/feature_placeholder_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Conta',
      icon: Icons.account_balance_wallet_outlined,
      message: 'Tela reservada para saldo, agência e número da conta.',
    );
  }
}
