import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/classes/screen_data.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_data_provider.dart';
import 'package:tablets/src/features/salesmen/model/salesman.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';

const salesmanDbRefKey = 'dbRef';
const salesmanNameKey = 'name';
const salaryKey = 'salary';
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
  final screenDataProvider = ref.read(salesmanScreenDataProvider);
  return SalesmanScreenController(screenDataProvider, transactionDbCache);
});

class SalesmanScreenController {
  SalesmanScreenController(
    this._screenDataProvider,
    this._transactionDbCache,
  );

  final ScreenData _screenDataProvider;
  final DbCache _transactionDbCache;

  void createSalesmanScreenData(BuildContext context, Map<String, dynamic> salesmanData) {
    final salesman = Salesman.fromMap(salesmanData);
    Map<String, dynamic> newDataRow = {
      salesmanDbRefKey: salesman.dbRef,
      salesmanNameKey: salesman.name,
      salaryKey: 0,
      salaryDetailsKey: [[]],
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
    _screenDataProvider.addData(newDataRow);
  }
}
