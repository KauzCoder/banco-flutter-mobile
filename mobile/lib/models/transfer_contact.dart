class TransferContact {
  const TransferContact({required this.name, required this.recipient});

  final String name;
  final String recipient;

  String get maskedRecipient {
    if (recipient.contains('@')) {
      final parts = recipient.split('@');
      final prefix = parts.first;
      if (prefix.length <= 3) {
        return '***@${parts.last}';
      }
      return '${prefix.substring(0, 3)}***@${parts.last}';
    }

    final digits = recipient.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 11) {
      return '***.${digits.substring(3, 6)}.${digits.substring(6, 9)}-**';
    }

    return recipient;
  }
}
