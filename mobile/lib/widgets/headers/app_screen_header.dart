import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/theme.dart';

class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    this.onBackPressed,
    this.trailing,
    this.horizontalPadding = 20,
    this.verticalPadding = 12,
    super.key,
  });

  final String title;
  final VoidCallback? onBackPressed;
  final Widget? trailing;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: onBackPressed == null
                  ? const SizedBox(width: 40, height: 40)
                  : AppHeaderIconButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: onBackPressed!,
                    ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            if (trailing != null)
              Align(alignment: Alignment.centerRight, child: trailing),
          ],
        ),
      ),
    );
  }
}

class AppHeaderIconButton extends StatelessWidget {
  const AppHeaderIconButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor = AppColors.primary,
    this.iconColor = Colors.white,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}
