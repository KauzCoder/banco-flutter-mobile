import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/theme/app_colors.dart';

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    required this.currencyPair,
    required this.value,
    required this.percentChange,
    this.isPositive = true,
    super.key,
  });

  final String currencyPair;
  final String value;
  final String percentChange;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final changeColor = isPositive ? Color(0xFF22C55E) : Color(0xFFEF4444);
    final currencySymbol = currencyPair.isNotEmpty ? currencyPair[0] : '\$';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency Symbol
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFCBFF00),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                currencySymbol,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Currency Pair
          Text(
            currencyPair,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          // Change
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: changeColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                percentChange,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: changeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
