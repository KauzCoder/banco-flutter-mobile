import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/constants/app_constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/cards/balance_card.dart';
import 'package:flutter_aplication_bank/widgets/cards/module_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hideBalance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFF6D28D9),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
          // Balance Card
          BalanceCard(
            balance: 'R\$ 50.540,00',
            userName: 'Olá, Kauã',
            hideBalance: _hideBalance,
            onEyePressed: () {
              setState(() {
                _hideBalance = !_hideBalance;
              });
            },
          ),
          const SizedBox(height: 24),
          // Menu Options
          const ModuleTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Conta',
            subtitle: 'Dados da conta e saldo',
            routeName: AppRoutes.account,
          ),
          const ModuleTile(
            icon: Icons.swap_horiz,
            title: 'Transações',
            subtitle: 'Entradas, saídas e histórico',
            routeName: AppRoutes.transactions,
          ),
          const ModuleTile(
            icon: Icons.pix,
            title: 'Pix',
            subtitle: 'Chaves, pagamentos e transferências',
            routeName: AppRoutes.pix,
          ),
          const ModuleTile(
            icon: Icons.credit_card,
            title: 'Cartões',
            subtitle: 'Cartão virtual e limites',
            routeName: AppRoutes.cards,
          ),
          const ModuleTile(
            icon: Icons.login,
            title: 'Entrar',
            subtitle: 'Acesso do cliente',
            routeName: AppRoutes.login,
          ),
          ],
        ),
      ),
    );
  }
}
