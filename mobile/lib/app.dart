import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_bank/controllers/quote_controller.dart';
import 'package:flutter_aplication_bank/controllers/transfer_controller.dart';
import 'package:flutter_aplication_bank/core/constants/app_constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/core/theme/app_theme.dart';
import 'package:flutter_aplication_bank/screens/home/home_screen.dart';

class BancoDigitalApp extends StatelessWidget {
  const BancoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuoteController()),
        ChangeNotifierProvider(create: (_) => TransferController()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.oneboarding,
        routes: AppRoutes.routes,
        onUnknownRoute: (_) {
          return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
        },
      ),
    );
  }
}