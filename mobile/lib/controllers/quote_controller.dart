import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/models/quote_model.dart';
import 'package:flutter_aplication_bank/services/quotes_service.dart';

class QuoteController extends ChangeNotifier {
  final QuotesService _service;

  QuoteController({QuotesService? service}) : _service = service ?? QuotesService();

  bool isLoading = false;
  String? error;
  List<QuoteModel> quotes = [];

  Future<void> fetchQuotes() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      quotes = await _service.fetchQuotes();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
