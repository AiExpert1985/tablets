import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'dart:core';

class TestCustomerScreenPerformance {
  TestCustomerScreenPerformance(this._context, this._ref);
  final WidgetRef _ref;
  final BuildContext _context;

  void run(int transactionMultiple, int customersMultiples) {
    final customerDbCache = _ref.read(customerDbCacheProvider.notifier);
    final customerData = customerDbCache.data;
    final multipliedcustomerData = _createDuplicates(customerData, customersMultiples);
    final transactionDbCache = _ref.read(transactionDbCacheProvider.notifier);
    final transactionData = transactionDbCache.data;
    final multipliedTransactionData = _createDuplicates(transactionData, transactionMultiple);
    transactionDbCache.set(multipliedTransactionData);
    final avgMatchingDuration = _runtests(multipliedTransactionData, multipliedcustomerData);
    debugPrint('test took $avgMatchingDuration seconds per customer');
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

  double _runtests(List<Map<String, dynamic>> transactions, List<Map<String, dynamic>> customers) {
    debugPrint('num transactions = ${transactions.length}');
    debugPrint('num cusutoemrs = ${customers.length}');
    debugPrint('avg num transactions per customer = ${transactions.length ~/ customers.length}');
    final screenController = _ref.read(customerScreenControllerProvider);
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    for (var customerData in customers) {
      _testWholeScreenController(screenController, customerData);
    }
    stopwatch.stop();
    final averagePerCustomer = stopwatch.elapsedMilliseconds / customers.length;
    return averagePerCustomer / 1000;
  }

  void _testWholeScreenController(
    CustomerScreenController screenController,
    Map<String, dynamic> customerData,
  ) {
    screenController.setFeatureScreenData(_context);
  }
}
