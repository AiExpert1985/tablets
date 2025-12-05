import 'dart:convert';
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
/// Also stores nested lists as JSON strings for Firebase Web compatibility
Map<String, dynamic> convertForCacheSave(Map<String, dynamic> screenData) {
  final Map<String, dynamic> result = {};

  screenData.forEach((key, value) {
    if (_detailFieldsWithTransactions.contains(key) && value is List) {
      // Convert list of lists, replacing Transaction at index 0 with dbRef
      final converted = _convertDetailListForSave(value);
      // Store as JSON string for Firebase Web compatibility
      result[key] = jsonEncode(converted);
    } else {
      result[key] = value;
    }
  });

  return result;
}

/// Converts cached data after loading from Firebase
/// Replaces dbRef strings in detail fields with Transaction objects from cache
/// Also parses JSON strings back to lists (stored as JSON for Web compatibility)
Map<String, dynamic> enrichWithTransactions(
  Map<String, dynamic> cachedData,
  List<Map<String, dynamic>> transactionDbCache,
) {
  final Map<String, dynamic> result = {};

  cachedData.forEach((key, value) {
    if (_detailFieldsWithTransactions.contains(key)) {
      // Handle JSON string (new format for Web compatibility) or List (legacy format)
      List<dynamic> detailList;
      if (value is String) {
        // Parse JSON string
        detailList = jsonDecode(value) as List<dynamic>;
      } else if (value is List) {
        // Legacy format - already a list
        detailList = value;
      } else {
        result[key] = value;
        return;
      }
      // Convert list of lists, replacing dbRef at index 0 with Transaction
      result[key] =
          _enrichDetailListWithTransactions(detailList, transactionDbCache);
    } else {
      result[key] = value;
    }
  });

  return result;
}

/// Helper to convert detail list for saving (Transaction -> dbRef, DateTime -> milliseconds)
List<List<dynamic>> _convertDetailListForSave(List<dynamic> detailList) {
  final List<List<dynamic>> result = [];

  for (var item in detailList) {
    if (item is List && item.isNotEmpty) {
      final List<dynamic> newItem = [];

      // Process each element in the inner list
      for (var element in item) {
        if (element is Transaction) {
          // Convert Transaction to dbRef string
          newItem.add(element.dbRef);
        } else if (element is DateTime) {
          // Convert DateTime to milliseconds since epoch
          newItem.add(element.millisecondsSinceEpoch);
        } else {
          // Keep other types as-is
          newItem.add(element);
        }
      }

      result.add(newItem);
    }
  }

  return result;
}

/// Helper to enrich detail list with transactions (dbRef -> Transaction, milliseconds -> DateTime)
List<List<dynamic>> _enrichDetailListWithTransactions(
  List<dynamic> detailList,
  List<Map<String, dynamic>> transactionDbCache,
) {
  final List<List<dynamic>> result = [];

  for (var item in detailList) {
    if (item is List && item.isNotEmpty) {
      final List<dynamic> newItem = [];

      for (var j = 0; j < item.length; j++) {
        final element = item[j];

        if (j == 0 && element is String) {
          // First element is dbRef, convert to Transaction
          final transactionMap =
              _findTransactionByDbRef(element, transactionDbCache);
          if (transactionMap != null) {
            newItem.add(Transaction.fromMap(transactionMap));
          } else {
            // If not found, keep the dbRef as is (transaction might have been deleted)
            newItem.add(element);
          }
        } else if (j == 3 && element is int) {
          // Index 3 is the date stored as milliseconds, convert back to DateTime
          newItem.add(DateTime.fromMillisecondsSinceEpoch(element));
        } else {
          // Keep other elements as-is
          newItem.add(element);
        }
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
