class TransferRequest {
  final String recipient;
  final double amount;
  final String message;
  final String type;
  final String? cardId;

  TransferRequest({
    required this.recipient,
    required this.amount,
    required this.message,
    required this.type,
    this.cardId,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'amount': amount,
      'message': message,
      'description': message,
      'descricao': message,
      'type': type,
      'tipo': type,
      if (cardId != null) 'cardId': cardId,
    };
  }
}
