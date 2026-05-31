import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final profile = controller.profile;

        return ProfileScaffold(
          title: 'Perfil',
          trailing: ProfileRoundButton(
            icon: Icons.manage_accounts_outlined,
            color: Colors.transparent,
            iconColor: profileBlue,
            borderColor: profileBlue,
            onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ProfileAvatar(
                    radius: 70,
                    imageUrl: profile?.fotoPerfil ?? '',
                  ),
                  const SizedBox(width: 44),
                  Expanded(
                    child: Text(
                      profile?.nome ?? 'Carregando...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: profileText,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              ProfileMenuRow(
                icon: Icons.account_circle_outlined,
                title: 'Informações Pessoais',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.editProfile),
              ),
              ProfileMenuRow(
                icon: Icons.wallet_outlined,
                title: 'Preferências de Pagamento',
                onTap: () {},
              ),
              ProfileMenuRow(
                icon: Icons.credit_card_rounded,
                title: 'Bancos e Cartões',
                onTap: () {},
              ),
              ProfileMenuRow(
                icon: Icons.notifications_none_rounded,
                title: 'Notificações',
                badge: 2,
                showChevron: false,
                onTap: () {},
              ),
              ProfileMenuRow(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Central de Mensagens',
                onTap: () {},
              ),
              ProfileMenuRow(
                icon: Icons.location_on_outlined,
                title: 'Endereço',
                onTap: () {},
              ),
              ProfileMenuRow(
                icon: Icons.settings_outlined,
                title: 'Configurações',
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
            ],
          ),
        );
      },
    );
  }
}
