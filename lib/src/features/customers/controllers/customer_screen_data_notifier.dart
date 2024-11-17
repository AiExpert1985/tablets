import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenDataNotifier extends StateNotifier<List<Map<String, Map<String, dynamic>>>> {
  ScreenDataNotifier() : super([]);

  void addData(Map<String, Map<String, dynamic>> newData) {
    state = [...state, newData];
  }

  void resetData() {
    state = [];
  }

  List<Map<String, Map<String, dynamic>>> get data => state;
}

final customerScreenDataProvider =
    StateNotifierProvider<ScreenDataNotifier, List<Map<String, Map<String, dynamic>>>>(
  (ref) => ScreenDataNotifier(),
);
