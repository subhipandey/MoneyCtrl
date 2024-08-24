import 'package:flutter/material.dart';

class IncomeCard extends StatelessWidget {
  final double income;
  final bool isDarkMode;

  const IncomeCard({
    super.key,
    required this.income,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.grey[300],
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
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\₹${income.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}