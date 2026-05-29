import 'dart:convert';

import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/transfer_request.dart';
import 'package:http/http.dart' as http;

class TransferService {
  final http.Client client;

  TransferService([http.Client? client]) : client = client ?? http.Client();

  Future<void> sendTransfer(TransferRequest request) async {
    final uri = Uri.parse(ApiConstants.transfersUrl);
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final message = body is Map<String, dynamic> && body['error'] != null
          ? body['error'].toString()
          : 'Falha ao processar transferência.';
      throw Exception(message);
    }
  }
}
