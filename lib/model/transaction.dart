import 'package:flutter/material.dart';

// Transaction model
class Transaction {
  final String id;
  final DateTime date;
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final String? note;
  final DateTime createdAt;
  GlobalKey? key;

  Transaction({
    String? id,
    required this.date,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    this.note,
    DateTime? createdAt,
    this.key,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  // Convert a Transaction into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Convert a Map into a Transaction
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
       id: map['id'],
      date: DateTime.parse(map['date']),
      title: map['title'],
      amount: map['amount'],
      isIncome: map['isIncome'],
      category: map['category'],
    );
  }
}
