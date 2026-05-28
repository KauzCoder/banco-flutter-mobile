import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool _isFlashlightOn = false;
  bool _isQRDetected = false;

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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: AppColors.darkBgSecondary,
                  child: const Center(
                    child: Text(
                      'Câmera Ativa',
                      style: TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isQRDetected ? AppColors.success : AppColors.secondary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 75,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.secondary, width: 3),
                        left: BorderSide(color: AppColors.secondary, width: 3),
                      ),
                    ),
                  ),
                ),
              ],
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
