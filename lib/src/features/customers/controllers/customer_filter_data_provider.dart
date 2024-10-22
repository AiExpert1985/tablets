import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';

final customerFiltersProvider =
    StateNotifierProvider<CustomerFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return CustomerFiltersNotifier({});
});
