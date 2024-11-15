// create a list of lists, where each resulting list contains transaction info
// [type, number, date, totalQuantity, totalProfit, totalSalesmanCommission, ]
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';

List<Map<String, dynamic>> getProductTransactions(
    List<Map<String, dynamic>> transactions, String dbRef) {
  // Filter transactions for the given database reference
  List<Map<String, dynamic>> productTransactions =
      transactions.where((item) => item[nameDbRefKey] == dbRef).toList();

  // Sort the transactions in descending order based on the transaction date
  return productTransactions
    ..sort((a, b) {
      final dateA = a[dateKey];
      final dateB = b[dateKey];
      return dateB.compareTo(dateA);
    });
}

List<List<dynamic>> getProductProcessedTransactions(
    List<Map<String, dynamic>> transactions, Product product) {
  List<List<dynamic>> result = [];
  for (var transactionMap in transactions) {
    Transaction transaction = Transaction.fromMap(transactionMap);
    int totalQuantity = 0;
    double totalProfit = 0;
    double totalSalesmanCommission = 0;
    String type = transaction.transactionType;
    int number = transaction.number;
    String name = transaction.name;
    DateTime date = transaction.date;
    for (var item in transaction.items ?? []) {
      if (item['dbRef'] != product.dbRef) continue;
      if (type == TransactionType.customerInvoice.name ||
          type == TransactionType.vendorReturn.name) {
        totalQuantity -= item['soldQuantity'] as int;
        totalQuantity -= item['giftQuantity'] as int;
        totalProfit += item['itemTotalProfit'] ?? 0;
        totalSalesmanCommission += item['salesmanTotalCommission'] ?? 0;
      } else if (type == TransactionType.vendorInvoice.name ||
          type == TransactionType.customerReturn.name) {
        totalQuantity += item['soldQuantity'] as int;
        totalQuantity += item['giftQuantity'] as int;
      } else if (type == TransactionType.damagedItems.name) {
        totalQuantity -= item['soldQuantity'] as int;
      } else {
        continue;
      }
      List<dynamic> transactionDetails = [
        transaction,
        type,
        number,
        name,
        date,
        totalQuantity,
        totalProfit,
        totalSalesmanCommission
      ];
      result.add(transactionDetails);
    }
  }
  return result;
}

List<dynamic> getProductTotals(List<List<dynamic>> productTransactions, Product product) {
  int totalQuantity = product.initialQuantity;
  double totalProfit = 0.0;
  double totalSalesmanCommission = 0.0;
  for (var transaction in productTransactions) {
    totalQuantity += transaction[5] as int; // totalQuantity
    totalProfit += transaction[6]; // totalProfit
    totalSalesmanCommission += transaction[7]; // totalSalesmanCommission
  }
  return [totalQuantity, totalProfit, totalSalesmanCommission];
}
