import 'dart:io';
import 'package:expense/model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class CSVExportService {
  static Future<void> exportTransactionsToCSV(
      List<Transaction> transactions) async {
    List<List<dynamic>> rows = [
      ['Title', 'Amount', 'Type', 'Category', 'Date', 'Note', 'Created At']
    ];
    for (var transaction in transactions) {
      rows.add([
        transaction.title,
        transaction.amount,
        transaction.isIncome ? 'Income' : 'Expense',
        transaction.category,
        DateFormat('yyyy-MM-dd').format(transaction.date),
        transaction.note ?? '',
        DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.createdAt),
      ]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/transactions.csv');
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(file.path)], text: 'Transactions CSV');
  }

  static Future<String> storeCSVOnDevice(List<Transaction> transactions) async {
    List<List<dynamic>> rows = [
      ['Title', 'Amount', 'Type', 'Category', 'Date', 'Note', 'Created At']
    ];
    for (var transaction in transactions) {
      rows.add([
        transaction.title,
        transaction.amount,
        transaction.isIncome ? 'Income' : 'Expense',
        transaction.category,
        DateFormat('yyyy-MM-dd').format(transaction.date),
        transaction.note ?? '',
        DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.createdAt),
      ]);
    }
    String csv = const ListToCsvConverter().convert(rows);

    var status = await Permission.storage.request();
    if (status.isGranted) {
      Directory? storageDirectory;
      if (Platform.isAndroid) {
        storageDirectory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        storageDirectory = await getApplicationDocumentsDirectory();
      }

      if (storageDirectory != null) {
        final fileName = 'transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
        final filePath = '${storageDirectory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsString(csv);
        return filePath;
      } else {
        throw Exception('Could not access storage directory');
      }
    } else {
      throw Exception('Storage permission denied');
    }
  }
}
  
  