// Transaction model
class Transaction {
  final String title;
  final double amount;
  final bool isIncome;
  final String category;
  final String? note;
  final DateTime date;
    final DateTime createdAt;

  Transaction({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
     this.note,
         DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert a Transaction into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
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
      title: map['title'],
      amount: map['amount'],
      isIncome: map['isIncome'],
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}