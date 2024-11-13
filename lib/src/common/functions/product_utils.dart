// create a list of lists, where each resulting list contains transaction info
// [type, number, date, totalQuantity, totalProfit, totalSalesmanCommission, ]
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/products/model/product.dart';

List<List<dynamic>> getProductTransactions(
    List<Map<String, dynamic>> transactions, Product product) {
  List<List<dynamic>> result = [];
  for (var transaction in transactions) {
    int totalQuantity = 0;
    double totalProfit = 0;
    double totalSalesmanCommission = 0;
    String type = transaction['transactionType'];
    int number = transaction['number'];
    String name = transaction['name'];
    DateTime date = transaction['date'].toDate();
    for (var item in transaction['items']) {
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
      } else {
        continue;
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
    totalQuantity += transaction[4] as int; // totalQuantity
    totalProfit += transaction[5]; // totalProfit
    totalSalesmanCommission += transaction[6]; // totalSalesmanCommission
  }
  return [totalQuantity, totalProfit, totalSalesmanCommission];
}
