import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/theme/app_colors.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.amount,
    this.isPositive = false,
    this.iconBackgroundColor = const Color(0xFF8B5CF6),
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String amount;
  final bool isPositive;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final amountColor = isPositive ? Color(0xFF22C55E) : Color(0xFFEF4444);
    final amountPrefix = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            '$amountPrefix$amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
