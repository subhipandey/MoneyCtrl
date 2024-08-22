import 'package:flutter/material.dart';

class TotalBalanceCard extends StatelessWidget {
  final double balance;
  final bool isDarkMode;

  const TotalBalanceCard({
    super.key,
    required this.balance,
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
            Text(
              'TOTAL BALANCE',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
