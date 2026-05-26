import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/widgets/feedback/feature_placeholder_page.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Cartões',
      icon: Icons.credit_card,
      message: 'Tela reservada para cartões, fatura e limites.',
    );
  }
}
