import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/regions/controllers/region_filter_data_provider.dart';
import 'package:tablets/src/features/regions/repository/region_repository_provider.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;

class RegionFilteredList {
  RegionFilteredList(this._ref);
  final ProviderRef<RegionFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(regionFiltersProvider);
    final listValue = _ref.read(regionStreamProvider);
    final filteredList = filter_fn.applyListFilter(listValue, filters);
    return filteredList;
  }
}

final regionFilteredListProvider = Provider<RegionFilteredList>((ref) {
  return RegionFilteredList(ref);
});

class RegionFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  RegionFiltersNotifier(super.state);
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
