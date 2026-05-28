import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/screens/auth/login_screen.dart';
import 'package:flutter_aplication_bank/screens/home/home_screen.dart';
import 'package:flutter_aplication_bank/screens/quotes/quotes_screen.dart';
import 'package:flutter_aplication_bank/screens/transfer/transfer_screen.dart';
import 'package:flutter_aplication_bank/screens/receipt/receipt_screen.dart';
import 'package:flutter_aplication_bank/screens/transactions/transactions_screen.dart';
import 'package:flutter_aplication_bank/screens/transactions/transactions_history_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/pix_area_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/scan_qr_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/my_qr_code_screen.dart';
import 'package:flutter_aplication_bank/screens/profile/profile_screen.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_screen.dart';
import 'package:flutter_aplication_bank/screens/settings/change_password_screen.dart';
import 'package:flutter_aplication_bank/screens/settings/language_screen.dart';
import 'package:flutter_aplication_bank/screens/account/payments_screen.dart';
import 'package:flutter_aplication_bank/screens/account/account_screen.dart';
import 'package:flutter_aplication_bank/screens/cards/cards_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/pix_screen.dart';
import 'package:flutter_aplication_bank/screens/loading_screen.dart';
import 'package:flutter_aplication_bank/screens/feedback_screen.dart';
import 'package:flutter_aplication_bank/screens/pay/pay_screen.dart';
import 'package:flutter_aplication_bank/screens/oneboarding/oneboarding_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String pay = '/pay';
  static const String oneboarding = '/oneboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String quotes = '/quotes';
  static const String transfer = '/transfer';
  static const String receipt = '/receipt';
  static const String transactionsHistory = '/transactions-history';
  static const String pixArea = '/pix-area';
  static const String scanQr = '/scan-qr';
  static const String myQrCode = '/my-qr-code';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String language = '/language';
  static const String payments = '/payments';
  static const String account = '/account';
  static const String transactions = '/transactions';
  static const String pix = '/pix';
  static const String cards = '/cards';
  static const String loading = '/loading';
  static const String feedback = '/feedback';
  static const String error = '/error';

  static Map<String, WidgetBuilder> get routes {
    return {
      pay: (_) => const PayScreen(),
      oneboarding: (_) => const OneboardingScreen(),
      login: (_) => const LoginScreen(),
      home: (_) => const HomeScreen(),
      quotes: (_) => const QuotesScreen(),
      transfer: (_) => const TransferScreen(),
      receipt: (_) => const ReceiptScreen(),
      transactionsHistory: (_) => const TransactionsHistoryScreen(),
      account: (_) => const AccountScreen(),
      transactions: (_) => const TransactionsScreen(),
      pix: (_) => const PixScreen(),
      cards: (_) => const CardsScreen(),
      pixArea: (_) => const PixAreaScreen(),
      scanQr: (_) => const ScanQRScreen(),
      myQrCode: (_) => const MyQRCodeScreen(),
      profile: (_) => const ProfileScreen(),
      settings: (_) => const SettingsScreen(),
      changePassword: (_) => const ChangePasswordScreen(),
      language: (_) => const LanguageScreen(),
      payments: (_) => const PaymentsScreen(),
      loading: (_) => const LoadingScreen(),
      feedback: (_) => const FeedbackScreen(),
      error: (_) => const ErrorScreen(message: 'Erro ao processar requisição'),
    };
  }
}