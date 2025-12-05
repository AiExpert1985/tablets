import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/common/classes/db_cache.dart';

class TransactionEnrichmentHelper {
  final DbCache _dbCache;

  TransactionEnrichmentHelper(this._dbCache);

  /// Converts a map with Transaction objects to a map with dbRefs
  Map<String, dynamic> convertTransactionsToDbRefs(Map<String, dynamic> data) {
    final deepCopy = Map<String, dynamic>.from(data);

    // We need to traverse the map and find lists that contain Transactions
    for (var key in deepCopy.keys) {
      var value = deepCopy[key];

      if (value is List) {
        if (value.isNotEmpty && value.first is List) {
          // Check if it's a list of lists (like details fields usually are)
          // e.g. [[Transaction, 'type', ...], [Transaction, 'type', ...]]
          List<dynamic> newList = [];
          bool modified = false;

          for (var item in value) {
            if (item is List && item.isNotEmpty && item.first is Transaction) {
              var newRow = List.from(item);
              newRow[0] = (item.first as Transaction).dbRef;
              newList.add(newRow);
              modified = true;
            } else {
              newList.add(item);
            }
          }

          if (modified) {
            deepCopy[key] = newList;
          }
        }
      }
    }

    return deepCopy;
  }

  /// Converts a map with dbRefs back to a map with Transaction objects
  Map<String, dynamic> enrichDataWithTransactions(Map<String, dynamic> data) {
    final deepCopy = Map<String, dynamic>.from(data);

    for (var key in deepCopy.keys) {
      var value = deepCopy[key];

      if (value is List) {
        if (value.isNotEmpty && value.first is List) {
          // Check if inner list starts with a string that looks like a dbRef
          // (Simple heuristic: checking if the first element is a String)
          // We rely on the fact that we only replaced Transactions in the first position
          List<dynamic> newList = [];
          bool modified = false;

          for (var item in value) {
            if (item is List && item.isNotEmpty && item.first is String) {
              // Try to find transaction
              String dbRef = item.first as String;
              Transaction? txn = _findTransaction(dbRef);

              if (txn != null) {
                var newRow = List.from(item);
                newRow[0] = txn;
                newList.add(newRow);
                modified = true;
              } else {
                // If transaction not found, deciding whether to keep it or drop it.
                // For data integrity, if the main object is missing, the row is likely invalid.
                // However, to be safe, we might just leave the dbRef or drop the row.
                // Plan said: "Handle missing transactions gracefully (if deleted, skip silently)"
                // So we skip adding this row to newList
                modified = true; // We are modifying by removing
              }
            } else {
              newList.add(item);
            }
          }

          if (modified) {
            deepCopy[key] = newList;
          }
        }
      }
    }

    return deepCopy;
  }

  Transaction? _findTransaction(String dbRef) {
    try {
      var items = _dbCache.data;
      for (var item in items) {
        if (item['dbRef'] == dbRef) {
          return Transaction.fromMap(item);
        }
      }
    } catch (e) {
      // In case of error
    }
    return null;
  }
}
