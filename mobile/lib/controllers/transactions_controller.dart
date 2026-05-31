import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:flutter_aplication_bank/services/transactions_service.dart';

class TransactionsController extends ChangeNotifier {
  TransactionsController({TransactionsService? service})
    : _service = service ?? TransactionsService();

  final TransactionsService _service;

  bool isLoading = false;
  String? error;
  List<TransactionModel> transactions = [];

  Future<void> fetchTransactions({String? authToken, String? userId}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      transactions = await _service.fetchTransactions(
        authToken: authToken ?? AuthService.token,
        userId: userId,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
