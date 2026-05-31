import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:flutter_aplication_bank/services/profile_repository.dart';
import 'package:flutter_aplication_bank/services/transactions_service.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileRepository _profileRepository = ProfileRepository();
  final TransactionsService _transactionsService = TransactionsService();

  bool _hideValues = true;
  bool _isLoading = true;
  String? _error;
  UserProfile? _profile;
  Map<String, dynamic>? _account;
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    if (!AuthService.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait<Object?>([
        _profileRepository.getCurrentUser(),
        _profileRepository.getAccount(),
        _transactionsService.fetchTransactions(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _profile = results[0] as UserProfile;
        _account = results[1] as Map<String, dynamic>?;
        _transactions = results[2] as List<TransactionModel>;
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
      backgroundColor: Colors.black,
      bottomNavigationBar: const AppBottomNavBar(
        currentItem: AppBottomNavItem.home,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF7C3AED),
          onRefresh: _loadHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopArea(context),
                if (_error != null) _buildErrorBanner(),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildQuickActions(context),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildCurrencyCard(context),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildRecentTransactions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopArea(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF26006D), Color(0xFF3E0098)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 22),
          _buildBalanceCard(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final firstName = (_profile?.nome.trim().isNotEmpty ?? false)
        ? _profile!.nome.trim().split(' ').first
        : 'cliente';

    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          borderRadius: BorderRadius.circular(24),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFE9E9F0),
            backgroundImage: (_profile?.fotoPerfil.trim().isNotEmpty ?? false)
                ? NetworkImage(_profile!.fotoPerfil)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _isLoading ? 'Carregando...' : 'Boas vinda de volta,$firstName!👋',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _headerButton(Icons.help_outline_rounded, () {}),
        const SizedBox(width: 8),
        _headerButton(Icons.notifications_none_rounded, () {}),
      ],
    );
  }

  Widget _headerButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final balance = _formatCurrency(_account?['saldo']);
    final entrada = _formatCurrency(_monthlyTotal(isExpense: false));
    final saida = _formatCurrency(_monthlyTotal(isExpense: true));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8C35FF), Color(0xFF4B159F)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Saldo principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  _hideValues ? 'R\$ ******' : balance,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _hideValues = !_hideValues),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 27,
                  height: 27,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _hideValues
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _pill('+25 %', const Color(0xFF5CFF35)),
              const SizedBox(width: 8),
              const Text(
                'Ultimo Mes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _balanceInfo('Disponivel em Conta', balance)),
              Expanded(
                child: _balanceInfo(
                  'Ultima Atualizacao',
                  _lastUpdateLabel(),
                  alignEnd: true,
                  dotColor: const Color(0xFF5CFF35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white30, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _flowCard(
                  Icons.arrow_downward_rounded,
                  'Entrada do Mes',
                  _hideValues ? 'R\$ ******' : entrada,
                  const Color(0xFF65E826),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _flowCard(
                  Icons.arrow_upward_rounded,
                  'Saida do Mes',
                  _hideValues ? 'R\$ ******' : saida,
                  const Color(0xFFE21D1D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2A0B65),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _balanceInfo(
    String label,
    String value, {
    bool alignEnd = false,
    Color? dotColor,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (dotColor != null) ...[
              const SizedBox(width: 6),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _hideValues && label.contains('Conta') ? 'R\$ ******' : value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _flowCard(IconData icon, String label, String value, Color color) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final items = [
      _QuickAction(
        'assets/svgs/pix-icon.svg',
        'Pix &\nTransferir',
        AppRoutes.pix,
      ),
      _QuickAction('assets/svgs/pagar.svg', 'Pagar', AppRoutes.pay),
      _QuickAction(
        'assets/svgs/emprestimo.svg',
        'Emprestimos',
        AppRoutes.underDevelopment,
      ),
      _QuickAction(
        'assets/svgs/investir.svg',
        'Investir',
        AppRoutes.underDevelopment,
      ),
      _QuickAction(
        'assets/svgs/cofrinho.svg',
        'Meu\nPorquinho',
        AppRoutes.underDevelopment,
      ),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: item.route == null
                ? null
                : () => Navigator.pushNamed(
                    context,
                    item.route!,
                    arguments: item.label.replaceAll('\n', ' '),
                  ),
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 68,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBFF2F),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item.assetPath,
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF211039), Color(0xFF0E0619), Color(0xFF050308)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF52347D)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withAlpha(35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBFF2F),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.currency_exchange_rounded,
                  color: Color(0xFF4D168F),
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cotacao de moedas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Atualizacao agora',
                          style: TextStyle(
                            color: Color(0xFFC6B7DA),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5),
                        CircleAvatar(
                          radius: 2,
                          backgroundColor: Color(0xFF59FF20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _currencyRow(
            name: 'Dolar Americano',
            code: 'USD',
            value: 'R\$ 5,17',
            change: '+0,86%',
            symbol: '\$',
          ),
          const SizedBox(height: 10),
          _currencyRow(
            name: 'Euro',
            code: 'EUR',
            value: 'R\$ 5,62',
            change: '+0,64%',
            symbol: 'E',
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.quotes),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 46,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver cotacoes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right, color: Colors.white, size: 17),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencyRow({
    required String name,
    required String code,
    required String value,
    required String change,
    required String symbol,
    bool isPositive = true,
  }) {
    final changeColor = isPositive
        ? const Color(0xFF59FF20)
        : const Color(0xFFFF5A5A);

    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFF45D719),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              symbol,
              style: const TextStyle(
                color: Color(0xFF17320B),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  code,
                  style: const TextStyle(
                    color: Color(0xFFC6B7DA),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    isPositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: changeColor,
                    size: 11,
                  ),
                  Text(
                    change,
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final recent = _transactions.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Transacoes Recentes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.transactions),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF7C3AED)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ver tudo',
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, color: Colors.white, size: 13),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
            ),
          )
        else if (recent.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text(
              'Nenhuma transacao encontrada',
              style: TextStyle(color: Color(0xFFA4A4AE), fontSize: 12),
            ),
          )
        else
          ...recent.map(_transactionItem),
      ],
    );
  }

  Widget _transactionItem(TransactionModel transaction) {
    final isIncoming = !transaction.isExpense;
    final title = _hideValues ? 'Transacao oculta' : transaction.title;
    final subtitle = _hideValues
        ? 'Detalhes ocultos'
        : '${_timeLabel(transaction.dateTime)} - ${transaction.type.isEmpty ? transaction.category : transaction.type}';
    final value = _hideValues ? 'R\$ ******' : transaction.formattedAmount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF4E218B),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isIncoming ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: isIncoming ? const Color(0xFF59FF20) : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              color: isIncoming ? const Color(0xFF59FF20) : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7F1D1D)),
      ),
      child: Text(
        _error!,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  num _monthlyTotal({required bool isExpense}) {
    return _transactions
        .where((transaction) => transaction.isExpense == isExpense)
        .fold<num>(0, (sum, transaction) => sum + transaction.amount.abs());
  }

  String _formatCurrency(dynamic value) {
    final amount = value is num ? value : num.tryParse(value?.toString() ?? '');
    final normalized = (amount ?? 0).toStringAsFixed(2);
    final parts = normalized.split('.');
    final buffer = StringBuffer();
    final integer = parts[0];

    for (var i = 0; i < integer.length; i++) {
      if (i > 0 && (integer.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(integer[i]);
    }

    return 'R\$ ${buffer.toString()},${parts[1]}';
  }

  String _lastUpdateLabel() {
    final latest = _transactions.isEmpty ? null : _transactions.first.dateTime;
    if (latest == null) {
      return 'Hoje';
    }

    return 'Hoje, ${_timeLabel(latest)}';
  }

  String _timeLabel(DateTime? dateTime) {
    if (dateTime == null) {
      return '--:--';
    }

    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _QuickAction {
  const _QuickAction(this.assetPath, this.label, this.route);

  final String assetPath;
  final String label;
  final String? route;
}
