// receive list of all transaction, it does filtering based on
import 'package:tablets/src/common/functions/debug_print.dart';

double calculateTotalDebt(List<Map<String, dynamic>> transactions, String dbRef) {
  final customerTransactions = transactions.where((item) => item['customerDbRef '] == dbRef);
  double totalDebt = 0.0;

  for (var transaction in customerTransactions) {
    if (transaction.containsKey('amount') && transaction['amount'] is num) {
      double amount = transaction['amount'];

      if (transaction.containsKey('type') && transaction['type'] == 'customerInvoice') {
        totalDebt += amount;
      } else if (transaction.containsKey('type') && transaction['type'] == 'customerReceipt') {
        totalDebt -= amount;
      }
    } else {
      // Handle unexpected data structure
      errorPrint('error while calculating customer total debt');
    }
  }

  return totalDebt;
}
