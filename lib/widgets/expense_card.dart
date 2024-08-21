import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final double expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_upward, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Text(
                  'TOTAL EXPENSE',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${expense.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
