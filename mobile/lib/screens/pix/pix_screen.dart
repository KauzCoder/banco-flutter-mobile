import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/widgets/feedback/feature_placeholder_page.dart';

class PixScreen extends StatelessWidget {
  const PixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Pix',
      icon: Icons.pix,
      message: 'Tela reservada para chaves, pagamentos e transferências Pix.',
    );
  }
}
