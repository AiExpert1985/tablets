import 'package:flutter_riverpod/flutter_riverpod.dart';

/// list of map mirrors the collections in firebase database
class DbCache extends StateNotifier<List<Map<String, dynamic>>> {
  DbCache() : super([]);

  void addData(Map<String, dynamic> newData) {
    state = [...state, newData]; // Create a new list with the new data
  }

  void updateData(int index, Map<String, dynamic> updatedData) {
    if (index >= 0 && index < state.length) {
      state[index] = updatedData;
      state = [...state];
    }
  }

  void removeData(int index) {
    if (index >= 0 && index < state.length) {
      state.removeAt(index);
      state = [...state];
    }
  }

  void setData(List<Map<String, dynamic>> newData) {
    state = [...newData];
  }

  List<Map<String, dynamic>> get data => state;
}
