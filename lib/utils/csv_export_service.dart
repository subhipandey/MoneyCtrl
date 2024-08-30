import 'dart:io';
import 'package:csv/csv.dart';
import 'package:expense/model/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CSVExportService {
  static Future<String> exportTransactionsToCSV(List<Transaction> transactions) async {
    final status = await Permission.storage.request();
    
    if (status.isGranted) {
      Directory? directory = await getExternalStorageDirectory();
      String downloadsPath = '${directory?.path.split('Android')[0]}Download';
      
      String fileName = 'transactions_${DateTime.now().millisecondsSinceEpoch}.csv';
      String filePath = '$downloadsPath/$fileName';

      File file = File(filePath);
      
      // Generate CSV content
      String csv = 'Date,Title,Amount,Category,Type\n';
      for (var transaction in transactions) {
        csv += '${transaction.date},${transaction.title},${transaction.amount},${transaction.category},${transaction.isIncome ? 'Income' : 'Expense'}\n';
      }

      await file.writeAsString(csv);

      return 'File saved to: $filePath';
    } else {
      throw Exception('Storage permission not granted');
    }
  }

  static Future<List<Transaction>> importTransactionsFromCSV(String filePath) async {
    try {
      final file = File(filePath);
      final contents = await file.readAsString();

      // Split the contents into lines manually
      List<String> lines = contents.split('\n');

      // Remove header row
      if (lines.length > 1) {
        lines.removeAt(0);
      }

      List<Transaction> importedTransactions = [];

      for (String line in lines) {
        List<String> row = line.split(',');
        if (row.length >= 5) {
          DateTime date;
          try {
            date = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').parse(row[0].trim());
          } catch (e) {
            date = DateFormat('yyyy-MM-dd').parse(row[0].trim());
          }
          
          importedTransactions.add(Transaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a new ID
            date: date,
            title: row[1].trim(),
            amount: double.parse(row[2].trim()),
            category: row[3].trim(),
            isIncome: row[4].trim().toLowerCase() == 'income',
          ));
        }
      }

      return importedTransactions;
    } catch (e) {
      rethrow;
    }
  }
}