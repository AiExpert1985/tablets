import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_filtered_list.dart';

final salesmanFiltersProvider =
    StateNotifierProvider<SalesmanFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return SalesmanFiltersNotifier({});
});
