import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  bool _filledInitialData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.watch<ProfileController>().profile;
    if (!_filledInitialData && profile != null) {
      _nameController.text = profile.nome;
      _emailController.text = profile.email;
      _phoneController.text = profile.telefone;
      _dayController.text = profile.dataNascimentoDia;
      _monthController.text = profile.dataNascimentoMes;
      _yearController.text = profile.dataNascimentoAno;
      _filledInitialData = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _save(ProfileController controller) async {
    final current = controller.profile;
    if (current == null) {
      return;
    }

    final nextProfile = current.copyWith(
      nome: _nameController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _phoneController.text.trim(),
      dataNascimentoDia: _dayController.text.trim(),
      dataNascimentoMes: _monthController.text.trim(),
      dataNascimentoAno: _yearController.text.trim(),
    );

    await controller.updateProfile(nextProfile);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado localmente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final profile = controller.profile;

        return ProfileScaffold(
          title: 'Meu Perfil',
          child: Column(
            children: [
              ProfileAvatar(radius: 90, imageUrl: profile?.fotoPerfil ?? ''),
              const SizedBox(height: 34),
              Text(
                profile?.nome ?? 'Carregando...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: profileText,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 64),
              ProfileEditField(
                label: 'Nome Completo',
                icon: Icons.account_circle_outlined,
                controller: _nameController,
              ),
              ProfileEditField(
                label: 'Endereço de E-mail',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              ProfileEditField(
                label: 'Número de Telefone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data de Nascimento',
                  style: TextStyle(
                    color: profileMutedText,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProfileSmallField(controller: _dayController),
                  ),
                  const SizedBox(width: 44),
                  Expanded(
                    child: ProfileSmallField(controller: _monthController),
                  ),
                  const SizedBox(width: 44),
                  Expanded(
                    child: ProfileSmallField(controller: _yearController),
                  ),
                ],
              ),
              const SizedBox(height: 86),
              Text(
                _joinedAt(profile),
                style: const TextStyle(
                  color: profileMutedText,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 36),
              ProfilePrimaryButton(
                label: 'Salvar',
                isLoading: controller.isSubmitting,
                onPressed: () => _save(controller),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileEditField extends StatelessWidget {
  const ProfileEditField({
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType,
    super.key,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: profileMutedText,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(icon, color: profileMutedText, size: 32),
              const SizedBox(width: 24),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  cursorColor: profileBlue,
                  style: const TextStyle(color: profileText, fontSize: 22),
                  decoration: const InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: profileDivider, height: 1),
        ],
      ),
    );
  }
}

class ProfileSmallField extends StatelessWidget {
  const ProfileSmallField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      cursorColor: profileBlue,
      style: const TextStyle(color: profileText, fontSize: 22),
      decoration: const InputDecoration(
        filled: false,
        fillColor: Colors.transparent,
        isDense: true,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: profileDivider),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: profileDivider),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: profileBlue),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: profileDivider),
        ),
        contentPadding: EdgeInsets.only(bottom: 12),
      ),
    );
  }
}

String _joinedAt(UserProfile? profile) {
  final date = profile?.dataCriacao;
  if (date == null) {
    return 'Entrou em 28 de Jan de 2021';
  }

  const months = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  return 'Entrou em ${date.day} de ${months[date.month - 1]} de ${date.year}';
}
