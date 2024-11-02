import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;
import 'package:tablets/src/features/customers/controllers/customer_filter_data_provider.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';

class CustomerFilteredList {
  CustomerFilteredList(this._ref);
  final ProviderRef<CustomerFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(customerFiltersProvider);
    final listValue = _ref.read(customerStreamProvider);
    final filteredList = filter_fn.applyListFilter(listValue, filters);
    return filteredList;
  }
}

final customerFilteredListProvider = Provider<CustomerFilteredList>((ref) {
  return CustomerFilteredList(ref);
});

class CustomerFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  CustomerFiltersNotifier(super.state);
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
