import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _senhaController = TextEditingController();
  LastLoginUser? _lastUser;
  bool _isLoading = false;
  bool _isLoadingUser = true;
  bool _senhaVisivel = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _loadLastUser();
  }

  Future<void> _loadLastUser() async {
    final lastUser = await AuthService.getLastLoginUser();

    if (!mounted) {
      return;
    }

    setState(() {
      _lastUser = lastUser;
      _isLoadingUser = false;
    });
  }

  Future<void> _login() async {
    final user = _lastUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
      return;
    }

    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      await AuthService.login(user.email, _senhaController.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
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
            : 'Senha incorreta. Tente novamente.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _isLoadingUser
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF813DFF),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 58),
                        if (_lastUser == null)
                          _buildNoSavedUser()
                        else ...[
                          _buildUserCard(_lastUser!),
                          const SizedBox(height: 14),
                          _buildPasswordField(),
                          if (_erro != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _erro!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 50),
                          _buildPrimaryButton(),
                          const SizedBox(height: 22),
                          _buildForgotPasswordButton(),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/icon-app.png',
          width: 78,
          height: 78,
        ),
        const SizedBox(width: 20),
        const Text(
          'QUANTUM',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(LastLoginUser user) {
    return Container(
      height: 78,
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF51269A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF813DFF), width: 1.4),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE9E9EE),
            backgroundImage:
                (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty)
                ? NetworkImage(user.fotoPerfil!)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user.maskedDocument,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFE1D7F8),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.signIn),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFC4A8FF), width: 1),
              minimumSize: const Size(92, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'Trocar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _senhaController,
      obscureText: !_senhaVisivel,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _login(),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        hintText: 'Senha',
        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
        suffixIcon: IconButton(
          icon: Icon(
            _senhaVisivel ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
          onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 22,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF813DFF), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF813DFF), width: 1.8),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF813DFF),
          disabledBackgroundColor: const Color(
            0xFF813DFF,
          ).withValues(alpha: 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.6,
                ),
              )
            : const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF32176C),
          side: const BorderSide(color: Color(0xFF813DFF), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Esqueci minha senha',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildNoSavedUser() {
    return Column(
      children: [
        const Text(
          'Nenhum usuario salvo neste aparelho.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        const SizedBox(height: 22),
        _buildPrimaryFullLoginButton(),
      ],
    );
  }

  Widget _buildPrimaryFullLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.signIn),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF813DFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Fazer login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
