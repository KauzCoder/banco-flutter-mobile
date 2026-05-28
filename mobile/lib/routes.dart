import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/quotes/quotes_screen.dart';
import 'screens/transfer/transfer_screen.dart';
import 'screens/receipt/receipt_screen.dart';
import 'screens/transactions/transactions_history_screen.dart';
import 'screens/pix/pix_area_screen.dart';
import 'screens/pix/scan_qr_screen.dart';
import 'screens/pix/my_qr_code_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/change_password_screen.dart';
import 'screens/settings/language_screen.dart';
import 'screens/account/payments_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/feedback_screen.dart';

class AppRoutes {
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
  static const String loading = '/loading';
  static const String feedback = '/feedback';
  static const String error = '/error';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      quotes: (context) => const QuotesScreen(),
      transfer: (context) => const TransferScreen(),
      receipt: (context) => const ReceiptScreen(),
      transactionsHistory: (context) => const TransactionsHistoryScreen(),
      pixArea: (context) => const PixAreaScreen(),
      scanQr: (context) => const ScanQRScreen(),
      myQrCode: (context) => const MyQRCodeScreen(),
      profile: (context) => const ProfileScreen(),
      settings: (context) => const SettingsScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      language: (context) => const LanguageScreen(),
      payments: (context) => const PaymentsScreen(),
      loading: (context) => const LoadingScreen(),
      feedback: (context) => const FeedbackScreen(),
      error: (context) => const ErrorScreen(message: 'Erro ao processar requisição'),
    };
  }
}
