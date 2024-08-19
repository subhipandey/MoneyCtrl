class Transaction {
  final String title;
  final double amount;
  final bool isIncome;
  final String category;
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
  });
}
