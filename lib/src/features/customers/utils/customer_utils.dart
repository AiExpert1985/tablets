// receive list of all transaction, it does filtering based on
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart' as trans;

List<Map<String, dynamic>> getCustomerTransactions(
    List<Map<String, dynamic>> transactions, String dbRef) {
  // Filter transactions for the given database reference
  List<Map<String, dynamic>> customerTransactions =
      transactions.where((item) => item[trans.nameDbRefKey] == dbRef).toList();

  // Sort the transactions in descending order based on the transaction date
  return customerTransactions
    ..sort((a, b) {
      final dateA = a[trans.dateKey];
      final dateB = b[trans.dateKey];
      return dateB.compareTo(dateA);
    });
}

double getTotalDebt(List<Map<String, dynamic>> transactions) {
  double totalDebt = 0.0;
  for (var transaction in transactions) {
    if (transaction.containsKey(trans.totalAmountKey) && transaction[trans.totalAmountKey] is num) {
      double amount = transaction[trans.totalAmountKey];
      if (transaction.containsKey(trans.transactionTypeKey) &&
          transaction[trans.transactionTypeKey] == TransactionType.customerInvoice.name) {
        totalDebt += amount;
      } else if (transaction.containsKey(trans.transactionTypeKey) &&
          (transaction[trans.transactionTypeKey] == TransactionType.customerReceipt.name ||
              transaction[trans.transactionTypeKey] == TransactionType.customerReturn.name)) {
        totalDebt -= amount;
      }
    } else {
      // Handle unexpected data structure
      errorPrint('error while calculating customer total debt');
    }
  }

  return totalDebt;
}

// open invoices are invoices that are not payed completely by customer
// transactions must be order based on date in descending order
List<List<dynamic>> getOpenInvoices(List<Map<String, dynamic>> transactions, double totalDebt) {
  if (totalDebt <= 0) return [];
  final lastReceipt = transactions
      .firstWhere((item) => item[trans.transactionTypeKey] == TransactionType.customerReceipt.name);
  String lastRecriptDate = formatDate(lastReceipt[trans.dateKey].toDate());
  double lastReceiptnumber = lastReceipt[trans.numberKey];
  double lastReceiptAmount = lastReceipt[trans.totalAmountKey];
  List<Map<String, dynamic>> invoices = transactions
      .where((item) => item[trans.transactionTypeKey] == TransactionType.customerInvoice.name)
      .toList();
  final List<List<dynamic>> openInvoices = [];
  double remainingDebt = totalDebt;
  for (var invoice in invoices) {
    double invoiceNumber = invoice[trans.numberKey];
    String invoiceDate = formatDate(invoice[trans.dateKey].toDate());
    double invoiceAmount = invoice[trans.totalAmountKey];
    remainingDebt -= invoiceAmount;
    if (remainingDebt <= 0) {
      openInvoices.add([
        invoiceNumber,
        invoiceDate,
        invoiceAmount,
        -remainingDebt,
        invoiceAmount + remainingDebt,
        lastRecriptDate,
        lastReceiptnumber,
        lastReceiptAmount
      ]);
      break;
    }
    openInvoices.add([invoiceNumber, invoiceDate, invoiceAmount, 0, invoiceAmount, '', '']);
  }
  return openInvoices;
}
