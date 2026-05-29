class TransferRequest {
  final String recipient;
  final double amount;
  final String message;
  final String type;

  TransferRequest({
    required this.recipient,
    required this.amount,
    required this.message,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'amount': amount,
      'message': message,
      'type': type,
    };
  }
}
