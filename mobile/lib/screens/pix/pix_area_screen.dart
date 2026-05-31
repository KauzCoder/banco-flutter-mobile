import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PixAreaScreen extends StatelessWidget {
  const PixAreaScreen({super.key});

  static const _lime = Color(0xFFDDFF32);
  static const _card = Color(0xFF160E24);
  static const _cardBorder = Color(0xFF5E516F);
  static const _muted = Color(0xFFAAA7B2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppScreenHeader(
                title: 'Area Pix',
                onBackPressed: () => Navigator.maybePop(context),
                horizontalPadding: 0,
                verticalPadding: 0,
              ),
              const SizedBox(height: 60),
              _buildGrid(context),
              const SizedBox(height: 54),
              _buildSecurityBanner(),
              const SizedBox(height: 46),
              _buildShortcuts(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final actions = [
      _PixAction(
        iconAsset: 'assets/svgs/tranferir.svg',
        label: 'Transferir',
        onTap: () => Navigator.pushNamed(context, AppRoutes.transfer),
      ),
      _PixAction(
        iconAsset: 'assets/svgs/depositar.svg',
        label: 'Ler QR Code',
        onTap: () => Navigator.pushNamed(context, AppRoutes.scanQr),
      ),
      _PixAction(
        iconAsset: 'assets/svgs/pix-copia-e-cola.svg',
        label: 'Pix Copia\ne Cola',
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.transfer,
          arguments: 'Digitar',
        ),
      ),
      _PixAction(
        iconAsset: 'assets/svgs/cobrar.svg',
        label: 'Cobrar',
        onTap: () => Navigator.pushNamed(context, AppRoutes.transfer),
      ),
      _PixAction(
        iconAsset: 'assets/svgs/pix-agendado.svg',
        label: 'Pix Agendado',
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.underDevelopment,
          arguments: 'Pix Agendado',
        ),
      ),
      _PixAction(
        iconAsset: 'assets/svgs/cobrar.svg',
        label: 'Cobrar',
        onTap: () => Navigator.pushNamed(context, AppRoutes.transfer),
      ),
    ];

    return Wrap(
      spacing: 25.25,
      runSpacing: 34,
      children: actions
          .map(
            (action) =>
                _PixActionTile(action: action, width: 99.5, height: 108),
          )
          .toList(),
    );
  }

  Widget _buildSecurityBanner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: SvgPicture.asset(
            'assets/svgs/solar_shield-bold-duotone.svg',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 28),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'A seguranca e fundamental durante\nsuas transacoes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Voce pode ter certeza de que seus dados estao\nprotegidos em tempo real, garantindo\ntransacoes seguras e confiaveis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortcuts(BuildContext context) {
    final shortcuts = [
      _PixShortcut(
        iconAsset: 'assets/svgs/minhas-chaves.svg',
        title: 'Minha chaves Pix',
        subtitle: 'Gerencie suas chaves e preferencias',
        onTap: () => _showPixKeysModal(context),
      ),
      _PixShortcut(
        iconAsset: 'assets/svgs/meus-limites.svg',
        title: 'Meus Limites',
        subtitle: 'Consulte e gerencie seus limites',
        onTap: () => Navigator.pushNamed(context, AppRoutes.account),
      ),
      _PixShortcut(
        iconAsset: 'assets/svgs/pix-automatico.svg',
        title: 'Pix automatico',
        subtitle: 'Gerencie suas chaves e preferencias',
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.underDevelopment,
          arguments: 'Pix automatico',
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atalhos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 24),
        ...shortcuts.map(
          (shortcut) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _PixShortcutTile(shortcut: shortcut),
          ),
        ),
      ],
    );
  }

  void _showPixKeysModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1040),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas Chaves PIX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _pixKeyTile('Email', 'ana.lima@example.com'),
            _pixKeyTile('Telefone', '+55 11 99999-0001'),
            _pixKeyTile('CPF', '111.222.333-44'),
            _pixKeyTile('Aleatoria', 'a1b2c3d4-e5f6-7g8h-9i0j'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _pixKeyTile(String type, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A45), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    color: Color(0xFF8A8AA8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF22C55E),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _PixAction {
  const _PixAction({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;
}

class _PixActionTile extends StatelessWidget {
  const _PixActionTile({
    required this.action,
    required this.width,
    required this.height,
  });

  final _PixAction action;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            decoration: BoxDecoration(
              color: PixAreaScreen._card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: PixAreaScreen._cardBorder, width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x551D0C36),
                  blurRadius: 16,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: SvgPicture.asset(
                      action.iconAsset,
                      colorFilter: const ColorFilter.mode(
                        PixAreaScreen._lime,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PixShortcut {
  const _PixShortcut({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _PixShortcutTile extends StatelessWidget {
  const _PixShortcutTile({required this.shortcut});

  final _PixShortcut shortcut;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: shortcut.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 65,
          decoration: BoxDecoration(
            color: PixAreaScreen._card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PixAreaScreen._cardBorder, width: 1.1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 41,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5626A1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF8C55E8),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      shortcut.iconAsset,
                      colorFilter: const ColorFilter.mode(
                        PixAreaScreen._lime,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shortcut.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shortcut.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
