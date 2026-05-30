import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/screens/auth/login_screen.dart';
import 'package:flutter_aplication_bank/screens/auth/login/singin_screen.dart';
import 'package:flutter_aplication_bank/screens/auth/register/register_screen.dart';
import 'package:flutter_aplication_bank/screens/home/home_screen.dart';
import 'package:flutter_aplication_bank/screens/quotes/quotes_screen.dart';
import 'package:flutter_aplication_bank/screens/transfer/transfer_screen.dart';
import 'package:flutter_aplication_bank/screens/receipt/receipt_screen.dart';
import 'package:flutter_aplication_bank/screens/transactions/transactions_screen.dart';
import 'package:flutter_aplication_bank/screens/transactions/transactions_history_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/pix_area_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/scan_qr_screen.dart';
import 'package:flutter_aplication_bank/screens/pix/my_qr_code_screen.dart';
import 'package:flutter_aplication_bank/screens/profile/edit_profile_screen.dart';
import 'package:flutter_aplication_bank/screens/profile/profile_screen.dart';
import 'package:flutter_aplication_bank/screens/settings/change_password_screen.dart';
import 'package:flutter_aplication_bank/screens/settings/language_screen.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_screen.dart';
import 'package:flutter_aplication_bank/screens/account/payments_screen.dart';
import 'package:flutter_aplication_bank/screens/account/account_screen.dart';
import 'package:flutter_aplication_bank/screens/cards/cards_screen.dart';
import 'package:flutter_aplication_bank/screens/loading_screen.dart';
import 'package:flutter_aplication_bank/screens/feedback_screen.dart';
import 'package:flutter_aplication_bank/screens/pay/pay_screen.dart';
import 'package:flutter_aplication_bank/screens/oneboarding/oneboarding_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String pay = '/pay';
  static const String oneboarding = '/oneboarding';
  static const String login = '/login';
  static const String signIn = '/sign-in';
  static const String register = '/register';
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
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String language = '/language';
  static const String payments = '/payments';
  static const String account = '/account';
  static const String transactions = '/transactions';
  static const String pix = '/pix';
  static const String cards = '/cards';
  static const String loading = '/loading';
  static const String feedback = '/feedback';

  static Map<String, WidgetBuilder> get routes {
    return {
      pay: (_) => const PayScreen(),
      oneboarding: (_) => const OneboardingScreen(),
      login: (_) => const LoginScreen(),
      signIn: (_) => const SingInScreen(),
      register: (_) => const RegisterScreen(),
      home: (_) => const HomeScreen(),
      quotes: (_) => const QuotesScreen(),
      transfer: (context) {
        final section = ModalRoute.of(context)?.settings.arguments as String?;
        return TransferScreen(initialSection: section ?? 'Escanear');
      },
      receipt: (_) => const ReceiptScreen(),
      transactionsHistory: (_) => const TransactionsHistoryScreen(),
      account: (_) => const AccountScreen(),
      transactions: (_) => const TransactionsScreen(),
      pix: (_) => const PixAreaScreen(),
      cards: (_) => const CardsScreen(),
      pixArea: (_) => const PixAreaScreen(),
      scanQr: (_) => const ScanQRScreen(),
      myQrCode: (_) => const MyQRCodeScreen(),
      profile: (_) => const ProfileScreen(),
      settings: (_) => const SettingsScreen(),
      editProfile: (_) => const EditProfileScreen(),
      changePassword: (_) => const ChangePasswordScreen(),
      language: (_) => const LanguageScreen(),
      payments: (_) => const PaymentsScreen(),
      loading: (_) => const LoadingScreen(),
      feedback: (_) => const FeedbackScreen(),
    };
  }
}
