import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';

enum AppBottomNavItem { home, transactions, qr, quotes, settings }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({required this.currentItem, super.key});

  final AppBottomNavItem? currentItem;

  static const _barColor = Color(0xFFDBFF2F);
  static const _purple = Color(0xFF8A35FF);
  static const _purpleDark = Color(0xFF4D2799);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 76,
              color: _barColor,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavIcon(
                      icon: Icons.home_outlined,
                      isActive: currentItem == AppBottomNavItem.home,
                      onTap: () => _openRoute(context, AppRoutes.home),
                    ),
                    _NavIcon(
                      icon: Icons.receipt_long_outlined,
                      isActive: currentItem == AppBottomNavItem.transactions,
                      onTap: () => _openRoute(context, AppRoutes.transactions),
                    ),
                    const SizedBox(width: 82),
                    _NavIcon(
                      icon: Icons.trending_up_rounded,
                      isActive: currentItem == AppBottomNavItem.quotes,
                      onTap: () => _openRoute(context, AppRoutes.quotes),
                    ),
                    _NavIcon(
                      icon: Icons.more_horiz_rounded,
                      isActive: currentItem == AppBottomNavItem.settings,
                      onTap: () => _openRoute(context, AppRoutes.settings),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _QrButton(
              isActive: currentItem == AppBottomNavItem.qr,
              onTap: () => _openRoute(context, AppRoutes.scanQr),
            ),
          ),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == route) {
      return;
    }

    Navigator.of(context).pushNamed(route);
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Icon(
          icon,
          color: AppBottomNavBar._purple.withValues(alpha: isActive ? 1 : 0.78),
          size: 30,
        ),
      ),
    );
  }
}

class _QrButton extends StatelessWidget {
  const _QrButton({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppBottomNavBar._barColor,
        ),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppBottomNavBar._purple, AppBottomNavBar._purpleDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppBottomNavBar._barColor, width: 8),
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
