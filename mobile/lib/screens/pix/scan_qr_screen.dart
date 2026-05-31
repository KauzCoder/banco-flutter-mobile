import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  String _selected = 'ler';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: Center(child: _buildScanFrame())),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const Text(
            'Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.image_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFrame() {
    final size = 220.0;
    final cornerSize = 32.0;
    final cornerWidth = 3.5;
    final color = Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: true,
              left: true,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: true,
              left: false,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: false,
              left: true,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(
              color,
              cornerSize,
              cornerWidth,
              top: false,
              left: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(
    Color color,
    double size,
    double width, {
    required bool top,
    required bool left,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: width) : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: width)
              : BorderSide.none,
          left: left ? BorderSide(color: color, width: width) : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: width)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(10) : Radius.zero,
          topRight: top && !left ? const Radius.circular(10) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(10) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(10) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final isLer = _selected == 'ler';
    final isMeu = _selected == 'meucodigo';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.darkBorder, width: 1),
        ),
        child: Row(
          children: [
            // Botão Ler
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _selected = 'ler'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    color: isLer ? const Color(0xFFDDFA46) : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Ler',
                    style: TextStyle(
                      color: isLer ? const Color(0xFF552F9F) : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Botão Meu Codigo
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() => _selected = 'meucodigo');
                  Navigator.pushNamed(context, AppRoutes.myQrCode);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 52,
                  decoration: BoxDecoration(
                    color: isMeu ? const Color(0xFFDDFA46) : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Meu Codigo',
                    style: TextStyle(
                      color: isMeu ? const Color(0xFF552F9F) : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
