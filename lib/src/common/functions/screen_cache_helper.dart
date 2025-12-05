import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

/// List of detail field keys that contain transactions at index 0
/// These are the keys where the first element of each inner list is a Transaction object
const List<String> _detailFieldsWithTransactions = [
  // Customer screen detail fields
  'totalDebtDetails',
  'openInvoicesDetails',
  'dueDebtDetails',
  'avgClosingDaysDetails',
  'invoicesProfitDetails',
  'giftsDetails',
  // Product screen detail fields
  'quantityDetails',
  'profitDetails',
  // Salesman screen detail fields
  'salaryDetails', // commission details
  'numInvoicesDetails',
  'numReceiptsDetails',
  'numReturnsDetails',
  'profitDetails',
];

/// Converts screen data for saving to Firebase cache
/// Replaces Transaction objects in detail fields with their dbRef strings
Map<String, dynamic> convertForCacheSave(Map<String, dynamic> screenData) {
  final Map<String, dynamic> result = {};

  screenData.forEach((key, value) {
    if (_detailFieldsWithTransactions.contains(key) && value is List) {
      // Convert list of lists, replacing Transaction at index 0 with dbRef
      result[key] = _convertDetailListForSave(value);
    } else {
      result[key] = value;
    }
  });

  return result;
}

/// Converts cached data after loading from Firebase
/// Replaces dbRef strings in detail fields with Transaction objects from cache
Map<String, dynamic> enrichWithTransactions(
  Map<String, dynamic> cachedData,
  List<Map<String, dynamic>> transactionDbCache,
) {
  final Map<String, dynamic> result = {};

  cachedData.forEach((key, value) {
    if (_detailFieldsWithTransactions.contains(key) && value is List) {
      // Convert list of lists, replacing dbRef at index 0 with Transaction
      result[key] = _enrichDetailListWithTransactions(value, transactionDbCache);
    } else {
      result[key] = value;
    }
  });

  return result;
}

/// Helper to convert detail list for saving (Transaction -> dbRef)
List<List<dynamic>> _convertDetailListForSave(List<dynamic> detailList) {
  final List<List<dynamic>> result = [];

  for (var item in detailList) {
    if (item is List && item.isNotEmpty) {
      final List<dynamic> newItem = List.from(item);
      // Check if first element is a Transaction object
      if (item[0] is Transaction) {
        newItem[0] = (item[0] as Transaction).dbRef;
      } else if (item[0] is Map && item[0]['dbRef'] != null) {
        // Sometimes it might be a map representation
        newItem[0] = item[0]['dbRef'];
      }
      result.add(newItem);
    }
  }

  return result;
}

/// Helper to enrich detail list with transactions (dbRef -> Transaction)
List<List<dynamic>> _enrichDetailListWithTransactions(
  List<dynamic> detailList,
  List<Map<String, dynamic>> transactionDbCache,
) {
  final List<List<dynamic>> result = [];

  for (var item in detailList) {
    if (item is List && item.isNotEmpty) {
      final List<dynamic> newItem = List.from(item);
      // Check if first element is a dbRef string
      if (item[0] is String) {
        final dbRef = item[0] as String;
        final transactionMap = _findTransactionByDbRef(dbRef, transactionDbCache);
        if (transactionMap != null) {
          newItem[0] = Transaction.fromMap(transactionMap);
        }
        // If not found, keep the dbRef as is (transaction might have been deleted)
      }
      result.add(newItem);
    }
  }

  return result;
}

/// Find transaction in cache by dbRef
Map<String, dynamic>? _findTransactionByDbRef(
  String dbRef,
  List<Map<String, dynamic>> transactionDbCache,
) {
  try {
    return transactionDbCache.firstWhere(
      (t) => t['dbRef'] == dbRef,
    );
  } catch (e) {
    // Transaction not found (might have been deleted)
    debugLog('Transaction with dbRef $dbRef not found in cache');
    return null;
  }
}

/// Enriches a list of screen data items with transactions
List<Map<String, dynamic>> enrichScreenDataList(
  List<Map<String, dynamic>> cachedDataList,
  List<Map<String, dynamic>> transactionDbCache,
) {
  return cachedDataList.map((item) {
    return enrichWithTransactions(item, transactionDbCache);
  }).toList();
}
