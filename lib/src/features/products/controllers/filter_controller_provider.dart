import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/repository/product_stream_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

enum FilterCriteria { contains, equals, lessThanOrEqual, lessThan, moreThanOrEqual, moreThan }

enum DataTypes { int, double, string }

class ProductListFilter {
  ProductListFilter(this.searchFieldValues, this.isSearchOn, this.filteredList);
  final Map<String, Map<String, dynamic>> searchFieldValues; // {key:{value:xxx, filterType:xxx}}
  final bool isSearchOn;
  final AsyncValue<List<Map<String, dynamic>>> filteredList;

  ProductListFilter copyWith({
    Map<String, Map<String, dynamic>>? searchFieldValues,
    bool? isSearchOn,
    AsyncValue<List<Map<String, dynamic>>>? filteredList,
  }) {
    return ProductListFilter(
      searchFieldValues ?? this.searchFieldValues,
      isSearchOn ?? this.isSearchOn,
      filteredList ?? this.filteredList,
    );
  }
}

class ProductSearchNotifier extends StateNotifier<ProductListFilter> {
  ProductSearchNotifier(this.ref, super.state);
  StateNotifierProviderRef<ProductSearchNotifier, ProductListFilter> ref;
  void reset() {
    state = ProductListFilter({}, false, const AsyncValue.data([]));
  }

  void updateFieldValue(
      {required String dataType, required String key, required dynamic value, required String filterCriteria}) {
    try {
      Map<String, Map<String, dynamic>> searchFieldValues = state.searchFieldValues;
      if (value == null || value.isEmpty) {
        searchFieldValues.remove(key);
      } else {
        if (dataType == DataTypes.int.name) {
          value = int.parse(value);
        }
        if (dataType == DataTypes.double.name) {
          value = double.parse(value);
        }
        searchFieldValues[key] = {
          'value': value,
          'criteria': filterCriteria,
        };
      }
      state = state.copyWith(searchFieldValues: searchFieldValues);
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error happend when value ($value) was entered in product search field ($key)',
          stackTrace: StackTrace.current);
    }
  }

  ProductListFilter get getState => state;

  void applyFilters() {
    AsyncValue<List<Map<String, dynamic>>> productListValue = ref.read(productsStreamProvider);
    List<Map<String, dynamic>> filteredProductList = _convertAsyncValueToProductList(productListValue);
    Map<String, Map<String, dynamic>> searchedValues = state.searchFieldValues;
    searchedValues.forEach((key, filter) {
      if (filter['criteria'] == FilterCriteria.contains.name) {
        filteredProductList = filteredProductList.where((product) => product[key].contains(filter['value'])).toList();
        return;
      }
      if (filter['criteria'] == FilterCriteria.equals.name) {
        filteredProductList = filteredProductList.where((product) => product[key] == filter['value']).toList();
        return;
      }
    });
    state = state.copyWith(isSearchOn: true, filteredList: AsyncValue.data(filteredProductList));
  }
}

final productFilterControllerProvider = StateNotifierProvider<ProductSearchNotifier, ProductListFilter>((ref) {
  return ProductSearchNotifier(ref, ProductListFilter({}, false, const AsyncValue.data([])));
});

List<Map<String, dynamic>> _convertAsyncValueToProductList(AsyncValue<List<Map<String, dynamic>>> asyncProductList) {
  return asyncProductList.when(
      data: (products) => products,
      error: (e, st) {
        utils.CustomDebug.print(message: e, stackTrace: st);
        return [];
      },
      loading: () {
        utils.CustomDebug.print(message: 'product list is loading');
        return [];
      });
}
