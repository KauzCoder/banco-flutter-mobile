import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/quote_controller.dart';
import 'package:flutter_aplication_bank/core/constants.dart';
import 'package:flutter_aplication_bank/core/theme.dart';
import 'package:flutter_aplication_bank/models/quote_model.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final tabs = const ['Todas', 'Favoritas', 'Moedas'];
  final favorites = <String>{'USD', 'EUR', 'GBP', 'JPY'};
  String selectedTab = 'Todas';
  bool showAllQuotes = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

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
    final filteredQuotes = controller.quotes.where((quote) {
      return switch (selectedTab) {
        'Favoritas' => favorites.contains(quote.symbol),
        'Moedas' => quote.category == 'Moedas',
        _ => true,
      };
    }).toList();
    final visibleQuotes = showAllQuotes
        ? filteredQuotes
        : filteredQuotes.take(4).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const AppBottomNavBar(
        currentItem: AppBottomNavItem.quotes,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: AppScreenHeader(
            title: 'Cotacao de Moedas',
            onBackPressed: () => Navigator.maybePop(context),
            trailing: AppHeaderIconButton(
              icon: Icons.pie_chart_outline,
              onTap: () {},
              backgroundColor: Colors.black,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.fetchQuotes,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            _buildTabs(),
            const SizedBox(height: 22),
            _buildHero(controller),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Principais moedas',
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  showAllQuotes
                      ? '${filteredQuotes.length} ativos'
                      : '${visibleQuotes.length}/${filteredQuotes.length}',
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (controller.isLoading)
              const _QuotesLoading()
            else if (controller.error != null)
              _QuotesError(message: controller.error!)
            else if (filteredQuotes.isEmpty)
              const _QuotesEmpty()
            else ...[
              ...visibleQuotes.map(_buildQuoteItem),
              if (filteredQuotes.length > 4)
                _buildShowMoreButton(filteredQuotes.length),
            ],
            const SizedBox(height: 16),
            _buildRefreshButton(controller),
            const SizedBox(height: 18),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0A13),
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(color: const Color(0xFF3F3154)),
      ),
      child: Row(children: tabs.map(_buildTab).toList()),
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = selectedTab == tab;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedTab = tab),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Text(
            tab,
            style: TextStyle(
              color: isSelected ? Colors.black : AppColors.darkTextSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(QuoteController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17101F), Color(0xFF2A1447)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF46345F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.currency_exchange_rounded,
                  color: Color(0xFF4D168F),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cotacao em tempo real',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Principais moedas contra o Real',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (controller.quotes.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildCompactSummary(controller.quotes.first),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactSummary(QuoteModel quote) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Text(
            'Destaque',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            quote.symbol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'R\$ ${quote.price}',
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteItem(QuoteModel quote) {
    final isFavorite = favorites.contains(quote.symbol);
    final changeColor = quote.changePositive
        ? AppColors.success
        : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF181021), Color(0xFF0A0710)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3F3154)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFDBFF2F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _symbolMark(quote.symbol),
              style: const TextStyle(
                color: Color(0xFF32105F),
                fontSize: 20,
                fontWeight: FontWeight.w900,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quote.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      quote.changePositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: changeColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      quote.change,
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _toggleFavorite(quote.symbol),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavorite
                    ? AppColors.secondary
                    : AppColors.darkTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(QuoteController controller) {
    return GestureDetector(
      onTap: controller.fetchQuotes,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withAlpha(60),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Atualizar cotacoes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowMoreButton(int total) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: OutlinedButton(
        onPressed: () => setState(() => showAllQuotes = !showAllQuotes),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          showAllQuotes ? 'Ver menos moedas' : 'Ver mais moedas ($total)',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dados em tempo real',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Cotacoes fornecidas pela Awesome API.',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _symbolMark(String symbol) {
    return switch (symbol) {
      'USD' => r'$',
      'EUR' => 'E',
      'GBP' => 'L',
      'JPY' => 'Y',
      'BTC' => 'B',
      'ARS' => 'A',
      'CAD' => 'C',
      'AUD' => 'A',
      'CHF' => 'F',
      'CNY' => 'Y',
      _ => symbol.isEmpty ? '?' : symbol[0],
    };
  }
}

class _QuotesLoading extends StatelessWidget {
  const _QuotesLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary,
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _QuotesError extends StatelessWidget {
  const _QuotesError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(color: AppColors.error),
      ),
      child: Text(message, style: const TextStyle(color: AppColors.error)),
    );
  }
}

class _QuotesEmpty extends StatelessWidget {
  const _QuotesEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.darkBgSecondary,
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: const Text(
        'Nenhuma cotacao disponivel para essa categoria.',
        style: TextStyle(color: AppColors.darkTextSecondary),
      ),
    );
  }
}
