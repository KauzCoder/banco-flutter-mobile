import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/transfer_data_controller.dart';
import 'package:flutter_aplication_bank/controllers/transfer_controller.dart';
import 'package:flutter_aplication_bank/core/constants.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/core/theme.dart';
import 'package:flutter_aplication_bank/models/credit_card_model.dart';
import 'package:flutter_aplication_bank/models/transfer_request.dart';
import 'package:flutter_aplication_bank/models/transfer_contact.dart';
import 'package:flutter_aplication_bank/screens/receipt/receipt_screen.dart';
import 'package:provider/provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, this.initialSection = 'Escanear'});

  final String initialSection;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _recipientController = TextEditingController();
  final _messageController = TextEditingController();

  String _amount = '';
  String _selectedContact = 'Adicionar';
  TransferContact? _selectedRecipient;
  CreditCardModel? _selectedCard;

  @override
  void initState() {
    super.initState();
    _recipientController.addListener(_onInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<TransferDataController>().load();
    });
  }

  @override
  void dispose() {
    _recipientController.removeListener(_onInputChanged);
    _recipientController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onInputChanged() => setState(() {});

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
    if (_amount.isEmpty) {
      return '0,00';
    }

    final value = int.tryParse(_amount) ?? 0;
    return (value / 100).toStringAsFixed(2).replaceAll('.', ',');
  }

  double get _amountValue {
    final value = int.tryParse(_amount) ?? 0;
    return value / 100;
  }

  bool get _canTransfer {
    final transferData = context.read<TransferDataController>();
    return !transferData.isLoading &&
        _recipientController.text.trim().isNotEmpty &&
        _amountValue > 0 &&
        _amountValue <= transferData.balance;
  }

  Future<void> _handlePayment() async {
    if (_recipientController.text.trim().isEmpty) {
      _showMessage('Informe quem vai receber.');
      return;
    }

    if (_amountValue <= 0) {
      _showMessage('O valor deve ser maior que zero.');
      return;
    }

    final transferData = context.read<TransferDataController>();
    if (_amountValue > transferData.balance) {
      _showMessage('Saldo insuficiente para transferencia.');
      return;
    }

    final request = TransferRequest(
      recipient: _recipientController.text.trim(),
      amount: _amountValue,
      message: _messageController.text.trim(),
      type: 'pix',
      cardId: _selectedCard?.id,
    );

    try {
      final transferController = context.read<TransferController>();
      final transferDataController = context.read<TransferDataController>();
      final transaction = await transferController.sendTransfer(request);
      await transferDataController.load();

      if (!mounted) {
        return;
      }

      Navigator.pushNamed(
        context,
        AppRoutes.receipt,
        arguments: ReceiptArguments.fromTransaction(transaction).toMap(),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.toString());
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSourceMenu(BuildContext context) {
    final cards = context.read<TransferDataController>().cards;
    if (cards.length <= 1) {
      return;
    }

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
              'Selecionar origem',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...cards.map(
              (card) => _SourceOption(
                card: card,
                selected: _selectedCard?.id == card.id,
                onTap: () {
                  setState(() => _selectedCard = card);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
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
          'Area Pix',
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
        child: _buildPixAreaSection(),
      ),
    );
  }

  Widget _buildPixAreaSection() {
    final transferController = context.watch<TransferController>();
    final transferData = context.watch<TransferDataController>();
    if (_selectedCard == null && transferData.cards.isNotEmpty) {
      _selectedCard = transferData.cards.first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Area PIX',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        if (transferData.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              transferData.error!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        _buildRecentContacts(transferData.recentContacts),
        const SizedBox(height: 20),
        _RecipientField(
          selectedRecipient: _selectedRecipient,
          controller: _recipientController,
          onClear: () {
            setState(() {
              _selectedRecipient = null;
              _selectedContact = 'Adicionar';
              _recipientController.clear();
            });
          },
        ),
        const SizedBox(height: 16),
        _buildAmountCard(transferData),
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

  Widget _buildRecentContacts(List<TransferContact> recentContacts) {
    final contacts = [
      const TransferContact(name: 'Adicionar', recipient: ''),
      ...recentContacts,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: contacts.map((contact) {
          final isAdd = contact.name == 'Adicionar';
          final isSelected = contact.name == _selectedContact;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedContact = contact.name;
                if (!isAdd) {
                  _selectedRecipient = contact;
                  _recipientController.text = contact.recipient;
                } else {
                  _selectedRecipient = null;
                  _recipientController.clear();
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 58,
              child: Column(
                children: [
                  isAdd
                      ? DashedCircle(
                          size: 58,
                          color: AppColors.darkTextSecondary,
                          child: Icon(
                            Icons.add,
                            color: isSelected
                                ? Colors.white
                                : AppColors.darkTextSecondary,
                            size: 28,
                          ),
                        )
                      : Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.darkBgSecondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Center(
                            child: Text(
                              contact.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 6),
                  Text(
                    contact.name,
                    style: const TextStyle(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountCard(TransferDataController transferData) {
    final cards = transferData.cards;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D168C), Color(0xFF110626)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: Border.all(color: Colors.white.withAlpha(40), width: 1.5),
      ),
      child: Column(
        children: [
          if (_selectedCard != null)
            GestureDetector(
              onTap: () => _showSourceMenu(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
                      _selectedCard!.maskedNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (cards.length > 1) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
            )
          else if (transferData.isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'R\$ $_formattedAmount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cards.isEmpty
                ? 'Nenhum cartao cadastrado'
                : 'Saldo disponivel: R\$ ${_formatBalance(transferData.balance)}',
            style: TextStyle(
              color: Colors.white.withAlpha((0.7 * 255).round()),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferButton(TransferController transferController) {
    final enabled = _canTransfer && !transferController.isSubmitting;

    return GestureDetector(
      onTap: enabled ? _handlePayment : null,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: enabled ? AppColors.success : Colors.white24,
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: transferController.isSubmitting
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transferir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'R\$ $_formattedAmount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '000',
      '0',
      'del',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0840), Color(0xFF0A0318)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: Colors.white.withAlpha(40), width: 1.5),
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
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
              ),
              child: key == 'del'
                  ? const Icon(Icons.backspace_outlined, color: Colors.black)
                  : Text(
                      key,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatBalance(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.card,
    required this.selected,
    required this.onTap,
  });

  final CreditCardModel card;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withAlpha(40)
              : Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.white.withAlpha(40),
            width: selected ? 2 : 1,
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
                Text(
                  card.brand,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  card.maskedNumber,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class DashedCircle extends StatelessWidget {
  const DashedCircle({
    required this.size,
    required this.color,
    required this.child,
    super.key,
  });

  final double size;
  final Color color;
  final Widget child;

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
  _DashedCirclePainter({required this.color});

  final Color color;

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

    for (var i = 0; i < dashCount; i++) {
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

class _RecipientField extends StatelessWidget {
  const _RecipientField({
    required this.selectedRecipient,
    required this.controller,
    required this.onClear,
  });

  final TransferContact? selectedRecipient;
  final TextEditingController controller;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (selectedRecipient == null) {
      return _InputField(
        label: 'Quem vai receber',
        hint: 'Nome, e-mail, conta ou Chave Pix',
        controller: controller,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quem vai receber',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(AppConstants.radiusMax),
            border: Border.all(color: AppColors.secondary, width: 1.3),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFE5E5E5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedRecipient!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedRecipient!.maskedRecipient,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClear,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFFF1E1E),
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatefulWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? prefixIcon;

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _hasFocus = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _onChanged() => setState(() {});

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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            suffixIcon: hasText
                ? IconButton(
                    onPressed: () => widget.controller.clear(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFA4A4AE),
                      size: 22,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.3,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.3,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
