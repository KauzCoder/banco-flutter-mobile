import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';

class MyQRCodeScreen extends StatelessWidget {
  const MyQRCodeScreen({super.key});

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
        actions: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Imagem do QR Code salva!')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: AppConstants.paddingMedium),
              child: Icon(Icons.image_outlined, color: AppColors.darkText),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Text(
              'Kauã Mendes Fragoso',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'O código expira em 10:00',
              style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
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
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Compartilhar Código',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código compartilhado!')),
                );
              },
              icon: Icons.share,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Copiar Código',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código copiado para a área de transferência!')),
                );
              },
              backgroundColor: AppColors.secondary,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
