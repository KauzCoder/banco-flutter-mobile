import 'package:flutter/material.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  void _showSnackbar(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: const Color(0xFF6B3FE4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildOptionTile(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Escanear',
                      onTap: () => _showSnackbar(context, 'Abrindo câmera...'),
                    ),
                    const SizedBox(height: 10),
                    _buildOptionTile(
                      icon: Icons.keyboard_rounded,
                      label: 'Digitar',
                      onTap: () => _showSnackbar(context, 'Digitar código...'),
                    ),
                    const SizedBox(height: 28),
                    _buildQuickActions(context),
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
                decoration: BoxDecoration(
                  color: const Color(0xFF6B3FE4),
                  borderRadius: BorderRadius.circular(12),
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
            'Pagamentos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF141428),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: const Color(0xFF6B3FE4).withOpacity(0.2),
        highlightColor: const Color(0xFF6B3FE4).withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A45), width: 0.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF6B6B8A),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.pix, 'label': 'Pix', 'msg': 'Área Pix'},
      {'icon': Icons.phone_android_rounded, 'label': 'Recargas', 'msg': 'Recargas'},
      {'icon': Icons.storefront_rounded, 'label': 'Cobrar', 'msg': 'Cobrar'},
      {'icon': Icons.barcode_reader, 'label': 'Boleto', 'msg': 'Boleto'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: _buildActionItem(
            context: context,
            icon: action['icon'] as IconData,
            label: action['label'] as String,
            msg: action['msg'] as String,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String msg,
  }) {
    return GestureDetector(
      onTap: () => _showSnackbar(context, msg),
      child: Column(
        children: [
          Material(
            color: const Color(0xFF2D1F5E),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => _showSnackbar(context, msg),
              borderRadius: BorderRadius.circular(16),
              splashColor: const Color(0xFF9B6FFF).withOpacity(0.3),
              child: SizedBox(
                width: 52,
                height: 52,
                child: Icon(icon, color: const Color(0xFF9B6FFF), size: 24),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF8A8AA8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}