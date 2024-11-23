import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'dart:core';

class TestProductScreenPerformance {
  TestProductScreenPerformance(this._context, this._ref);
  final WidgetRef _ref;
  final BuildContext _context;

  void run(int transactionMultiple) {
    final productDbCache = _ref.read(productDbCacheProvider.notifier);
    final productData = productDbCache.data;
    final transactionDbCache = _ref.read(transactionDbCacheProvider.notifier);
    final transactionData = transactionDbCache.data;
    final multipliedTransactionData = _createDuplicates(transactionData, transactionMultiple);
    transactionDbCache.set(multipliedTransactionData);
    final avgMatchingDuration = _runtests(multipliedTransactionData, productData);
    debugPrint('test took $avgMatchingDuration seconds per product');
  }

  /// returns a new copy of the list, where Maps are duplicated x number of times
  /// I used it to create huge size copies of lists for performace testing purpose
  List<Map<String, dynamic>> _createDuplicates(List<Map<String, dynamic>> data, int times) {
    List<Map<String, dynamic>> duplicatedList = [];
    for (var map in data) {
      for (int i = 0; i < times; i++) {
        // change dbRef to make every item unique
        final newDbRef = generateRandomString(len: 8);
        duplicatedList.add(Map<String, dynamic>.from({...map, 'dbRef': newDbRef}));
      }
    }
    return duplicatedList;
  }

  double _runtests(List<Map<String, dynamic>> transactions, List<Map<String, dynamic>> products) {
    debugPrint('num transactions = ${transactions.length}');
    debugPrint('num products = ${products.length}');
    debugPrint('avg num transactions per product = ${transactions.length ~/ products.length}');
    final screenController = _ref.read(productScreenControllerProvider);
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    for (var productData in products) {
      _testWholeScreenController(screenController, productData);
    }
    stopwatch.stop();
    final averagePerCustomer = stopwatch.elapsedMilliseconds / products.length;
    return averagePerCustomer / 1000;
  }

  void _testWholeScreenController(
    ProductScreenController screenController,
    Map<String, dynamic> productData,
  ) {
    screenController.getProductScreenData(_context, productData);
  }
}
