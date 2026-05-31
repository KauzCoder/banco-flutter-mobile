import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _senhaVisivel = false;
  String? _erro;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      await AuthService.register(
        _nomeController.text.trim(),
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      setState(() => _erro = 'Erro ao criar conta. Verifique os dados informados.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF4B2C8C),
              Color(0xFFB570FF),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Crie uma conta',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Faça login com segurança na sua conta',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  _buildInputField('Nome completo', Icons.person_outline, controller: _nomeController),
                  _buildInputField('Endereço de e-mail', Icons.email_outlined, controller: _emailController),
                  _buildPhoneField(),
                  _buildSenhaField(),
                  if (_erro != null) ...[
                    const SizedBox(height: 4),
                    Text(_erro!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C3FE3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Crie uma Conta',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signIn),
                      child: RichText(
                        text: const TextSpan(children: [
                          TextSpan(text: 'Eu já tenho uma conta ', style: TextStyle(color: Colors.white54)),
                          TextSpan(
                            text: 'Entrar',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSenhaField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _senhaController,
        obscureText: !_senhaVisivel,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Senha',
          hintStyle: const TextStyle(color: Colors.black45),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6C3FE3)),
          suffixIcon: IconButton(
            icon: Icon(
              _senhaVisivel ? Icons.visibility : Icons.visibility_off,
              color: Colors.black26,
            ),
            onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black45),
          prefixIcon: Icon(icon, color: const Color(0xFF6C3FE3)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        keyboardType: TextInputType.phone,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Digite o número',
          hintStyle: const TextStyle(color: Colors.black45),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇧🇷', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text('+55', style: TextStyle(color: Color(0xFF6C3FE3), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}