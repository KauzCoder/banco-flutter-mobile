import 'package:flutter/material.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF141318), Color(0xFF322A45)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text("Login", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const Text("Faça login com segurança na sua conta", style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 40),
              
              _buildInputField("Endereço de e-mail", Icons.email_outlined),
              _buildInputField("Senha", Icons.lock_outline, obscure: true, suffix: Icons.remove_red_eye_outlined),
              
              Row(
                children: [
                  Checkbox(value: false, onChanged: (_) {}, side: const BorderSide(color: Colors.white54)),
                  const Text("Lembrar-me", style: TextStyle(color: Colors.white54)),
                ],
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C3FE3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("ENTRAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: TextButton(onPressed: () {}, child: const Text("Esqueci minha senha", style: TextStyle(color: Color(0xFF6C3FE3))))),
              const SizedBox(height: 20),
              const Center(child: Text("- OU continuar com -", style: TextStyle(color: Colors.white54))),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildSocialButton("Google", Icons.g_mobiledata)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSocialButton("Facebook", Icons.facebook)),
                ],
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: RichText(text: const TextSpan(children: [TextSpan(text: "Criar uma conta ", style: TextStyle(color: Colors.white)), TextSpan(text: "Registrar-se", style: TextStyle(color: Color(0xFF6C3FE3), fontWeight: FontWeight.bold))])),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Ao clicar em Continuar, você concorda com nossos Termos de Serviço e Política de Privacidade", textAlign: TextAlign.center, style: TextStyle(color: Colors.white30, fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, IconData icon, {bool obscure = false, IconData? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white54),
          suffixIcon: suffix != null ? Icon(suffix, color: Colors.white54) : null,
          filled: true, fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54), padding: const EdgeInsets.symmetric(vertical: 12)),
    );
  }
}