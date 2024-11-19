import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

const quantityKey = 'quantity';
const profitKey = 'profit';

final productScreenControllerProvider = Provider<ProductScreenController>((ref) {
  final transactionsDbCache = ref.read(transactionDbCacheProvider.notifier);
  return ProductScreenController(transactionsDbCache);
});

class ProductScreenController {
  ProductScreenController(
    this._transactionsDbCache,
  );
  final DbCache _transactionsDbCache;

// create a list of lists, where each resulting list contains transaction info
// [type, number, date, totalQuantity, totalProfit, totalSalesmanCommission, ]
  Map<String, dynamic> createProductScreenData(BuildContext context, Product product) {
    Map<String, dynamic> newDataRow = {};
    List<List<dynamic>> productTransactions = [];
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
      productTransactions.add([
        initialTransaction,
        translateDbTextToScreenText(context, TransactionType.initialCredit.name),
        '',
        product.initialDate,
        product.initialQuantity,
        0,
        0
      ]);
    }
    final transactions = _transactionsDbCache.data;
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
          totalProfit -= (item['soldQuantity'] ?? 0) * (item['buyingPrice'] ?? 0);
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
        productTransactions.add(transactionDetails);
      }
    }
    sortListOfListsByDate(productTransactions, 3);
    final productTotals = getProductTotals(productTransactions);
    final profitableInvoices = getOnlyProfitInvoices(productTransactions, 5);
    newDataRow[quantityKey] = {'value': productTotals[0], 'details': productTransactions};
    newDataRow[profitKey] = {'value': productTotals[1], 'details': profitableInvoices};
    return newDataRow;
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

  List<List<dynamic>> getOnlyProfitInvoices(
      List<List<dynamic>> processedTransactions, int profitIndex) {
    List<List<dynamic>> result = [];
    for (var innerList in processedTransactions) {
      if (innerList.length > profitIndex && innerList[profitIndex] != 0) {
        result.add(List.from(innerList));
      }
    }
    return result;
  }
}
