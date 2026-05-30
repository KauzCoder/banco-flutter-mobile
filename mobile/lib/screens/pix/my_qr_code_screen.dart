import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';

class MyQRCodeScreen extends StatefulWidget {
  const MyQRCodeScreen({super.key});

  @override
  State<MyQRCodeScreen> createState() => _MyQRCodeScreenState();
}

class _MyQRCodeScreenState extends State<MyQRCodeScreen> {
  String _selected = 'meucodigo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    const Text(
                      'Kauã Mendes Fragoso',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: const TextSpan(
                        text: 'O código expira em ',
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '10:00',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(60),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          ),
                          child: const Center(
                            child: Icon(Icons.qr_code_2, size: 180, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '231234445665677',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildBottomButtons(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const Text(
            'Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Imagem do QR Code salva!')),
                );
              },
              child: const Icon(
                Icons.image_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final isLer = _selected == 'ler';
    final isMeu = _selected == 'meucodigo';

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      ),
      child: Row(
        children: [
          
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => _selected = 'ler');
                Navigator.pushNamed(context, AppRoutes.scanQr);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  color: isLer ? const Color(0xFFDDFA46) : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Ler',
                  style: TextStyle(
                    color: isLer ? const Color(0xFF552F9F) : Colors.white, // 👈 cor da letra
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => _selected = 'meucodigo');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  color: isMeu ? const Color(0xFFDDFA46) : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Meu Codigo',
                  style: TextStyle(
                    color: isMeu ? const Color(0xFF552F9F) : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}