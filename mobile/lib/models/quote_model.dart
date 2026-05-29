class QuoteModel {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final bool changePositive;
  final String category;

  QuoteModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePositive,
    required this.category,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      change: json['change']?.toString() ?? '',
      changePositive: json['changePositive'] == true,
      category: json['category']?.toString() ?? 'Moedas',
    );
  }
}
