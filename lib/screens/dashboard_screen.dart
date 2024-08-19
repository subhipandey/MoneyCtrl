import 'package:expense/screens/add_transactions.dart';
import 'package:expense/widgets/expense_card.dart';
import 'package:expense/widgets/income_card.dart';
import 'package:expense/widgets/total_balance_card.dart';
import 'package:expense/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.lightbulb_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          TotalBalanceCard(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: IncomeCard()),
              SizedBox(width: 16),
              Expanded(child: ExpenseCard()),
            ],
          ),
          SizedBox(height: 16),
          Text('Recent Transaction', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          TransactionCard(
            icon: Icons.tv,
            title: 'Cashback Offer',
            category: 'Entertainment',
            amount: 30,
            isIncome: true,
            date: 'Oct 30, 2021',
          ),
          TransactionCard(
            icon: Icons.local_pizza,
            title: 'Cheesy Pizza',
            category: 'Transportation',
            amount: 30,
            isIncome: false,
            date: 'Oct 30, 2021',
          ),
          TransactionCard(
            icon: Icons.work,
            title: 'Freelancing',
            category: 'Transportation',
            amount: 1300,
            isIncome: true,
            date: 'Oct 30, 2021',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
      ),
    );
  }
}
