import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ComprovanteScreen extends StatelessWidget {
  ComprovanteScreen({super.key});

  static const String _nomeDestinatario = 'Rubens E. S Fragoso';
  static const String _chavePix = 'kaua****@gmail.com';
  static const String _dataHora = '23/05/2026 às 09:41';
  static const String _tipoTransacao = 'Pix';
  static const String _instituicao = 'Banco Exemplo';
  static const String _idTransacao = 'E16236120••••••3921';
  static const String _valor = 'R\$250,00';

  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _compartilharComprovante() async {
    final imagem = await _screenshotController.capture();
    if (imagem == null) return;

    final diretorio = await getTemporaryDirectory();
    final arquivo = File('${diretorio.path}/comprovante.png');
    await arquivo.writeAsBytes(imagem);

    await Share.shareXFiles(
      [XFile(arquivo.path)],
      subject: 'Comprovante Pix - $_valor',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        color: const Color(0xFF0D0D1A),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildHeroSection(),
                            const SizedBox(height: 24),
                            _buildDetailsCard(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildShareButton(),
                    const SizedBox(height: 12),
                    _buildHomeButton(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
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
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E35),
                  borderRadius: BorderRadius.circular(12),
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
            'Comprovante',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF2D1F5E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFF9B6FFF),
            size: 48,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Transação realizada',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'A sua transação foi concluída, Pix enviado com\nsucesso! Agradecemos pela sua confiança',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8A8AA8),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          _valor,
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141428),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2A2A45),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow('Para', _nomeDestinatario, isFirst: true),
          _buildDivider(),
          _buildDetailRow('Chave Pix', _chavePix),
          _buildDivider(),
          _buildDetailRow('Data e hora', _dataHora),
          _buildDivider(),
          _buildDetailRow('Tipo de transação', _tipoTransacao),
          _buildDivider(),
          _buildDetailRow('Instituição', _instituicao),
          _buildDivider(),
          _buildDetailRow('ID da transação', _idTransacao, isLast: true, isMono: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isFirst = false,
    bool isLast = false,
    bool isMono = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isFirst ? 16 : 12,
        bottom: isLast ? 16 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B6B8A),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: isMono ? 'monospace' : null,
                letterSpacing: isMono ? 0.3 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF2A2A45),
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _compartilharComprovante,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B3FE4),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Compartilhar comprovante',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF2A2A45), width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Voltar ao início',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}