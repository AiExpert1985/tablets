import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/categories/controllers/category_filter_data_provider.dart';
import 'package:tablets/src/features/categories/repository/category_stream_provider.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;

class CategoryFilteredList {
  CategoryFilteredList(this._ref);
  final ProviderRef<CategoryFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(categoryFiltersProvider);
    final listValue = _ref.read(categoriesStreamProvider);
    final filteredList = filter_fn.applyListFilter(filters: filters, listValue: listValue);
    return filteredList;
  }
}

final categoryFilteredListProvider = Provider<CategoryFilteredList>((ref) {
  return CategoryFilteredList(ref);
});

class CategoryFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  CategoryFiltersNotifier(super.state);
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
