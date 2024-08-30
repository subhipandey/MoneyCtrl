import 'dart:convert';

import 'package:expense/model/transaction.dart';
import 'package:expense/screens/about_screen.dart';
import 'package:expense/screens/add_transactions.dart';
import 'package:expense/screens/settings_Screen.dart';
import 'package:expense/utils/csv_export_service.dart';
import 'package:expense/widgets/expense_card.dart';
import 'package:expense/widgets/income_card.dart';
import 'package:expense/widgets/total_balance_card.dart';
import 'package:expense/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const DashboardScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> transactions = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTransactions();
    _previousTransactionCount = transactions.length;
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null) {
      List<dynamic> decodedTransactions = jsonDecode(transactionsJson);
      setState(() {
        transactions = decodedTransactions
            .map((item) => Transaction.fromMap(item))
            .toList();
      });
    }
  }

  void saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsJson =
        jsonEncode(transactions.map((t) => t.toMap()).toList());
    await prefs.setString('transactions', transactionsJson);
  }

  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
      saveTransactions();
    });
  }

  void editTransaction(Transaction updatedTransaction) {
    setState(() {
      int index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
      if (index != -1) {
        transactions[index] = updatedTransaction;
        saveTransactions();
      }
    });
  }

  void deleteTransaction(Transaction transaction) {
    setState(() {
      transactions.removeWhere((t) => t.id == transaction.id);
      saveTransactions();
    });
  }

  Future<void> exportTransactionsToCSV() async {
    try {
      String result = await CSVExportService.exportTransactionsToCSV(transactions);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export CSV: ${e.toString()}')),
      );
    }
  }

  Future<void> importTransactionsFromCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          List<Transaction> importedTransactions = 
              await CSVExportService.importTransactionsFromCSV(filePath);
          
          if (importedTransactions.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No valid transactions found in the CSV file')),
            );
            return;
          }

          double oldTotalBalance = totalBalance;
          double oldTotalIncome = totalIncome;
          double oldTotalExpense = totalExpense;

          setState(() {
            transactions.addAll(importedTransactions);
            transactions.sort((a, b) => b.date.compareTo(a.date)); // Sort by date, most recent first
            saveTransactions();
          });

          // Highlight changes
          _highlightChanges(
            oldTotalBalance: oldTotalBalance,
            oldTotalIncome: oldTotalIncome,
            oldTotalExpense: oldTotalExpense,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${importedTransactions.length} transactions imported')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to import CSV: ${e.toString()}')),
      );
    }
  }

  void _highlightChanges({
    required double oldTotalBalance,
    required double oldTotalIncome,
    required double oldTotalExpense,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateChange(oldTotalBalance, totalBalance, 'Total Balance');
      _animateChange(oldTotalIncome, totalIncome, 'Total Income');
      _animateChange(oldTotalExpense, totalExpense, 'Total Expense');
      _highlightNewTransactions();
    });
  }

  void _animateChange(double oldValue, double newValue, String label) {
    if (oldValue != newValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label updated: ${oldValue.toStringAsFixed(2)} → ${newValue.toStringAsFixed(2)}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _highlightNewTransactions() {
    // Assuming the new transactions are at the beginning of the list
    int newTransactionsCount = transactions.length - _previousTransactionCount;
    if (newTransactionsCount > 0) {
      for (int i = 0; i < newTransactionsCount; i++) {
        final key = GlobalKey();
        _highlightedKeys.add(key);
        transactions[i].key = key;
      }
      setState(() {});

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _highlightedKeys.clear();
        });
      });
    }
  }

  // Add these properties to the class
  final List<GlobalKey> _highlightedKeys = [];
  int _previousTransactionCount = 0;

  double get totalBalance {
    return transactions.fold(
        0,
        (sum, transaction) =>
            sum +
            (transaction.isIncome ? transaction.amount : -transaction.amount));
  }

  double get totalIncome {
    return transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.lightbulb : Icons.lightbulb_outline,
            ),
            onPressed: widget.onThemeToggle,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'export_csv') {
                await exportTransactionsToCSV();
              } else if (value == 'import_csv') {
                await importTransactionsFromCSV();
              } else if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              } else if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'export_csv',
                child: Text('Export to CSV'),
              ),
              const PopupMenuItem<String>(
                value: 'import_csv',
                child: Text('Import from CSV'),
              ),
              const PopupMenuItem<String>(
                value: 'about',
                child: Text('About'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TotalBalanceCard(
            balance: totalBalance,
            isDarkMode: widget.isDarkMode,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: IncomeCard(
                  income: totalIncome,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ExpenseCard(
                  expense: totalExpense,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (var transaction in transactions)
            _buildTransactionCard(transaction),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTransactionScreen(
                      onAddTransaction: addTransaction,
                    )),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    bool isHighlighted = _highlightedKeys.contains(transaction.key);
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.yellow.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TransactionCard(
        key: transaction.key,
        icon: transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        title: transaction.title,
        category: transaction.category,
        amount: transaction.amount,
        isIncome: transaction.isIncome,
        date: DateFormat('MMM dd, yyyy').format(transaction.date),
        isDarkMode: widget.isDarkMode,
        transaction: transaction,
        onEdit: editTransaction,
        onDelete: deleteTransaction,
      ),
    );
  }
}