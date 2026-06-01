import 'dart:convert';

import 'package:flutter_aplication_bank/core/api_constants.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/models/transfer_request.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:http/http.dart' as http;

class TransferService {
  final http.Client client;

  TransferService([http.Client? client]) : client = client ?? http.Client();

  Future<TransactionModel> sendTransfer(TransferRequest request) async {
    final uri = Uri.parse(ApiConstants.transfersUrl);
    final response = await client
        .post(
          uri,
          headers: AuthService.authHeaders,
          body: jsonEncode(request.toJson()),
        )
        .timeout(ApiConstants.requestTimeout);

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = body is Map<String, dynamic>
          ? (body['message'] ?? body['error'])?.toString()
          : null;
      throw Exception(message ?? 'Falha ao processar transferencia.');
    }

    if (body is! Map<String, dynamic>) {
      throw Exception('Resposta de transferencia invalida.');
    }

    return TransactionModel.fromJson(body);
  }
}
