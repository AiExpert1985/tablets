import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;
import 'package:tablets/src/features/salesmen/controllers/salesman_filter_data_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';

class SalesmanFilteredList {
  SalesmanFilteredList(this._ref);
  final ProviderRef<SalesmanFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(salesmanFiltersProvider);
    final listValue = _ref.read(salesmanStreamProvider);
    final filteredList = filter_fn.applyListFilter(listValue, filters);
    return filteredList;
  }
}

final salesmanFilteredListProvider = Provider<SalesmanFilteredList>((ref) {
  return SalesmanFilteredList(ref);
});

class SalesmanFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  SalesmanFiltersNotifier(super.state);
  void update({
    required String dataType,
    required String key,
    required dynamic value,
    required String filterCriteria,
  }) {
    state = filter_fn.updateFilters(
      state,
      dataType,
      key,
      value,
      filterCriteria,
    );
  }

  void reset() => state = {};
}
