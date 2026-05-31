import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/controllers/transfer_controller.dart';
import 'package:flutter_aplication_bank/models/transfer_request.dart';

class TransferScreen extends StatefulWidget {
  final String initialSection;

  const TransferScreen({super.key, this.initialSection = 'Escanear'});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _recipientController = TextEditingController();
  final _messageController = TextEditingController();
  String _amount = '';
  String _selectedContact = 'Adicionar';
  String _selectedCard = 'Cartão 1';
  String _selectedCardNumber = '•••• 4587';

  final contacts = ['Adicionar', 'Maria', 'Jean', 'Ryan', 'Neto', 'Yan'];

  final List<Map<String, String>> _cards = [
    {'label': 'Cartão 1', 'number': '•••• 4587'},
    {'label': 'Cartão 2', 'number': '•••• 1234'},
  ];

  @override
  void dispose() {
    _recipientController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _appendAmount(String value) {
    setState(() {
      if (value == 'del') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else if (value == '000') {
        _amount += '000';
      } else {
        _amount += value;
      }
    });
  }

  String get _formattedAmount {
    if (_amount.isEmpty) return '0,00';
    final digits = _amount.replaceAll(',', '');
    final value = int.tryParse(digits) ?? 0;
    final formatted = (value / 100).toStringAsFixed(2).replaceAll('.', ',');
    return formatted;
  }

  double get _amountValue {
    final digits = _amount.replaceAll(',', '');
    final value = int.tryParse(digits) ?? 0;
    return value / 100;
  }

  void _showCardMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0D35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecionar Cartão',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ..._cards.map((card) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCard = card['label']!;
                  _selectedCardNumber = card['number']!;
                });
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedCard == card['label']
                      ? Colors.white.withAlpha(40)
                      : Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedCard == card['label']
                        ? AppColors.primary
                        : Colors.white.withAlpha(40),
                    width: _selectedCard == card['label'] ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                   Image.asset(
                      'assets/images/solar_card-2-bold.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(card['label']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text(card['number']!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    if (_selectedCard == card['label'])
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (_recipientController.text.isEmpty || _amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe destinatário e valor')),
      );
      return;
    }

    final request = TransferRequest(
      recipient: _recipientController.text.trim(),
      amount: _amountValue,
      message: _messageController.text.trim(),
      type: 'PIX',
    );

    try {
      await context.read<TransferController>().sendTransfer(request);
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.receipt);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF6C3FC7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        title: const Text(
          'Área Pix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            _buildPixAreaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPixAreaSection() {
    final transferController = context.watch<TransferController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Área PIX', style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: contacts.map((contact) {
              final isSelected = contact == _selectedContact;
              final isAdicionar = contact == 'Adicionar';
              return GestureDetector(
                onTap: () => setState(() => _selectedContact = contact),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 58,
                  child: Column(
                    children: [
                      isAdicionar
                          ? DashedCircle(
                              size: 58,
                              color: AppColors.darkTextSecondary,
                              child: Icon(
                                Icons.add,
                                color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                                size: 28,
                              ),
                            )
                          : Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.darkBgSecondary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.darkBorder),
                              ),
                              child: Center(
                                child: Text(
                                  contact.substring(0, 1),
                                  style: TextStyle(
                                    color: isSelected ? Colors.black : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 6),
                      Text(contact, style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        _InputField(
          label: 'Quem vai receber',
          hint: 'Nome, CPF/CNPJ ou Chave Pix',
          controller: _recipientController,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3D168C), Color(0xFF110626)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
            border: Border.all(
              color: Colors.white.withAlpha(40),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showCardMenu(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     Image.asset(
                        'assets/images/solar_card-2-bold.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedCardNumber,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'R\$ $_formattedAmount',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Valor',
                style: TextStyle(color: Colors.white.withAlpha((0.7 * 255).round()), fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InputField(
          label: '',
          hint: 'Escreva uma mensagem',
          controller: _messageController,
          prefixIcon: Image.asset(  
            'assets/images/chat_bubble_outline_rounded.png',
            width: 20,
            height: 20,
             ),
        ),
        const SizedBox(height: 20),
        _buildKeypad(),
        const SizedBox(height: 20),
        if (transferController.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              transferController.error!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        _buildTransferButton(transferController),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTransferButton(TransferController transferController) {
    return GestureDetector(
      onTap: _handlePayment,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: transferController.isSubmitting
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transferir',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Text(
                        'R\$ $_formattedAmount',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0', 'del'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0840), Color(0xFF0A0318)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(
          color: Colors.white.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: keys.map((key) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 96) / 3,
            height: 58,
            child: ElevatedButton(
              onPressed: () => _appendAmount(key),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.black,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                ),
              ),
              child: key == 'del'
                  ? const Icon(Icons.backspace_outlined, color: Colors.black)
                  : Text(
                      key,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DashedCircle extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;

  const DashedCircle({
    super.key,
    required this.size,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedCirclePainter(color: color),
        child: Center(child: child),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const dashCount = 20;
    const dashAngle = 2 * 3.14159 / dashCount;
    const gapFraction = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? prefixIcon;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _hasFocus = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onChanged);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final showHint = !hasText && !_hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (widget.label.isNotEmpty) const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          maxLines: 1,
          style: const TextStyle(color: AppColors.darkText),
          decoration: InputDecoration(
            hintText: showHint ? widget.hint : null,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            prefixIcon: widget.prefixIcon,
            filled: true,
            fillColor: AppColors.darkBgSecondary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            suffixIcon: hasText
                ? IconButton(
                    onPressed: () => widget.controller.clear(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFFA4A4AE), size: 22),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              borderSide: const BorderSide(color: AppColors.secondary, width: 1.3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              borderSide: const BorderSide(color: AppColors.secondary, width: 1.3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              borderSide: const BorderSide(color: AppColors.secondary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}