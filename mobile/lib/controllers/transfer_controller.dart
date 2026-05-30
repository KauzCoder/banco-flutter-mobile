import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/models/transfer_request.dart';
import 'package:flutter_aplication_bank/services/transfer_service.dart';

class TransferController extends ChangeNotifier {
  final TransferService _service;

  TransferController({TransferService? service}) : _service = service ?? TransferService();

  bool isSubmitting = false;
  String? error;

  Future<void> sendTransfer(TransferRequest request) async {
    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      await _service.sendTransfer(request);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
