import 'package:flutter/material.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isExpense,
    required this.icon,
    required this.iconColor,
    this.description = '',
    this.status = '',
    this.type = '',
    this.recipientKey = '',
    this.dateTime,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isExpense;
  final IconData icon;
  final Color iconColor;
  final String description;
  final String status;
  final String type;
  final String recipientKey;
  final DateTime? dateTime;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final type = json['tipo']?.toString() ?? '';
    final description = json['descricao']?.toString() ?? '';
    final receiver = json['nomeRecebedor']?.toString() ?? '';
    final amount = _toDouble(json['valor']);

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      title: receiver.isEmpty ? _titleFromType(type) : receiver,
      category: _categoryFromType(type, description),
      amount: amount,
      isExpense: amount < 0 || type != 'entrada',
      icon: _iconFromType(type),
      iconColor: _iconColorFromType(type),
      description: description,
      status: json['status']?.toString() ?? '',
      type: type,
      recipientKey: json['chavePixRecebedor']?.toString() ?? '',
      dateTime: _parseDateTime(json['dataHora']),
    );
  }

  String get formattedAmount {
    final value = amount.abs().toStringAsFixed(2).replaceAll('.', ',');
    return '${isExpense ? '- ' : ''}R\$$value';
  }

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }

    return title.toLowerCase().contains(normalized) ||
        category.toLowerCase().contains(normalized) ||
        formattedAmount.toLowerCase().contains(normalized);
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    if (value is Map<String, dynamic>) {
      final seconds = value['_seconds'] ?? value['seconds'];
      if (seconds is num) {
        return DateTime.fromMillisecondsSinceEpoch(seconds.toInt() * 1000);
      }
    }

    return DateTime.tryParse(value.toString());
  }

  static String _titleFromType(String type) {
    return switch (type) {
      'pagamento' => 'Pagamento',
      'entrada' => 'Transferência Recebida',
      'transferencia' => 'Transferência de Dinheiro',
      _ => 'Transação',
    };
  }

  static String _categoryFromType(String type, String description) {
    if (description.isNotEmpty) {
      return description;
    }

    return switch (type) {
      'pagamento' => 'Pagamento',
      'entrada' => 'Entrada',
      'transferencia' => 'Transação',
      _ => 'Movimentação',
    };
  }

  static IconData _iconFromType(String type) {
    return switch (type) {
      'pagamento' => Icons.shopping_cart_outlined,
      'entrada' => Icons.file_download_outlined,
      'transferencia' => Icons.file_download_outlined,
      _ => Icons.receipt_long_outlined,
    };
  }

  static Color _iconColorFromType(String type) {
    return switch (type) {
      'pagamento' => const Color(0xFFFF6B72),
      'entrada' => const Color(0xFFDBFF2F),
      'transferencia' => Colors.white,
      _ => const Color(0xFFA4A4AE),
    };
  }
}
