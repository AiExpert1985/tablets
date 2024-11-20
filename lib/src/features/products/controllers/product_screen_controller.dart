import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/screen_data.dart';
import 'package:tablets/src/features/products/controllers/product_screen_data_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

const productDbRefKey = 'dbRef';
const quantityKey = 'quantity';
const quantityDetailsKey = 'quantityDetails';
const profitKey = 'profit';
const profitDetailsKey = 'profitDetails';
const totalStockPriceKey = 'itemTotalStockPrice';

final productScreenControllerProvider = Provider<ProductScreenController>((ref) {
  final screenDataProvider = ref.read(productScreenDataProvider);
  final transactionsDbCache = ref.read(transactionDbCacheProvider.notifier);
  return ProductScreenController(screenDataProvider, transactionsDbCache);
});

class ProductScreenController {
  ProductScreenController(
    this._screenDataProvider,
    this._transactionsDbCache,
  );
  final ScreenData _screenDataProvider;
  final DbCache _transactionsDbCache;

  /// create a list of lists, where each resulting list contains transaction info
  /// [type, number, date, totalQuantity, totalProfit, totalSalesmanCommission, ]
  void createProductScreenData(BuildContext context, Product product) {
    List<List<dynamic>> productProcessedTransactions = [];
    if (product.initialQuantity > 0) {
      final initialTransaction = _createInitialQuantityTransaction(product);
      productProcessedTransactions.add([
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
        productProcessedTransactions.add(transactionDetails);
      }
    }
    sortListOfListsByDate(productProcessedTransactions, 3);
    final productTotals = _getProductTotals(productProcessedTransactions);
    Map<String, dynamic> newDataRow = {
      productDbRefKey: product.dbRef,
      quantityKey: productTotals[0],
      quantityDetailsKey: productProcessedTransactions,
      profitKey: productTotals[1],
      profitDetailsKey: _getOnlyProfitInvoices(productProcessedTransactions, 5),
      totalStockPriceKey: productTotals[0] * product.buyingPrice,
    };
    _screenDataProvider.addData(newDataRow);
  }

  /// creates a temp transaction using product initial quantity, the transaction is used in the
  /// calculation of product qunaity
  Transaction _createInitialQuantityTransaction(Product product) {
    return Transaction(
        dbRef: 'na',
        name: 'na',
        imageUrls: ['na'],
        number: 1000001,
        date: product.initialDate,
        currency: 'na',
        transactionType: TransactionType.initialCredit.name,
        totalAmount: product.initialQuantity as double,
        transactionTotalProfit: 0);
  }

  List<dynamic> _getProductTotals(List<List<dynamic>> productTransactions) {
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

  List<List<dynamic>> _getOnlyProfitInvoices(
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
