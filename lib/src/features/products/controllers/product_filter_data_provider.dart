import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;

class ProductFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  ProductFiltersNotifier(super.state);
  void update({
    required String dataType,
    required String key,
    required dynamic value,
    required String filterCriteria,
  }) {
    state = filter_fn.updateFilters(state, dataType, key, value, filterCriteria);
  }

  void reset() => state = {};
}

final productFiltersProvider =
    StateNotifierProvider<ProductFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return ProductFiltersNotifier({});
});
