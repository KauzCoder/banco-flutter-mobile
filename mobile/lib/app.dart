import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/constants/app_constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/core/theme/app_theme.dart';
import 'package:flutter_aplication_bank/screens/home/home_screen.dart';

class BancoDigitalApp extends StatelessWidget {
  const BancoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
<<<<<<< HEAD
      initialRoute: AppRoutes.oneboarding,
=======
      initialRoute: AppRoutes.login,
>>>>>>> origin/frontend-neto
      routes: AppRoutes.routes,
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(builder: (_) => HomeScreen());
      },
    );
  }
}