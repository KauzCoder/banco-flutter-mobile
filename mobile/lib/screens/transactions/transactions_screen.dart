import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/widgets/feedback/feature_placeholder_page.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Transações',
      icon: Icons.swap_horiz,
      message: 'Tela reservada para histórico de movimentações.',
    );
  }
}
