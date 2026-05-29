import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_bank/controllers/quote_controller.dart';
import 'package:flutter_aplication_bank/models/quote_model.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final tabs = ['Todas', 'Favoritas', 'Moedas', 'Criptomoedas'];
  String selectedTab = 'Todas';
  final favorites = <String>{'USD', 'KZ', 'JPY'};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = context.read<QuoteController>();
      if (controller.quotes.isEmpty && !controller.isLoading) {
        controller.fetchQuotes();
      }
    });
  }

  List<QuoteModel> _filterQuotes(List<QuoteModel> quotes) {
    if (selectedTab == 'Todas') return quotes;
    if (selectedTab == 'Favoritas') {
      return quotes.where((quote) => favorites.contains(quote.symbol)).toList();
    }
    return quotes.where((quote) => quote.category == selectedTab).toList();
  }

  void _toggleFavorite(String symbol) {
    setState(() {
      if (favorites.contains(symbol)) {
        favorites.remove(symbol);
      } else {
        favorites.add(symbol);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QuoteController>();
    final filteredQuotes = _filterQuotes(controller.quotes);

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
          'Cotação de Moedas',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppConstants.paddingMedium),
            child: Icon(Icons.pie_chart_outline, color: AppColors.darkText, size: 24),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          Row(
            children: [
              for (final tab in tabs) ...[
                _buildTab(tab),
                const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 170,
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.darkBgSecondary,
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cotação em tempo real',
                  style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Dados fornecidos em tempo real através da Awesome API',
                  style: TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Atualização Agora',
                      style: TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Principais moedas',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (controller.isLoading)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.darkBgSecondary,
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (controller.error != null)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(30),
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                border: Border.all(color: AppColors.error),
              ),
              child: Text(
                controller.error!,
                style: const TextStyle(color: AppColors.error),
              ),
            )
          else if (filteredQuotes.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.darkBgSecondary,
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: const Text(
                'Nenhuma cotação disponível para essa categoria.',
                style: TextStyle(color: AppColors.darkTextSecondary),
              ),
            )
          else ...filteredQuotes.map(_buildQuoteItem),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: controller.fetchQuotes,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha((0.25 * 255).round()),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Atualizar cotações',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    final isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: AnimatedContainer(
        duration: AppConstants.animationDuration,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(color: isSelected ? AppColors.secondary : AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.darkText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteItem(QuoteModel quote) {
    final isFavorite = favorites.contains(quote.symbol);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary,
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
            child: Center(
              child: Text(
                quote.symbol[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.symbol,
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quote.name,
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${quote.price}',
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    quote.changePositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                    color: quote.changePositive ? AppColors.success : AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    quote.change,
                    style: TextStyle(
                      color: quote.changePositive ? AppColors.success : AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _toggleFavorite(quote.symbol),
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? AppColors.secondary : AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
