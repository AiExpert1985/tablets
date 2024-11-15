import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

// create a list of lists, where each resulting list contains transaction info
// [type, number, date, totalQuantity, totalProfit, totalSalesmanCommission, ]
List<List<dynamic>> getProductProcessedTransactions(
    BuildContext context, List<Map<String, dynamic>> transactions, Product product) {
  List<List<dynamic>> result = [];
  if (product.initialQuantity > 0) {
    final initialTransaction = Transaction(
      dbRef: 'na',
      name: 'na',
      imageUrls: ['na'],
      number: 1000001,
      date: product.initialDate,
      currency: 'na',
      transactionType: TransactionType.initialCredit.name,
      totalAmount: product.initialQuantity as double,
    );
    result.add([
      initialTransaction,
      translateDbTextToScreenText(context, TransactionType.initialCredit.name),
      '',
      product.initialDate,
      product.initialQuantity,
      0,
      0
    ]);
  }
  for (var transactionMap in transactions) {
    Transaction transaction = Transaction.fromMap(transactionMap);
    int totalQuantity = 0;
    double totalProfit = 0;
    double totalSalesmanCommission = 0;
    String type = transaction.transactionType;
    String number = '${transaction.number}';
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
        translateDbTextToScreenText(context, type),
        number,
        date,
        totalQuantity,
        totalProfit,
        totalSalesmanCommission
      ];
      result.add(transactionDetails);
    }
  }
  return sortByDate(result, 3);
}

List<dynamic> getProductTotals(List<List<dynamic>> productTransactions) {
  int totalQuantity = 0;
  double totalProfit = 0.0;
  double totalSalesmanCommission = 0.0;
  for (var transaction in productTransactions) {
    totalQuantity += transaction[4] as int;
    totalProfit += transaction[5];
    totalSalesmanCommission += transaction[6];
  }
  return [totalQuantity, totalProfit, totalSalesmanCommission];
}
