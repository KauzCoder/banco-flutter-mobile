import 'dart:convert';

import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/credit_card_model.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:http/http.dart' as http;

class CardService {
  CardService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<CreditCardModel>> fetchCards() async {
    final response = await _client
        .get(Uri.parse(ApiConstants.cardsUrl), headers: AuthService.authHeaders)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar cartoes.');
    }

    final body = jsonDecode(response.body);
    if (body is! List) {
      throw Exception('Resposta de cartoes invalida.');
    }

    return body
        .cast<Map<String, dynamic>>()
        .map(CreditCardModel.fromJson)
        .toList();
  }
}
