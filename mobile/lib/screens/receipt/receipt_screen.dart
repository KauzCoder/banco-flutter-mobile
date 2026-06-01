import 'dart:io';

import 'package:cross_file/cross_file.dart' as cross_file;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/core/theme.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareReceipt(ReceiptData receipt) async {
    if (_isSharing) {
      return;
    }

    setState(() => _isSharing = true);

    try {
      final imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 80),
        pixelRatio: 2,
      );

      if (imageBytes == null || imageBytes.isEmpty) {
        throw Exception('Nao foi possivel gerar a imagem do comprovante.');
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/comprovante_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Comprovante ${receipt.type} - ${receipt.amount}',
          files: [cross_file.XFile(file.path, mimeType: 'image/png')],
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao compartilhar: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final receipt = ReceiptData.fromRouteArguments(
      ModalRoute.of(context)?.settings.arguments,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'Comprovante',
              onBackPressed: () => Navigator.maybePop(context),
              verticalPadding: 18,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 28),
                child: Column(
                  children: [
                    Screenshot(
                      controller: _screenshotController,
                      child: _ReceiptCard(receipt: receipt),
                    ),
                    const SizedBox(height: 22),
                    _ReceiptActionButton(
                      label: _isSharing
                          ? 'Preparando comprovante...'
                          : 'Compartilhar comprovante',
                      onPressed: _isSharing
                          ? null
                          : () => _shareReceipt(receipt),
                    ),
                    const SizedBox(height: 14),
                    _ReceiptActionButton(
                      label: 'Voltar ao início',
                      outlined: true,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final ReceiptData receipt;
  static const double _iconWidth = 168;
  static const double _iconHeight = 204;
  static const double _cardTopGap = 108;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: _cardTopGap),
          padding: const EdgeInsets.fromLTRB(24, 102, 24, 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF6E607F)),
            gradient: const LinearGradient(
              colors: [Color(0xFF180532), Color(0xFF0B0614), Color(0xFF08050D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Transação realizada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'A sua transação foi concluída, Pix enviado com sucesso! '
                'Agradecemos pela sua confiança',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.55,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 42),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  receipt.amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 46),
              const Divider(color: Color(0xFF837A8D), thickness: 1),
              const SizedBox(height: 20),
              _ReceiptDetailRow(label: 'Para', value: receipt.receiverName),
              _ReceiptDetailRow(label: 'Chave Pix', value: receipt.pixKey),
              _ReceiptDetailRow(label: 'Data e hora', value: receipt.dateTime),
              _ReceiptDetailRow(
                label: 'Tipo de transação',
                value: receipt.type,
              ),
              _ReceiptDetailRow(
                label: 'Instituição',
                value: receipt.institution,
              ),
              _ReceiptDetailRow(
                label: 'ID da transação',
                value: receipt.transactionId,
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: _ReceiptSuccessIcon(width: _iconWidth, height: _iconHeight),
        ),
      ],
    );
  }
}

class _ReceiptSuccessIcon extends StatelessWidget {
  const _ReceiptSuccessIcon({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        'assets/svgs/receipt-success.svg',
        fit: BoxFit.contain,
        placeholderBuilder: (_) => const Center(
          child: Icon(
            Icons.receipt_long_rounded,
            color: AppColors.primaryLight,
            size: 88,
          ),
        ),
      ),
    );
  }
}

class _ReceiptDetailRow extends StatelessWidget {
  const _ReceiptDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 7,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptActionButton extends StatelessWidget {
  const _ReceiptActionButton({
    required this.label,
    this.onPressed,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: outlined
              ? const Color(0xFF32176C)
              : AppColors.primaryLight,
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class ReceiptData {
  const ReceiptData({
    required this.amount,
    required this.receiverName,
    required this.pixKey,
    required this.dateTime,
    required this.type,
    required this.institution,
    required this.transactionId,
  });

  final String amount;
  final String receiverName;
  final String pixKey;
  final String dateTime;
  final String type;
  final String institution;
  final String transactionId;

  factory ReceiptData.fromRouteArguments(Object? arguments) {
    if (arguments is ReceiptData) {
      return arguments;
    }

    if (arguments is Map<String, dynamic>) {
      return ReceiptData(
        amount: _stringValue(arguments['amount'], fallback.amount),
        receiverName: _stringValue(
          arguments['receiverName'] ?? arguments['recipient'],
          fallback.receiverName,
        ),
        pixKey: _stringValue(arguments['pixKey'], fallback.pixKey),
        dateTime: _stringValue(arguments['dateTime'], fallback.dateTime),
        type: _stringValue(arguments['type'], fallback.type),
        institution: _stringValue(
          arguments['institution'],
          fallback.institution,
        ),
        transactionId: _stringValue(
          arguments['transactionId'],
          fallback.transactionId,
        ),
      );
    }

    return fallback;
  }

  static const fallback = ReceiptData(
    amount: 'R\$ 0,00',
    receiverName: 'Nao informado',
    pixKey: 'Nao informado',
    dateTime: 'Nao informado',
    type: 'Pix',
    institution: 'Quantum Bank',
    transactionId: 'Nao informado',
  );

  static String _stringValue(Object? value, String fallbackValue) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallbackValue : text;
  }
}

class ReceiptArguments {
  const ReceiptArguments({
    required this.amount,
    required this.receiverName,
    required this.pixKey,
    required this.dateTime,
    required this.type,
    required this.institution,
    required this.transactionId,
  });

  final String amount;
  final String receiverName;
  final String pixKey;
  final String dateTime;
  final String type;
  final String institution;
  final String transactionId;

  factory ReceiptArguments.fromTransaction(TransactionModel transaction) {
    return ReceiptArguments(
      amount:
          'R\$ ${transaction.amount.abs().toStringAsFixed(2).replaceAll('.', ',')}',
      receiverName: transaction.title.trim().isEmpty
          ? 'Nao informado'
          : transaction.title,
      pixKey: transaction.recipientKey.trim().isEmpty
          ? 'Nao informado'
          : transaction.recipientKey,
      dateTime: _formatDateTime(transaction.dateTime),
      type: _formatType(transaction.type),
      institution: 'Quantum Bank',
      transactionId: transaction.id.trim().isEmpty
          ? 'Nao informado'
          : transaction.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'receiverName': receiverName,
      'pixKey': pixKey,
      'dateTime': dateTime,
      'type': type,
      'institution': institution,
      'transactionId': transactionId,
    };
  }

  static String _formatType(String type) {
    return switch (type.toLowerCase()) {
      'pix' => 'Pix',
      'entrada' => 'Entrada',
      'pagamento' => 'Pagamento',
      'transferencia' => 'Transferencia',
      _ => 'Pix',
    };
  }

  static String _formatDateTime(DateTime? value) {
    if (value == null) {
      return 'Nao informado';
    }

    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year as $hour:$minute';
  }
}
