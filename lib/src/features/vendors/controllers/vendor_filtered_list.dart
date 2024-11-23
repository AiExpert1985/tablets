import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;
import 'package:tablets/src/features/vendors/controllers/vendor_filter_data_provider.dart';
import 'package:tablets/src/features/vendors/repository/vendor_repository_provider.dart';

class VendorFilteredList {
  VendorFilteredList(this._ref);
  final ProviderRef<VendorFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(vendorFiltersProvider);
    final listValue = _ref.read(vendorStreamProvider);
    final filteredList = filter_fn.applyListFilterOnAsync(listValue, filters);
    return filteredList;
  }
}

final vendorFilteredListProvider = Provider<VendorFilteredList>((ref) {
  return VendorFilteredList(ref);
});

class VendorFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  VendorFiltersNotifier(super.state);
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
