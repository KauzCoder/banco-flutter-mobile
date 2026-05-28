import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';

class PixAreaScreen extends StatelessWidget {
  const PixAreaScreen({super.key});

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
          'Área PIX',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas Chaves PIX',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildPixKeyCard('Email', 'linghabei@gmail.com'),
            _buildPixKeyCard('Telefone', '(91) 98765-4321'),
            _buildPixKeyCard('CPF', '123.456.789-00'),
            _buildPixKeyCard('Aleatória', 'a1b2c3d4-e5f6-7g8h-9i0j'),
            const SizedBox(height: 24),
            const Text(
              'Ações Rápidas',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Meu QR Code',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.myQrCode),
              backgroundColor: AppColors.secondary,
              textColor: Colors.black,
              icon: Icons.qr_code_2,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Escanear QR Code',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.scanQr),
              backgroundColor: AppColors.primary,
              icon: Icons.photo_camera,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Transferência PIX',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.transfer),
              backgroundColor: AppColors.accent,
              icon: Icons.send,
            ),
            const SizedBox(height: 24),
            const Text(
              'Últimas Transações PIX',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TransactionListItem(
              title: 'PIX Enviado',
              description: 'Para Maria Silva',
              amount: '100.00',
              isPositive: false,
              icon: Icons.call_made,
              iconBgColor: AppColors.error,
            ),
            TransactionListItem(
              title: 'PIX Recebido',
              description: 'De Carlos Santos',
              amount: '250.00',
              isPositive: true,
              icon: Icons.call_received,
              iconBgColor: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPixKeyCard(String type, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}
