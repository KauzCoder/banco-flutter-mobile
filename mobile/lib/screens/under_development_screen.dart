import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  const UnderDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
          child: Column(
            children: [
              AppScreenHeader(
                title: title ?? 'Recurso',
                onBackPressed: () => Navigator.maybePop(context),
                horizontalPadding: 0,
                verticalPadding: 0,
              ),
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBFF2F),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  color: Color(0xFF4D168F),
                  size: 48,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Esse recurso ainda esta em desenvolvimento',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Estamos preparando essa funcionalidade para uma proxima versao.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA4A4AE),
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.maybePop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
