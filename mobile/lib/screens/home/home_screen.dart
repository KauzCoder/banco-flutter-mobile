import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/constants/app_constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/cards/module_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo disponível',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ 0,00',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
            routeName: AppRoutes.receipt,
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
    );
  }
}