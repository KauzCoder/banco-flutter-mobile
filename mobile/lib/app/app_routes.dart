import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/features/account/presentation/pages/account_page.dart';
import 'package:flutter_aplication_bank/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_aplication_bank/features/cards/presentation/pages/cards_page.dart';
import 'package:flutter_aplication_bank/features/home/presentation/pages/home_page.dart';
import 'package:flutter_aplication_bank/features/pix/presentation/pages/pix_page.dart';
import 'package:flutter_aplication_bank/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_aplication_bank/features/transactions/presentation/pages/transactions_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const login = '/login';
  static const account = '/account';
  static const transactions = '/transactions';
  static const pix = '/pix';
  static const cards = '/cards';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (_) => const HomePage(),
      login: (_) => const LoginPage(),
      account: (_) => const AccountPage(),
      transactions: (_) => const TransactionsPage(),
      pix: (_) => const PixPage(),
      cards: (_) => const CardsPage(),
      profile: (_) => const ProfilePage(),
    };
  }
}
