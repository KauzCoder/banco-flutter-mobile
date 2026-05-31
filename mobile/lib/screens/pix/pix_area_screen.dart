import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';

class PixAreaScreen extends StatelessWidget {
  const PixAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildGrid(context),
              const SizedBox(height: 32),
              _buildSecurityBanner(),
              const SizedBox(height: 32),
              _buildAtalhos(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF6B3FE4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'Área Pix',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 42),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final items = [
      {
        'icon': Icons.qr_code_2_rounded,
        'label': 'Meu QR Code',
        'route': AppRoutes.myQrCode,
      },
      {
        'icon': Icons.qr_code_scanner_rounded,
        'label': 'Escanear QR Code',
        'route': AppRoutes.scanQr,
      },
      {
        'icon': Icons.pix,
        'label': 'Transferência PIX',
        'route': AppRoutes.transfer,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, item['route'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1040),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2A2A45), width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: const Color(0xFFCBFF4D),
                  size: 36,
                ),
                const SizedBox(height: 10),
                Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityBanner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1040),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.security_rounded,
            color: Color(0xFFCBFF4D),
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A segurança é fundamental durante suas transações.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Você pode ter certeza de que seus dados estão protegidos em tempo real, garantindo transações seguras e confiáveis.',
                style: TextStyle(
                  color: Color(0xFF8A8AA8),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAtalhos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atalhos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1040),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A2A45), width: 0.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showPixKeysModal(context),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B3FE4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.key_rounded,
                        color: Color(0xFFCBFF4D),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minha chaves Pix',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Gerencie suas chaves e preferencias',
                          style: TextStyle(
                            color: Color(0xFF8A8AA8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF6B6B8A),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPixKeysModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1040),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas Chaves PIX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _pixKeyTile('Email', 'linghabei@gmail.com'),
            _pixKeyTile('Telefone', '(91) 98765-4321'),
            _pixKeyTile('CPF', '123.456.789-00'),
            _pixKeyTile('Aleatória', 'a1b2c3d4-e5f6-7g8h-9i0j'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _pixKeyTile(String type, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A45), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(color: Color(0xFF8A8AA8), fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF22C55E),
            size: 20,
          ),
        ],
      ),
    );
  }
}
