import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/models/user_profile.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:flutter_aplication_bank/widgets/common_widgets.dart';
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

  Future<void> _pickBirthDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentBirthDate(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: profileBlue,
              surface: profileInput,
              onSurface: profileText,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: profileInput),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _dayController.text = pickedDate.day.toString().padLeft(2, '0');
      _monthController.text = _monthName(pickedDate.month);
      _yearController.text = pickedDate.year.toString();
    });
  }

  DateTime _currentBirthDate() {
    final day = int.tryParse(_dayController.text.trim()) ?? 28;
    final month = _monthNumber(_monthController.text.trim()) ?? 9;
    final year = int.tryParse(_yearController.text.trim()) ?? 2000;

    return DateTime(year, month, day);
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
              ProfileAvatar(radius: 64, imageUrl: profile?.fotoPerfil ?? ''),
              const SizedBox(height: 22),
              Text(
                profile?.nome ?? 'Carregando...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: profileText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 36),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ProfileSmallField(
                      controller: _dayController,
                      onTap: _pickBirthDate,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ProfileSmallField(
                      controller: _monthController,
                      onTap: _pickBirthDate,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ProfileSmallField(
                      controller: _yearController,
                      onTap: _pickBirthDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _pickBirthDate,
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: profileBlue,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                _joinedAt(profile),
                style: const TextStyle(
                  color: profileMutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              CustomButton(
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
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: profileMutedText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(icon, color: profileMutedText, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  cursorColor: profileBlue,
                  style: const TextStyle(color: profileText, fontSize: 16),
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
  const ProfileSmallField({required this.controller, this.onTap, super.key});

  final TextEditingController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      readOnly: onTap != null,
      onTap: onTap,
      cursorColor: profileBlue,
      style: const TextStyle(color: profileText, fontSize: 16),
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

String _monthName(int month) {
  const months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  return months[month - 1];
}

int? _monthNumber(String monthName) {
  const months = {
    'janeiro': 1,
    'jan': 1,
    'fevereiro': 2,
    'fev': 2,
    'março': 3,
    'marco': 3,
    'mar': 3,
    'abril': 4,
    'abr': 4,
    'maio': 5,
    'mai': 5,
    'junho': 6,
    'jun': 6,
    'julho': 7,
    'jul': 7,
    'agosto': 8,
    'ago': 8,
    'setembro': 9,
    'set': 9,
    'outubro': 10,
    'out': 10,
    'novembro': 11,
    'nov': 11,
    'dezembro': 12,
    'dez': 12,
  };

  return months[monthName.toLowerCase()];
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
