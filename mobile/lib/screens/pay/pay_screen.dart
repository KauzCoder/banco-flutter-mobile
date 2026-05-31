import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';
import '../../core/theme.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      bottomNavigationBar: const AppBottomNavBar(
        currentItem: AppBottomNavItem.pay,
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'Pagamentos',
              onBackPressed: () => Navigator.maybePop(context),
            ),
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
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.scanQr),
                    ),
                    const SizedBox(height: 10),
                    _buildOptionTile(
                      icon: Icons.keyboard_rounded,
                      label: 'Digitar',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.transfer,
                        arguments: 'Digitar',
                      ),
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppColors.primary.withAlpha(40),
        highlightColor: AppColors.primary.withAlpha(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.darkBgSecondary,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.secondary, width: 1.8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
      {'icon': Icons.pix, 'label': 'Pix', 'route': AppRoutes.pix},
      {
        'icon': Icons.phone_android_rounded,
        'label': 'Recargas',
        'route': AppRoutes.payments,
      },
      {
        'icon': Icons.storefront_rounded,
        'label': 'Cobrar',
        'route': AppRoutes.transfer,
      },
      {
        'icon': Icons.barcode_reader,
        'label': 'Boleto',
        'route': AppRoutes.payments,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: actions.map((action) {
        final route = action['route'] as String;
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: _buildActionItem(
            context: context,
            icon: action['icon'] as IconData,
            label: action['label'] as String,
            route: route,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFFD700),
                width: 2.3,
              ),
            ),
            child: Material(
              color: const Color(0xFF8041FF),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, route),
                customBorder: const CircleBorder(),
                splashColor: Colors.white24,
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(icon, color: const Color(0xFFCE91FF), size: 26),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}