// create a list of lists, where each resulting list contains transaction info
// [type, number, date, totalQuantity, totalProfit, totalSalesmanCommission, ]
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/products/model/product.dart';

List<List<dynamic>> getProductTransactions(
    List<Map<String, dynamic>> transactions, Product product) {
  tempPrint('hi');
  List<List<dynamic>> result = [];
  for (var transaction in transactions) {
    String type = transaction['transactionType'];
    int number = transaction['number'];
    String name = transaction['name'];
    DateTime date = transaction['date'].toDate();
    int totalQuantity = product.initialQuantity;
    double totalProfit = 0;
    double totalSalesmanCommission = 0;
    for (var item in transaction['items']) {
      if (item['dbRef'] != product.dbRef) continue;
      if (type == TransactionType.customerInvoice.name ||
          type == TransactionType.vendorReturn.name) {
        totalQuantity -= item['soldQuantity'] as int;
        totalQuantity -= item['giftQuantity'] as int;
        totalProfit += item['itemTotalProfit'] ?? 0;
        totalSalesmanCommission += item['salesmanTotalCommission'] ?? 0;
        continue;
      }
      if (type == TransactionType.vendorInvoice.name ||
          type == TransactionType.customerReturn.name) {
        totalQuantity += item['soldQuantity'] as int;
        totalQuantity += item['giftQuantity'] as int;
        continue;
      }
    }

    List<dynamic> transactionDetails = [
      type,
      number,
      name,
      date,
      totalQuantity,
      totalProfit,
      totalSalesmanCommission
    ];
    // Add the transaction details to the result list
    result.add(transactionDetails);
  }
  return result;
}

List<double> getProductTotals(List<List<dynamic>> productTransactions) {
  double totalQuantity = 0.0;
  double totalProfit = 0.0;
  double totalSalesmanCommission = 0.0;
  for (var transaction in productTransactions) {
    totalQuantity += transaction[4]; // totalQuantity
    totalProfit += transaction[5]; // totalProfit
    totalSalesmanCommission += transaction[6]; // totalSalesmanCommission
  }
  return [totalQuantity, totalProfit, totalSalesmanCommission];
}

// used by Transaction in product selection drop list
int getTotalQuantity(List<Map<String, dynamic>> transactions, Product product) {
  final productTransactions = getProductTransactions(transactions, product);
  final productTotals = getProductTotals(productTransactions);
  return productTotals[0] as int;
}
