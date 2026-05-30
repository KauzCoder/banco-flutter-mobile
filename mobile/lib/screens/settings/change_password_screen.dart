import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/profile_controller.dart';
import 'package:flutter_aplication_bank/screens/settings/settings_widgets.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showNewPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(ProfileController controller) async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack('Preencha todos os campos.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnack('As duas senhas devem coincidir.');
      return;
    }

    await controller.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!mounted) {
      return;
    }

    _showSnack('Senha alterada localmente.');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        return ProfileScaffold(
          title: 'Alterar Senha',
          child: Column(
            children: [
              PasswordLineField(
                label: 'Senha Atual',
                controller: _currentPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 34),
              PasswordLineField(
                label: 'Nova Senha',
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => _showNewPassword = !_showNewPassword),
                  icon: Icon(
                    _showNewPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: profileMutedText,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              PasswordLineField(
                label: 'Confirmar Nova Senha',
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'As duas senhas devem coincidir',
                  style: TextStyle(
                    color: profileMutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              ProfilePrimaryButton(
                label: 'Alterar Senha',
                isLoading: controller.isSubmitting,
                onPressed: () => _submit(controller),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PasswordLineField extends StatelessWidget {
  const PasswordLineField({
    required this.label,
    required this.controller,
    required this.obscureText,
    this.suffix,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: profileMutedText,
              size: 34,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                cursorColor: profileBlue,
                style: const TextStyle(
                  color: profileText,
                  fontSize: 16,
                  letterSpacing: 4,
                ),
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            ?suffix,
          ],
        ),
        const Divider(color: profileDivider, height: 1),
      ],
    );
  }
}
