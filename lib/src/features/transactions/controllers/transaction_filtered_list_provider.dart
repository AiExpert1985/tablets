import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/list_filters.dart' as filter_fn;
import 'package:tablets/src/features/transactions/controllers/transaction_filter_data_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

class TransactionFilteredList {
  TransactionFilteredList(this._ref);
  final ProviderRef<TransactionFilteredList> _ref;

  AsyncValue<List<Map<String, dynamic>>> getFilteredList() {
    final filters = _ref.read(transactionFiltersProvider);
    final listValue = _ref.read(transactionStreamProvider);
    final filteredList = filter_fn.applyListFilter(filters: filters, listValue: listValue);
    return filteredList;
  }
}

final transactionFilteredListProvider = Provider<TransactionFilteredList>((ref) {
  return TransactionFilteredList(ref);
});
