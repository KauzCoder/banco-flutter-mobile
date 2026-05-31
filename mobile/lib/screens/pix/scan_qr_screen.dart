import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  String _selected = 'ler'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: AppColors.darkText),
        ),
        title: const Text(
          'Scanner',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() => _isFlashlightOn = !_isFlashlightOn);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: AppConstants.paddingMedium),
              child: Icon(
                _isFlashlightOn ? Icons.flashlight_on : Icons.flashlight_off,
                color: _isFlashlightOn ? AppColors.secondary : AppColors.darkText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanFrame() {
    final size = 220.0;
    final cornerSize = 32.0;
    final cornerWidth = 3.5;
    final color = Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0,
            child: _buildCorner(color, cornerSize, cornerWidth, top: true, left: true),
          ),
          Positioned(
            top: 0, right: 0,
            child: _buildCorner(color, cornerSize, cornerWidth, top: true, left: false),
          ),
          Positioned(
            bottom: 0, left: 0,
            child: _buildCorner(color, cornerSize, cornerWidth, top: false, left: true),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: _buildCorner(color, cornerSize, cornerWidth, top: false, left: false),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Color color, double size, double width, {required bool top, required bool left}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: width) : BorderSide.none,
          bottom: !top ? BorderSide(color: color, width: width) : BorderSide.none,
          left: left ? BorderSide(color: color, width: width) : BorderSide.none,
          right: !left ? BorderSide(color: color, width: width) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(10) : Radius.zero,
          topRight: top && !left ? const Radius.circular(10) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(10) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(10) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final isLer = _selected == 'ler';
    final isMeu = _selected == 'meucodigo';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.darkBorder, width: 1),
        ),
        child: Row(
          children: [
            // Botão Ler
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _selected = 'ler'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isQRDetected ? AppColors.success : AppColors.secondary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Ler',
                    style: TextStyle(
                      color: isLer ? const Color(0xFF552F9F) : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            color: AppColors.darkBgSecondary,
            child: Column(
              children: [
                if (_isQRDetected)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(50),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'QR Code detectado! Toque para processar.',
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!_isQRDetected) ...[
                  const Icon(Icons.qr_code_2, size: 40, color: AppColors.secondary),
                  const SizedBox(height: 12),
                  const Text(
                    'Posicione o QR Code dentro do quadrado',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A câmera detectará automaticamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Ler', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.myQrCode),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.darkBg,
                            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Meu Código', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: _isQRDetected ? 'Processar PIX' : 'Ler QR Code',
                  onPressed: () {
                    if (_isQRDetected) {
                      Navigator.pushNamed(context, AppRoutes.transfer);
                    } else {
                      setState(() => _isQRDetected = true);
                    }
                  },
                  backgroundColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}