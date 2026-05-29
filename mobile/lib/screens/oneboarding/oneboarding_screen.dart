import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/core/theme/app_colors.dart';

class OneboardingScreen extends StatefulWidget {
  const OneboardingScreen({super.key});

  @override
  State<OneboardingScreen> createState() => _OneboardingScreenState();
}

class _OneboardingScreenState extends State<OneboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OneboardingData> _pages = [
    _OneboardingData(
      title: 'Investimentos\nInteligentes',
      subtitle: 'Faça Seu Dinheiro Trabalhar para Você, Rendimento maior que a poupança, Fundos, CDBs e Tesouro Direto, Assessoria financeira gratuita.',
      imageAsset: 'assets/images/123f479ea6f8cd7e6f51f39f9c46fe6345e2289c.png',
      fallbackIcon: Icons.phone_android_rounded,
      accentColor: const Color(0xFFCBFF4D),
    ),
    _OneboardingData(
      title: 'Pagamento mais\nrapido do mundo',
      subtitle: 'Integre múltiplos métodos de pagamento para agilizar o processo rapidamente',
      imageAsset: 'assets/images/3ea56df9459a0f2731195dbdb5951573840f4d05 (1).png',
      fallbackIcon: Icons.security_rounded,
      accentColor: const Color(0xFF9B6FFF),
    ),
    _OneboardingData(
      title: 'A plataforma mais\nsegura para o cliente',
      subtitle: 'Reconhecimento de impressão digital, reconhecimento facial e mais, mantendo você completamente seguro.',
      imageAsset: 'assets/images/6135364dda317a9b880cf13ee65cf0b78e7829ac.png',
      fallbackIcon: Icons.show_chart_rounded,
      accentColor: const Color(0xFFCBFF4D),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.0,
                colors: [
                  AppColors.secondary,
                  AppColors.primary,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildIllustration(_pages[index]);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.secondary
                            : const Color(0xFF2A2A45),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(_currentPage),
                      children: [
                        Text(
                          _pages[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _pages[_currentPage].subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF8A8AA8),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Começar' : 'Próximo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(_OneboardingData data) {
    return Center(
      child: SizedBox(
        width: 1500,
        height: 1000,
        child: Image.asset(
          data.imageAsset,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                data.fallbackIcon,
                size: 100,
                color: data.accentColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OneboardingData {
  final String title;
  final String subtitle;
  final String imageAsset;
  final IconData fallbackIcon;
  final Color accentColor;

  _OneboardingData({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.fallbackIcon,
    required this.accentColor,
  });
}