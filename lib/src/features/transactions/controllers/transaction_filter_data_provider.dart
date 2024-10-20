import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;

class TransactionFiltersNotifier extends StateNotifier<Map<String, Map<String, dynamic>>> {
  TransactionFiltersNotifier(super.state);
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

final transactionFiltersProvider =
    StateNotifierProvider<TransactionFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return TransactionFiltersNotifier({});
});
