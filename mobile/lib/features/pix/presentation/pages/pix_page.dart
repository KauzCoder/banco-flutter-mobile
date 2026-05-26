import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/shared/widgets/feature_placeholder_page.dart';

class PixPage extends StatelessWidget {
  const PixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Pix',
      icon: Icons.pix,
      message: 'Tela reservada para chaves, pagamentos e transferências Pix.',
    );
  }
}
