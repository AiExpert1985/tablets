import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

enum DbCacheOperationTypes { add, edit, delete }

/// list of map mirrors the collections in firebase database
/// this cache is only created once for each feature at the time app started
/// then it will be updated using features form (add, update, delete), so there will
/// be no need to reload data from database (firestore) again until next app started
class DbCache extends StateNotifier<List<Map<String, dynamic>>> {
  DbCache() : super([]);

  /// add one entery to the existing dbCache list
  void _addData(Map<String, dynamic> newData) {
    state = [...state, newData];
  }

  /// update the data of one entery in the existing dbCache list
  void _updateData(int index, Map<String, dynamic> newData) {
    if (index >= 0 && index < state.length) {
      final stateCopy = [...state];
      stateCopy[index] = newData;
      state = [...stateCopy];
    }
  }

  /// remove one entery from existing dbCache list
  void _removeData(int index) {
    if (index >= 0 && index < state.length) {
      final stateCopy = [...state];
      stateCopy.removeAt(index);
      state = [...stateCopy];
    }
  }

  /// set the whole dbCache
  void set(List<Map<String, dynamic>> newData) {
    state = newData;
  }

  /// update dbCache list, it includes all kind of updates (add, edit, delete)
  void update(Map<String, dynamic> newData, DbCacheOperationTypes operationType) {
    if (operationType == DbCacheOperationTypes.add) {
      _addData(newData);
      return;
    }
    final index = _getItemIndex(newData);
    if (index == -1) return;
    if (operationType == DbCacheOperationTypes.edit) {
      _updateData(index, newData);
    } else if (operationType == DbCacheOperationTypes.delete) {
      _removeData(index);
    } else {
      errorPrint('Unkown operation');
    }
  }

  /// returns the index of the item passed, if not found or there is an error, it returns -1
  int _getItemIndex(Map<String, dynamic> newData) {
    if (data[0].containsKey('dbRef') && newData.containsKey('dbRef')) {
      errorPrint('the key dbRef is not found in one of the maps');
      return -1;
    }
    for (int index = 0; index < state.length; index++) {
      if (data[index]['dbRef'] == newData['dbRef']) {
        return index; // Return the index if found
      }
    }
    errorPrint('item provided for editing (update or delete) is not found in the dbCache');
    return -1;
  }

  List<Map<String, dynamic>> get data => state;
}
