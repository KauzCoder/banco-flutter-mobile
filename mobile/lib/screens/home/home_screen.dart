import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:flutter_aplication_bank/services/profile_repository.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileRepository _profileRepository = ProfileRepository();
  bool _hideBalance = false;
  bool _isLoading = true;
  String? _error;
  UserProfile? _profile;
  Map<String, dynamic>? _account;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    if (!AuthService.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.signIn);
        }
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _profileRepository.getCurrentUser(),
        _profileRepository.getAccount(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _profile = results[0] as UserProfile;
        _account = results[1] as Map<String, dynamic>?;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Nao foi possivel carregar sua conta.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      bottomNavigationBar: const AppBottomNavBar(
        currentItem: AppBottomNavItem.home,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            if (_error != null) _buildErrorBanner(),
            _buildBalanceCard(),
            _buildQuickActions(context),
            _buildCurrencyCard(),
            _buildRecentTransactions(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ───── HEADER ─────
  Widget _buildHeader(BuildContext context) {
    final firstName = (_profile?.nome.trim().isNotEmpty ?? false)
        ? _profile!.nome.trim().split(' ').first
        : 'cliente';

    return Container(
      padding: const EdgeInsets.only(top: 52, left: 20, right: 20, bottom: 20),
      color: const Color(0xFF0D0D0D),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF2A2A2A),
            child: Icon(Icons.person, color: Colors.white54, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isLoading ? 'Carregando...' : 'Ola, $firstName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _headerBtn(Icons.help_outline_rounded, () {}),
          const SizedBox(width: 10),
          _headerBtn(Icons.notifications_outlined, () {}),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7F1D1D)),
      ),
      child: Text(
        _error!,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  String _formatCurrency(dynamic value) {
    final amount = value is num ? value : num.tryParse(value?.toString() ?? '');
    final normalized = (amount ?? 0).toStringAsFixed(2);
    final parts = normalized.split('.');
    final buffer = StringBuffer();

    for (var i = 0; i < parts[0].length; i++) {
      if (i > 0 && (parts[0].length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(parts[0][i]);
    }

    return 'R\$ ${buffer.toString()},${parts[1]}';
  }

  Widget _headerBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  // ───── BALANCE CARD ─────
  Widget _buildBalanceCard() {
    final balance = _formatCurrency(_account?['saldo']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9B6FFF), Color(0xFF6B3FE4)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Saldo principal',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _hideBalance ? 'R\$ ******' : balance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _hideBalance = !_hideBalance),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _hideBalance ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '+25%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ultimo Mês',
            style: TextStyle(color: Colors.white60, fontSize: 11),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            children: [
              _balanceInfo('Disponivel em Conta', balance),
              const Spacer(),
              _balanceInfo(
                'Ultima Atualização',
                'Hoje, 09:41',
                dotColor: const Color(0xFF22C55E),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _flowCard(
                  Icons.arrow_downward_rounded,
                  'Entrada do Mês',
                  'R\$ 6.350,00',
                  const Color(0xFF22C55E),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _flowCard(
                  Icons.arrow_upward_rounded,
                  'Saída do Mês',
                  'R\$ 2.860,00',
                  const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceInfo(String label, String value, {Color? dotColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (dotColor != null) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _flowCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───── QUICK ACTIONS ─────
  Widget _buildQuickActions(BuildContext context) {
    final items = [
      {
        'icon': Icons.compare_arrows_rounded,
        'label': 'Pix &\nTransferir',
        'route': AppRoutes.pix,
      },
      {
        'icon': Icons.view_week_rounded,
        'label': 'Pagar',
        'route': AppRoutes.pay,
      },
      {
        'icon': Icons.monetization_on_outlined,
        'label': 'Emprestimos',
        'route': null,
      },
      {'icon': Icons.show_chart_rounded, 'label': 'Investir', 'route': null},
      {
        'icon': Icons.savings_outlined,
        'label': 'Meu\nPorquinho',
        'route': null,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () {
              if (item['route'] != null) {
                Navigator.of(context).pushNamed(item['route'] as String);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBFF4D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: const Color(0xFF6B3FE4),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ───── CURRENCY CARD ─────
  Widget _buildCurrencyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1040),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Cotacao de moedas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Atualização Agora',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _currencyRow('Dolar Americano', 'USD', 'R\$ 5,17', '+0,86%'),
          const SizedBox(height: 10),
          _currencyRow('Euro', 'EUR', 'R\$ 5,17', '+0,86%'),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.quotes),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B3FE4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver cotacoes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencyRow(String name, String code, String value, String change) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFF22C55E),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              code,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.arrow_upward_rounded,
                  color: Color(0xFF22C55E),
                  size: 12,
                ),
                Text(
                  change,
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ───── RECENT TRANSACTIONS ─────
  Widget _buildRecentTransactions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transações Recentes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Hoje',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.transactions),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Ver tudo',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _transactionItem(
            name: 'Yan Freitas Carvalho dos Santos',
            time: '10:30 • Pix',
            value: '+R\$ 450,00',
            isIncoming: true,
          ),
          const SizedBox(height: 10),
          _transactionItem(
            name: 'Lider Supermercados',
            time: '21:45 • Pix',
            value: 'R\$ 450,00',
            isIncoming: false,
          ),
        ],
      ),
    );
  }

  Widget _transactionItem({
    required String name,
    required String time,
    required String value,
    required bool isIncoming,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1040),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncoming ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: isIncoming ? const Color(0xFF22C55E) : Colors.white70,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isIncoming ? const Color(0xFF22C55E) : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
