class CreditCardModel {
  const CreditCardModel({
    required this.id,
    required this.holderName,
    required this.brand,
    required this.last4,
    required this.type,
    required this.limit,
    required this.availableLimit,
  });

  final String id;
  final String holderName;
  final String brand;
  final String last4;
  final String type;
  final double limit;
  final double availableLimit;

  String get maskedNumber => '***.$last4-**';

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      id: json['id']?.toString() ?? '',
      holderName: json['holderName']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      last4: json['last4']?.toString() ?? '',
      type: json['type']?.toString() ?? 'credit',
      limit: _toDouble(json['limit']),
      availableLimit: _toDouble(json['availableLimit']),
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
