import 'package:flutter_aplication_bank/models/credit_card_model.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/models/transfer_contact.dart';
import 'package:flutter_aplication_bank/services/auth_service.dart';
import 'package:flutter_aplication_bank/services/card_service.dart';
import 'package:flutter_aplication_bank/services/transactions_service.dart';

class TransferData {
  const TransferData({
    required this.balance,
    required this.cards,
    required this.recentContacts,
  });

  final double balance;
  final List<CreditCardModel> cards;
  final List<TransferContact> recentContacts;
}

class TransferDataService {
  TransferDataService({
    CardService? cardService,
    TransactionsService? transactionsService,
  }) : _cardService = cardService ?? CardService(),
       _transactionsService = transactionsService ?? TransactionsService();

  final CardService _cardService;
  final TransactionsService _transactionsService;

  Future<TransferData> load() async {
    final results = await Future.wait<Object?>([
      AuthService.fetchAccountSummary(),
      _transactionsService.fetchTransactions(),
      _cardService.fetchCards(),
    ]);

    final summary = results[0] as Map<String, dynamic>;
    final account = summary['account'] is Map<String, dynamic>
        ? summary['account'] as Map<String, dynamic>
        : null;
    final transactions = results[1] as List<TransactionModel>;
    final cards = results[2] as List<CreditCardModel>;

    return TransferData(
      balance: _toDouble(account?['saldo']),
      cards: cards,
      recentContacts: _contactsFromTransactions(transactions),
    );
  }

  List<TransferContact> _contactsFromTransactions(
    List<TransactionModel> transactions,
  ) {
    final contacts = <TransferContact>[];
    final seen = <String>{};

    for (final transaction in transactions) {
      final name = transaction.title.trim();
      if (name.isEmpty || name == 'Transacao') {
        continue;
      }

      final recipient = transaction.recipientKey.trim().isNotEmpty
          ? transaction.recipientKey.trim()
          : name;

      if (seen.add(recipient.toLowerCase())) {
        contacts.add(TransferContact(name: name, recipient: recipient));
      }
    }

    return contacts.take(8).toList();
  }

  double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
