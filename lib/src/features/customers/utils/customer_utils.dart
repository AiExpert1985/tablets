// receive list of all transaction, it does filtering based on
import 'package:tablets/src/common/functions/debug_print.dart';
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
  List<Map<String, dynamic>> invoices = transactions
      .where((item) => item[trans.transactionTypeKey] == TransactionType.customerInvoice.name)
      .toList();
  if (totalDebt <= 0) return [];
  final List<List<dynamic>> openInvoices = [];
  double remainingDebt = totalDebt;
  tempPrint(1);
  for (var invoice in invoices) {
    double invoiceNumber = invoice[trans.numberKey];
    DateTime invoiceDate = invoice[trans.dateKey].toDate();
    double invoiceAmount = invoice[trans.totalAmountKey];
    double invoiceRemainingAmount = invoiceAmount;
    remainingDebt -= invoiceAmount;
    tempPrint(2);
    openInvoices.add([invoiceNumber, invoiceDate, invoiceAmount, invoiceRemainingAmount]);
    if (remainingDebt <= 0) {
      invoiceRemainingAmount = invoiceAmount - remainingDebt;
      break;
    }
  }
  tempPrint(openInvoices);
  return openInvoices;
}
