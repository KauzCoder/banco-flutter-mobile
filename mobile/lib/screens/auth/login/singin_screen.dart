import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool isChecked = false;
  bool _senhaVisivel = false;
  bool _isLoading = false;
  String? _erro;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      await AuthService.login(
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      final message = e.toString();
      final isNetworkError =
          message.contains('TimeoutException') ||
          message.contains('SocketException') ||
          message.contains('Connection refused') ||
          message.contains('Failed host lookup');

      setState(() {
        _erro = isNetworkError
            ? 'Nao foi possivel conectar ao nossos servicos, tente novamente mais tarde.'
            : 'E-mail ou senha incorretos.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF4B2C8C), Color(0xFFB570FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Faça login com segurança na sua conta',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  _buildEmailField(),
                  _buildSenhaField(),
                  if (_erro != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _erro!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) =>
                                setState(() => isChecked = value ?? false),
                            side: const BorderSide(color: Colors.white54),
                            checkColor: Colors.white,
                            activeColor: const Color(0xFF6C3FE3),
                          ),
                          const Text(
                            'Lembrar-se de mim',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Esqueci a senha',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C3FE3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'ENTRAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Criar uma conta ',
                              style: TextStyle(color: Colors.white54),
                            ),
                            TextSpan(
                              text: 'Registrar-se',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Endereço de e-mail',
          hintStyle: const TextStyle(color: Colors.black45),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: Color(0xFF6C3FE3),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
