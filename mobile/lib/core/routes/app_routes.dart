import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/screens/account/account_screen.dart';
import 'package:flutter_aplication_bank/screens/auth/login_screen.dart';
import 'package:flutter_aplication_bank/screens/cards/cards_screen.dart';
import 'package:flutter_aplication_bank/screens/home/home_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/pix_screen.dart';
import 'package:flutter_aplication_bank/screens/profile/profile_screen.dart';
import 'package:flutter_aplication_bank/screens/transactions/transactions_screen.dart';

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
      home: (_) => const HomeScreen(),
      login: (_) => const LoginScreen(),
      account: (_) => const AccountScreen(),
      transactions: (_) => const TransactionsScreen(),
      pix: (_) => const PixScreen(),
      cards: (_) => const CardsScreen(),
      profile: (_) => const ProfileScreen(),
    };
  }
}
