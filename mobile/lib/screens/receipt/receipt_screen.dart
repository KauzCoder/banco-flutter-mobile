import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

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
          'Comprovante',
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
          children: [
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transação Realizada',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'com sucesso!',
              style: TextStyle(
                color: AppColors.darkTextSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.darkBgSecondary,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Tipo', 'Transferência Bancária'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('Valor', 'R\$ 250,00'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('Beneficiário', 'Ling Habei'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('CPF', '123.456.789-00'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('Data', '25/05/2024'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('Hora', '14:30:45'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('ID da Transação', '#TRX123456789'),
                  const Divider(color: AppColors.darkBorder, height: 16),
                  _buildDetailRow('Status', 'Concluída', isStatus: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Saldo Disponível',
              style: TextStyle(
                color: AppColors.darkTextSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'R\$ 50.290,00',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Compartilhar Comprovante',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comprovante compartilhado!')),
                );
              },
              backgroundColor: AppColors.secondary,
              textColor: Colors.black,
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Voltar para Home',
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              backgroundColor: AppColors.darkBgSecondary,
              textColor: AppColors.darkText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isStatus ? AppColors.success : AppColors.darkText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
