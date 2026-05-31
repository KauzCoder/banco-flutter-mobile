import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/models/credit_card_model.dart';
import 'package:flutter_aplication_bank/models/transfer_contact.dart';
import 'package:flutter_aplication_bank/services/transfer_data_service.dart';

class TransferDataController extends ChangeNotifier {
  TransferDataController({TransferDataService? service})
    : _service = service ?? TransferDataService();

  final TransferDataService _service;

  bool isLoading = false;
  String? error;
  double balance = 0;
  List<CreditCardModel> cards = [];
  List<TransferContact> recentContacts = [];

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _service.load();
      balance = data.balance;
      cards = data.cards;
      recentContacts = data.recentContacts;
    } catch (_) {
      error = 'Nao foi possivel carregar seus dados.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
