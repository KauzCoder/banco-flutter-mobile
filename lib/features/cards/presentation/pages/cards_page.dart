import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/shared/widgets/feature_placeholder_page.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Cartões',
      icon: Icons.credit_card,
      message: 'Tela reservada para cartões, fatura e limites.',
    );
  }
}
