import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/app/app_routes.dart';
import 'package:flutter_aplication_bank/app/app_theme.dart';
import 'package:flutter_aplication_bank/core/constants/app_constants.dart';
import 'package:flutter_aplication_bank/features/home/presentation/pages/home_page.dart';

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(builder: (_) => const HomePage());
      },
    );
  }
}
