import 'package:flutter/material.dart';

class IncomeCard extends StatelessWidget {
  final double income;

  const IncomeCard({super.key, required this.income});

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
                const Icon(Icons.arrow_downward, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(
                  'TOTAL INCOME',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${income.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}