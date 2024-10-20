import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/controllers/product_filter_data_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;

class ProductFilteredList {
  ProductFilteredList(this._ref);
  final ProviderRef<ProductFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(productFiltersProvider);
    final listValue = _ref.read(productStreamProvider);
    final filteredList = filter_fn.applyListFilter(filters: filters, listValue: listValue);
    return filteredList;
  }
}

final transactionFilteredListProvider = Provider<ProductFilteredList>((ref) {
  return ProductFilteredList(ref);
});
