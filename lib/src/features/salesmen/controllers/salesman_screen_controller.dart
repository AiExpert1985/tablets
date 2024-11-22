import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/providers/screen_data_notifier.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_data_notifier.dart';
import 'package:tablets/src/features/salesmen/model/salesman.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';

const salesmanDbRefKey = 'dbRef';
const salesmanNameKey = 'name';
const salaryKey = 'salary';
const customersKey = 'customers';
const customersDetailsKey = 'customersDetails';
const salaryDetailsKey = 'salaryDetails';
const totalDebtKey = 'totalDebt';
const totalDebtDetailsKey = 'totalDebtDetails';
const dueDebtKey = 'dueDebt';
const dueDebtDetailsKey = 'dueDebtDetails';
const openInvoicesKey = 'openInvoices';
const openInvoicesDetailsKey = 'openInvoicesDetails';
const dueInvoicesKey = 'dueInvoices';
const dueInvoicesDetailsKey = 'dueInvoicesDetails';
const profitKey = 'profit';
const profitDetailsKey = 'profitDetails';

final salesmanScreenControllerProvider = Provider<SalesmanScreenController>((ref) {
  final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);
  final salesmanDbCache = ref.read(salesmanDbCacheProvider.notifier);
  final screenDataNotifier = ref.read(salesmanScreenDataNotifier.notifier);
  return SalesmanScreenController(screenDataNotifier, transactionDbCache, salesmanDbCache);
});

class SalesmanScreenController {
  SalesmanScreenController(
    this._screenDataNotifier,
    this._transactionDbCache,
    this._salesmanDbCache,
  );

  final ScreenDataNotifier _screenDataNotifier;
  final DbCache _transactionDbCache;
  final DbCache _salesmanDbCache;

  void setAllSalesmenScreenData(BuildContext context) {
    final allSalesmenData = _salesmanDbCache.data;
    List<Map<String, dynamic>> screenData = [];
    for (var salesmanData in allSalesmenData) {
      final newRow = getSalesmanScreenData(context, salesmanData);
      screenData.add(newRow);
    }
    Map<String, dynamic> summaryTypes = {
      salaryKey: 'sum',
      totalDebtKey: 'sum',
      dueDebtKey: 'sum',
      openInvoicesKey: 'sum',
      dueInvoicesKey: 'sum',
      profitKey: 'sum',
    };
    _screenDataNotifier.initialize(summaryTypes);
    _screenDataNotifier.set(screenData);
  }

  Map<String, dynamic> getSalesmanScreenData(
      BuildContext context, Map<String, dynamic> salesmanData) {
    final salesman = Salesman.fromMap(salesmanData);
    Map<String, dynamic> newDataRow = {
      salesmanDbRefKey: salesman.dbRef,
      salesmanNameKey: salesman.name,
      salaryKey: 0,
      salaryDetailsKey: [[]],
      customersKey: 0,
      customersDetailsKey: [[]],
      totalDebtKey: 0,
      totalDebtDetailsKey: [[]],
      dueDebtKey: 0,
      dueDebtDetailsKey: [[]],
      openInvoicesKey: 0,
      openInvoicesDetailsKey: [[]],
      dueInvoicesKey: 0,
      dueInvoicesDetailsKey: [[]],
      profitKey: 0,
      profitDetailsKey: [[]],
    };
    return newDataRow;
  }
}
