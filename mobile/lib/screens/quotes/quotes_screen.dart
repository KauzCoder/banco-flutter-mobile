import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_bank/controllers/quote_controller.dart';
import 'package:flutter_aplication_bank/models/quote_model.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
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
    final filteredQuotes = controller.quotes;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      bottomNavigationBar: const AppBottomNavBar(
        currentItem: AppBottomNavItem.quotes,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: AppScreenHeader(
            title: 'Cotação de Moedas',
            onBackPressed: () => Navigator.maybePop(context),
            trailing: AppHeaderIconButton(
              icon: Icons.pie_chart_outline,
              onTap: () {},
              backgroundColor: AppColors.darkBgSecondary,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
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
          else
            ...filteredQuotes.map(_buildQuoteItem),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: controller.fetchQuotes,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withAlpha((0.25 * 255).round()),
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
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svgs/solar_shield-bold-duotone.svg',
                  width: 34,
                  height: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Cotação em tempo real',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dados fornecidos em tempo real através da Awesome API',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                    quote.changePositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: quote.changePositive
                        ? AppColors.success
                        : AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    quote.change,
                    style: TextStyle(
                      color: quote.changePositive
                          ? AppColors.success
                          : AppColors.error,
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
              color: isFavorite
                  ? AppColors.secondary
                  : AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

