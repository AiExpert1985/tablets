import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/screen_data_notifier.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_screen_data_notifier.dart';
import 'package:tablets/src/features/vendors/model/vendor.dart';
import 'package:tablets/src/features/vendors/repository/vendor_db_cache_provider.dart';

const vendorDbRefKey = 'dbRef';
const vendorNameKey = 'name';
const vendorPhoneKey = 'phone';
const totalDebtKey = 'totalDebt';
const totalDebtDetailsKey = 'totalDebtDetails';
final vendorScreenControllerProvider = Provider<VendorScreenController>((ref) {
  final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);
  final screenDataNotifier = ref.read(vendorScreenDataNotifier.notifier);
  final vendorDbCache = ref.read(vendorDbCacheProvider.notifier);
  return VendorScreenController(screenDataNotifier, transactionDbCache, vendorDbCache);
});

class VendorScreenController {
  VendorScreenController(
    this._screenDataNotifier,
    this._transactionDbCache,
    this._vendorDbCache,
  );

  final ScreenDataNotifier _screenDataNotifier;
  final DbCache _transactionDbCache;
  final DbCache _vendorDbCache;

  void setAllVendorsScreenData(BuildContext context) {
    final allVendorsData = _vendorDbCache.data;
    List<Map<String, dynamic>> screenData = [];
    for (var vendorData in allVendorsData) {
      final newRow = getVendorScreenData(context, vendorData);
      screenData.add(newRow);
    }
    Map<String, dynamic> summaryTypes = {
      totalDebtKey: 'sum',
    };
    _screenDataNotifier.initialize(summaryTypes);
    _screenDataNotifier.set(screenData);
  }

  Map<String, dynamic> getVendorScreenData(
      BuildContext context, Map<String, dynamic> customerData) {
    final vendor = Vendor.fromMap(customerData);
    final vendorTransactions = getVendorTransactions(vendor.dbRef);
    if (vendor.initialAmount > 0) {
      vendorTransactions.add(_createInitialDebtTransaction(vendor));
    }
    final matchingList = _vendorMatching(vendorTransactions, context);
    final totalDebt = _getTotalDebt(matchingList, 4);
    Map<String, dynamic> newDataRow = {
      vendorDbRefKey: vendor.dbRef,
      vendorNameKey: vendor.name,
      vendorPhoneKey: vendor.phone,
      totalDebtKey: totalDebt,
      totalDebtDetailsKey: matchingList,
    };
    return newDataRow;
  }

  List<Map<String, dynamic>> getVendorTransactions(String dbRef) {
    // Filter transactions for the given database reference
    final allTransactions = _transactionDbCache.data;
    List<Map<String, dynamic>> vendorTransactions =
        allTransactions.where((item) => item['nameDbRef'] == dbRef).toList();

    sortListOfMapsByDate(vendorTransactions, 'date');
    return vendorTransactions;
  }

  /// creates a temp transaction using vendor initial debt, the transaction is used in the
  /// calculation of vendor debt
  Map<String, dynamic> _createInitialDebtTransaction(Vendor vendor) {
    return Transaction(
      dbRef: 'na',
      name: vendor.name,
      imageUrls: ['na'],
      number: 1000001,
      date: vendor.initialDate,
      currency: 'na',
      transactionType: TransactionType.initialCredit.name,
      totalAmount: vendor.initialAmount,
      transactionTotalProfit: 0,
    ).toMap();
  }

  List<List<dynamic>> _vendorMatching(
      List<Map<String, dynamic>> vendorTransactions, BuildContext context) {
    List<List<dynamic>> matchingTransactions = [];
    for (int i = 0; i < vendorTransactions.length; i++) {
      final transaction = Transaction.fromMap(vendorTransactions[i]);
      final transactionType = transaction.transactionType;
      double amountSign = (transactionType == TransactionType.vendorReturn.name ||
              transactionType == TransactionType.vendorReceipt.name)
          ? -1
          : 1;
      final transactionAmount = transaction.totalAmount * amountSign;
      matchingTransactions.add([
        transaction,
        translateDbTextToScreenText(context, transactionType),
        transaction.transactionType == TransactionType.initialCredit.name
            ? ''
            : transaction.number.toString(),
        transaction.date,
        transactionAmount,
      ]);
    }
    return sortListOfListsByDate(matchingTransactions, 3);
  }

  double _getTotalDebt(List<List<dynamic>> matchingList, int amountIndex) {
    if (matchingList.isEmpty) return 0;
    return matchingList.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
  }
}
