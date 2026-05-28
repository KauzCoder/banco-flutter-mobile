import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

class TransactionsHistoryScreen extends StatefulWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  State<TransactionsHistoryScreen> createState() => _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<TransactionsHistoryScreen> {
  String _selectedFilter = 'Todas';

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
          'Histórico de Transações',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingMedium,
            ),
            child: Row(
              children: [
                _buildFilterChip('Todas'),
                const SizedBox(width: 8),
                _buildFilterChip('Enviadas'),
                const SizedBox(width: 8),
                _buildFilterChip('Recebidas'),
                const SizedBox(width: 8),
                _buildFilterChip('Pagamentos'),
              ],
            ),
          ),
          // Lista de Transações
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildTransactionItem(
                  index: index,
                  onTap: () => Navigator.pushNamed(context, '/receipt'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusMax),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem({required int index, required VoidCallback onTap}) {
    final transactions = [
      {
        'title': 'Transferência Enviada',
        'description': 'Para Ling Habei',
        'amount': '250.00',
        'date': '25/05/2024 14:30',
        'isPositive': false,
        'icon': Icons.call_made,
        'color': AppColors.error,
      },
      {
        'title': 'Salário Recebido',
        'description': 'Empresa XYZ',
        'amount': '3.500.00',
        'date': '25/05/2024 10:15',
        'isPositive': true,
        'icon': Icons.call_received,
        'color': AppColors.success,
      },
      {
        'title': 'Pagamento de Fatura',
        'description': 'Cartão de Crédito',
        'amount': '850.00',
        'date': '24/05/2024 16:45',
        'isPositive': false,
        'icon': Icons.credit_card,
        'color': AppColors.accent,
      },
    ];

    final transaction = transactions[index % transactions.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (transaction['color'] as Color).withAlpha((0.2 * 255).round()),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Icon(
                    transaction['icon'] as IconData,
                    color: transaction['color'] as Color,
                    size: AppConstants.iconMedium,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['title'].toString(),
                        style: const TextStyle(
                          color: AppColors.darkText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        transaction['description'].toString(),
                        style: const TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${transaction['isPositive'] == true ? '+' : '-'} R\$ ${transaction['amount']}',
                      style: TextStyle(
                        color: transaction['isPositive'] == true ? AppColors.success : AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      transaction['date'].toString(),
                      style: const TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
