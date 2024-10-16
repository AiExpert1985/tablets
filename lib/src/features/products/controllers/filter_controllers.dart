import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;
import 'package:tablets/src/features/products/repository/product_stream_provider.dart';

class ProductFilteredList {
  ProductFilteredList(this._ref);
  final ProviderRef<ProductFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(productFiltersProvider);
    final listValue = _ref.read(productsStreamProvider);
    final filteredList = filter_fn.applyListFilter(filters: filters, listValue: listValue);
    return filteredList;
  }
}

final productFilteredListProvider = Provider<ProductFilteredList>((ref) {
  return ProductFilteredList(ref);
});

class ProductFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  ProductFiltersNotifier(super.state);
  void update({
    required String dataType,
    required String key,
    required dynamic value,
    required String filterCriteria,
  }) {
    state = filter_fn.updateFilters(
      filters: state,
      dataType: dataType,
      key: key,
      value: value,
      filterCriteria: filterCriteria,
    );
  }

  void reset() => state = {};
}

final productFiltersProvider = StateNotifierProvider<ProductFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return ProductFiltersNotifier({});
});

final productFilterSwitchProvider = StateProvider<bool>((ref) => false);
