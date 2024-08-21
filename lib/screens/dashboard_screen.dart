import 'dart:convert';

import 'package:expense/model/transaction.dart';
import 'package:expense/screens/add_transactions.dart';
import 'package:expense/widgets/expense_card.dart';
import 'package:expense/widgets/income_card.dart';
import 'package:expense/widgets/total_balance_card.dart';
import 'package:expense/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null) {
      List<dynamic> decodedTransactions = jsonDecode(transactionsJson);
      setState(() {
        transactions = decodedTransactions.map((item) => Transaction.fromMap(item)).toList();
      });
    }
  }

  void saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsJson = jsonEncode(transactions.map((t) => t.toMap()).toList());
    await prefs.setString('transactions', transactionsJson);
  }

  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
      saveTransactions();
    });
  }

  double get totalBalance {
    return transactions.fold(0, (sum, transaction) => 
      sum + (transaction.isIncome ? transaction.amount : -transaction.amount));
  }

  double get totalIncome {
    return transactions.where((t) => t.isIncome).fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpense {
    return transactions.where((t) => !t.isIncome).fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.lightbulb_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TotalBalanceCard(balance: totalBalance),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: IncomeCard(income: totalIncome)),
              const SizedBox(width: 16),
              Expanded(child: ExpenseCard(expense: totalExpense)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...transactions.map((transaction) => TransactionCard(
            icon: transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            title: transaction.title,
            category: transaction.category,
            amount: transaction.amount,
            isIncome: transaction.isIncome,
            date: DateFormat('MMM dd, yyyy').format(transaction.date),
          )).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen(
              onAddTransaction: addTransaction,
            )),
          );
        },
      ),
    );
  }
}