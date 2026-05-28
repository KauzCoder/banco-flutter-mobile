import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.enabled = true,
    this.padding,
    this.icon,
    this.style,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = ElevatedButton.styleFrom(
      backgroundColor: enabled
          ? (isPrimary ? AppColors.primary : AppColors.secondary)
          : colorScheme.onSurface.withValues(alpha: 0.12),
      foregroundColor: enabled ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.38),
      disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        icon: icon!,
        label: Text(label),
        style: style ?? baseStyle,
        onPressed: enabled ? onPressed : null,
      );
    }

    return ElevatedButton(
      style: style ?? baseStyle,
      onPressed: enabled ? onPressed : null,
      child: Text(label),
    );
  }
}
