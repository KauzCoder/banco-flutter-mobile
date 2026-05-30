import 'dart:convert';

import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/quote_model.dart';
import 'package:http/http.dart' as http;

class QuotesService {
  final http.Client client;

  QuotesService([http.Client? client]) : client = client ?? http.Client();

  Future<List<QuoteModel>> fetchQuotes() async {
    final uri = Uri.parse(ApiConstants.quotesUrl);
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar cotações.');
    }

    final body = jsonDecode(response.body);
    if (body is! List) {
      throw Exception('Resposta de cotações inválida.');
    }

    return body
        .cast<Map<String, dynamic>>()
        .map(QuoteModel.fromJson)
        .toList();
  }
}
