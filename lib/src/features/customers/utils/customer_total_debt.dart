// receive list of all transaction, it does filtering based on
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart' as trans;

double calculateTotalDebt(List<Map<String, dynamic>> transactions, String dbRef) {
  final customerTransactions = transactions.where((item) => item[trans.nameDbRefKey] == dbRef);
  double totalDebt = 0.0;

  for (var transaction in customerTransactions) {
    tempPrint('${transaction[trans.transactionTypeKey]} - ${transaction[trans.totalAmountKey]}');
    if (transaction.containsKey(trans.totalAmountKey) && transaction[trans.totalAmountKey] is num) {
      double amount = transaction[trans.totalAmountKey];
      if (transaction.containsKey(trans.transactionTypeKey) &&
          transaction[trans.transactionTypeKey] == TransactionType.customerInvoice.name) {
        totalDebt += amount;
      } else if (transaction.containsKey(trans.transactionTypeKey) &&
          transaction[trans.transactionTypeKey] == TransactionType.customerReceipt.name) {
        totalDebt -= amount;
      }
    } else {
      // Handle unexpected data structure
      errorPrint('error while calculating customer total debt');
    }
  }

  return totalDebt;
}
