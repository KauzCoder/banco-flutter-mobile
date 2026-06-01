import 'dart:convert';

import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/quote_model.dart';
import 'package:http/http.dart' as http;

class QuotesService {
  final http.Client client;

  QuotesService([http.Client? client]) : client = client ?? http.Client();

  Future<List<QuoteModel>> fetchQuotes() async {
    // Use AwesomeAPI to fetch latest quotes for a set of symbols
    const symbols = [
      'USD-BRL',
      'EUR-BRL',
      'GBP-BRL',
      'ARS-BRL',
      'CAD-BRL',
      'AUD-BRL',
      'JPY-BRL',
      'CHF-BRL',
      'CNY-BRL',
      'BTC-BRL',
    ];

    final uri = Uri.parse(
      '${ApiConstants.awesomeApiLastUrl}/${symbols.join(',')}',
    );
    final response = await client.get(uri).timeout(ApiConstants.requestTimeout);

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar cotações.');
    }

    final body = jsonDecode(response.body);

    if (body is! Map<String, dynamic>) {
      throw Exception('Resposta de cotações inválida.');
    }

    final List<QuoteModel> quotes = [];

    body.forEach((key, value) {
      try {
        final code = (value['code'] ?? '').toString();
        final name = (value['name'] ?? '').toString();
        final bidStr = (value['bid'] ?? '').toString();
        final pctChange = (value['pctChange'] ?? '').toString();

        final double? bid = double.tryParse(bidStr.replaceAll(',', '.'));
        final price = bid != null ? bid.toStringAsFixed(2) : bidStr;

        final changeFormatted = pctChange.isEmpty
            ? ''
            : '${pctChange.startsWith('-') ? pctChange : '+$pctChange'}%';

        final changePositive = !pctChange.startsWith('-');

        final category = code.toUpperCase().contains('BTC')
            ? 'Criptomoedas'
            : 'Moedas';

        quotes.add(
          QuoteModel(
            symbol: code,
            name: name,
            price: price,
            change: changeFormatted,
            changePositive: changePositive,
            category: category,
          ),
        );
      } catch (_) {
        // ignore malformed entry
      }
    });

    return quotes;
  }

  Future<QuoteModel?> fetchLatestForPair(String pair) async {
    final uri = Uri.parse('${ApiConstants.awesomeApiLastUrl}/$pair');
    final response = await client.get(uri).timeout(ApiConstants.requestTimeout);

    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) return null;

    // The API returns an object whose key is like 'USDBRL' or 'USD-BRL'
    final firstValue = body.values.first;
    if (firstValue == null || firstValue is! Map<String, dynamic>) return null;

    try {
      final code = (firstValue['code'] ?? '').toString();
      final name = (firstValue['name'] ?? '').toString();
      final bidStr = (firstValue['bid'] ?? '').toString();
      final pctChange = (firstValue['pctChange'] ?? '').toString();

      final double? bid = double.tryParse(bidStr.replaceAll(',', '.'));
      final price = bid != null ? bid.toStringAsFixed(2) : bidStr;

      final changeFormatted = pctChange.isEmpty
          ? ''
          : '${pctChange.startsWith('-') ? pctChange : '+$pctChange'}%';

      final changePositive = !pctChange.startsWith('-');

      final category = code.toUpperCase().contains('BTC')
          ? 'Criptomoedas'
          : 'Moedas';

      return QuoteModel(
        symbol: code,
        name: name,
        price: price,
        change: changeFormatted,
        changePositive: changePositive,
        category: category,
      );
    } catch (_) {
      return null;
    }
  }
}
