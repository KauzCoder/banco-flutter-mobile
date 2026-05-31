import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:http/http.dart' as http;

class TransactionsService {
  TransactionsService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<TransactionModel>> fetchTransactions({
    String? authToken,
    String? userId,
  }) async {
    final token = authToken ?? AuthService.token;
    if (token == null || token.isEmpty) {
      return mockTransactions();
    }

    final uri = Uri.parse(ApiConstants.transferHistoryUrl).replace(
      queryParameters: userId == null || userId.isEmpty
          ? null
          : {'userId': userId},
    );
    final response = await _client
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar transações.');
    }

    final body = jsonDecode(response.body);
    if (body is! List) {
      throw Exception('Resposta de transações inválida.');
    }

    return body
        .cast<Map<String, dynamic>>()
        .map(TransactionModel.fromJson)
        .toList();
  }

  List<TransactionModel> mockTransactions() {
    return const [
      TransactionModel(
        id: 'mock-apple-1',
        title: 'Apple Store',
        category: 'Entretenimento',
        amount: 5.99,
        isExpense: true,
        icon: Icons.apple,
        iconColor: Colors.white,
      ),
      TransactionModel(
        id: 'mock-spotify-1',
        title: 'Spotify',
        category: 'Música',
        amount: 12.99,
        isExpense: true,
        icon: Icons.music_note_rounded,
        iconColor: Color(0xFF1ED760),
      ),
      TransactionModel(
        id: 'mock-transfer-1',
        title: 'Transferência de Dinheiro',
        category: 'Transação',
        amount: 300,
        isExpense: false,
        icon: Icons.file_download_outlined,
        iconColor: Colors.white,
      ),
      TransactionModel(
        id: 'mock-market-1',
        title: 'Supermercado',
        category: 'Compras',
        amount: 88,
        isExpense: true,
        icon: Icons.shopping_cart_outlined,
        iconColor: Color(0xFFFF6B72),
      ),
      TransactionModel(
        id: 'mock-netflix-1',
        title: 'Netflix',
        category: 'Entretenimento',
        amount: 39.90,
        isExpense: true,
        icon: Icons.movie_creation_outlined,
        iconColor: Color(0xFFE50914),
      ),
      TransactionModel(
        id: 'mock-transfer-2',
        title: 'Transferência de Dinheiro',
        category: 'Transação',
        amount: 300,
        isExpense: false,
        icon: Icons.file_download_outlined,
        iconColor: Colors.white,
      ),
      TransactionModel(
        id: 'mock-apple-2',
        title: 'Apple Store',
        category: 'Entretenimento',
        amount: 5.99,
        isExpense: true,
        icon: Icons.apple,
        iconColor: Colors.white,
      ),
      TransactionModel(
        id: 'mock-spotify-2',
        title: 'Spotify',
        category: 'Música',
        amount: 12.99,
        isExpense: true,
        icon: Icons.music_note_rounded,
        iconColor: Color(0xFF1ED760),
      ),
    ];
  }
}
