import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/categories/controllers/category_filter_data_provider.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;

class CategoryFilteredList {
  CategoryFilteredList(this._ref);
  final ProviderRef<CategoryFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(categoryFiltersProvider);
    final listValue = _ref.read(categoryStreamProvider);
    final filteredList = filter_fn.applyListFilter(listValue, filters);
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
    state = filter_fn.updateFilters(state, dataType, key, value, filterCriteria);
  }

  void reset() => state = {};
}
