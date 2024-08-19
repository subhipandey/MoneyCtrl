import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final String date;

  const TransactionCard({super.key, 
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}