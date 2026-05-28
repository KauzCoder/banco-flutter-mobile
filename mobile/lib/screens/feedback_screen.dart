import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import '../core/routes/app_routes.dart';

class FeedbackScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final String? type; // 'success', 'error', 'warning', 'info'
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  const FeedbackScreen({
    super.key,
    this.title,
    this.message,
    this.type = 'info',
    this.onRetry,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.darkBg;
    Color iconColor = AppColors.primary;
    IconData icon = Icons.info;

    switch (type) {
      case 'error':
        iconColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case 'success':
        iconColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case 'warning':
        iconColor = AppColors.warning;
        icon = Icons.warning_amber_outlined;
        break;
      default:
        iconColor = AppColors.primary;
        icon = Icons.info_outline;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha((0.2 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title ?? 'Aviso',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? 'Algo inesperado aconteceu',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 64),
              // Detalhes adicionais baseado no tipo
              if (type == 'error') ...[
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppColors.error),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dica: Verifique sua conexão e tente novamente',
                          style: TextStyle(
                            color: AppColors.darkTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
              CustomButton(
                label: onRetry != null ? 'Tentar Novamente' : 'Voltar para Home',
                onPressed: onRetry != null
                    ? onRetry!
                    : (onGoHome != null ? onGoHome! : () => Navigator.pop(context)),
                backgroundColor: iconColor,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Voltar para Home',
                  onPressed:
                      onGoHome != null ? onGoHome! : () => Navigator.pop(context),
                  backgroundColor: AppColors.darkBgSecondary,
                  textColor: AppColors.darkText,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Variante para erro simples
class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FeedbackScreen(
      title: 'Oops!',
      message: message,
      type: 'error',
      onRetry: onRetry,
      onGoHome: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
    );
  }
}

// Variante para sucesso
class SuccessScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onContinue;

  const SuccessScreen({
    super.key,
    required this.message,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return FeedbackScreen(
      title: 'Sucesso!',
      message: message,
      type: 'success',
      onGoHome: onContinue ?? () => Navigator.pop(context),
    );
  }
}
