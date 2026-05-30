import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/controllers/transfer_controller.dart';
import 'package:flutter_aplication_bank/models/transfer_request.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';

class TransferScreen extends StatefulWidget {
  final String initialSection;

  const TransferScreen({super.key, this.initialSection = 'Escanear'});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _recipientController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedSection = 'Escanear';
  String _amount = '';
  String _selectedContact = 'Adicionar';

  final contacts = ['Adicionar', 'Maria', 'Jean', 'Ryan', 'Neto', 'Yan'];

  final quickActions = [
    {
      'icon': Icons.attach_money_rounded,
      'label': 'Pix',
      'color': AppColors.secondary,
    },
    {
      'icon': Icons.phone_android_outlined,
      'label': 'Recargas',
      'color': AppColors.primaryLight,
    },
    {
      'icon': Icons.request_quote_outlined,
      'label': 'Cobrar',
      'color': AppColors.accent,
    },
    {
      'icon': Icons.receipt_long_outlined,
      'label': 'Boleto',
      'color': AppColors.secondaryDark,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _selectSection(String section) {
    setState(() => _selectedSection = section);
  }

  void _appendAmount(String value) {
    setState(() {
      if (value == 'del') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else if (value == '000') {
        _amount += '000';
      } else {
        _amount += value;
      }
    });
  }

  String get _formattedAmount {
    if (_amount.isEmpty) return '0,00';
    final digits = _amount.replaceAll(',', '');
    final value = int.tryParse(digits) ?? 0;
    final formatted = (value / 100).toStringAsFixed(2).replaceAll('.', ',');
    return formatted;
  }

  double get _amountValue {
    final digits = _amount.replaceAll(',', '');
    final value = int.tryParse(digits) ?? 0;
    return value / 100;
  }

  void _handleActionTap(String label) {
    if (label == 'Pix') {
      _selectSection('Digitar');
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label em desenvolvimento')));
  }

  Future<void> _handlePayment() async {
    if (_recipientController.text.isEmpty || _amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe destinatário e valor')),
      );
      return;
    }

    final request = TransferRequest(
      recipient: _recipientController.text.trim(),
      amount: _amountValue,
      message: _messageController.text.trim(),
      type: 'PIX',
    );

    try {
      await context.read<TransferController>().sendTransfer(request);
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.receipt);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

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
        title: Text(
          _selectedSection == 'Digitar' ? 'Área PIX' : 'Transferências',
          style: const TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: AppConstants.paddingMedium),
              child: Icon(Icons.notifications_none, color: AppColors.darkText),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionSelector(),
                  const SizedBox(height: 20),
                  if (_selectedSection == 'Escanear') ...[
                    _buildScanSection(),
                  ] else ...[
                    _buildPixAreaSection(),
                  ],
                ],
              ),
            ),
          ),
          const AppBottomNavBar(currentItem: AppBottomNavItem.qr),
        ],
      ),
    );
  }

  Widget _buildSectionSelector() {
    return Row(
      children: [
        _buildSectionButton('Escanear', Icons.qr_code_scanner_outlined),
        const SizedBox(width: 12),
        _buildSectionButton('Digitar', Icons.keyboard_outlined),
      ],
    );
  }

  Widget _buildSectionButton(String label, IconData icon) {
    final selected = _selectedSection == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectSection(label),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : AppColors.darkBgSecondary,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            border: Border.all(
              color: selected ? AppColors.secondary : AppColors.darkBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.black : AppColors.darkText,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.black : AppColors.darkText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pagamentos',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Escanear QR',
                Icons.qr_code,
                AppColors.primary,
                () => Navigator.pushNamed(context, AppRoutes.scanQr),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Digitar',
                Icons.keyboard,
                AppColors.secondary,
                () => _selectSection('Digitar'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quickActions.map((action) {
            return _buildQuickAction(
              action['icon'] as IconData,
              action['label'] as String,
              action['color'] as Color,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Prático e rápido',
              style: TextStyle(
                color: AppColors.darkTextSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () => _handleActionTap(label),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(icon, color: Colors.black, size: 18),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPixAreaSection() {
    final transferController = context.watch<TransferController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Área PIX',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: contacts.map((contact) {
              final isSelected = contact == _selectedContact;
              return GestureDetector(
                onTap: () => setState(() => _selectedContact = contact),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 58,
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.darkBgSecondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Center(
                          child: Text(
                            contact.substring(0, 1),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.darkText,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        contact,
                        style: const TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          'Quem vai receber',
          'Nome, CPF/CNPJ ou Chave Pix',
          _recipientController,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            gradient: AppColors.purpleGradient,
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          ),
          child: Column(
            children: [
              const Text(
                'Valor',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                'R\$ $_formattedAmount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Valor',
                style: TextStyle(
                  color: Colors.white.withAlpha((0.7 * 255).round()),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInputField(
          'Escreva uma mensagem',
          'Mensagem opcional',
          _messageController,
          maxLines: 1,
        ),
        const SizedBox(height: 20),
        _buildKeypad(),
        const SizedBox(height: 20),
        if (transferController.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              transferController.error!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        CustomButton(
          label: 'Transferir',
          onPressed: _handlePayment,
          isLoading: transferController.isSubmitting,
          backgroundColor: AppColors.success,
          icon: Icons.send,
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.darkText),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeypad() {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '000',
      '0',
      'del',
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: keys.map((key) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 72) / 3,
          height: 58,
          child: ElevatedButton(
            onPressed: () => _appendAmount(key),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBgSecondary,
              foregroundColor: AppColors.darkText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
            ),
            child: key == 'del'
                ? const Icon(Icons.backspace_outlined)
                : Text(
                    key,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
