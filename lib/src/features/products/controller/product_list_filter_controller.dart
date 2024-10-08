import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductListFilter {
  ProductListFilter(this.searchFieldValues, this.isSearchOn, this.filteredList);
  final Map<String, dynamic> searchFieldValues;
  final bool isSearchOn;
  final AsyncValue<List<Product>> filteredList;

  ProductListFilter copyWith({
    Map<String, dynamic>? searchFieldValues,
    bool? isSearchOn,
    AsyncValue<List<Product>>? filteredList,
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

  void updateValue({required String dataType, required String key, required dynamic value}) {
    Map<String, dynamic> searchFieldValues = state.searchFieldValues;
    try {
      if (value == null || value.isEmpty) {
        searchFieldValues.remove(key);
      } else {
        if (dataType == 'int') value = int.parse(value);

        if (dataType == 'double') value = double.parse(value);
        searchFieldValues[key] = value;
      }
      state = state.copyWith(searchFieldValues: searchFieldValues);
    } catch (e) {
      utils.CustomDebug.print(
          message:
              'An error happend when value ($value) was entered in product search field ($key)',
          stackTrace: StackTrace.current);
    }
  }

  // bool _isSearchedValuesEmpty() => state.searchedValues.keys.isEmpty;

  ProductListFilter get getState => state;

  void applyFilters() {
    AsyncValue<List<Product>> productListValue = ref.read(productsListProvider);
    List<Product> productList = _convertAsyncValueToProductList(productListValue);
    List<Product> filteredProductList = [];
    Map<String, dynamic> searchedValues = state.searchFieldValues;
    utils.CustomDebug.tempPrint(productList);
    utils.CustomDebug.tempPrint(searchedValues);
    if (searchedValues.isEmpty) return;
    for (Product product in productList) {
      if (searchedValues.containsKey('name') && product.name.contains(searchedValues['name'])) {
        filteredProductList.add(product);
      }
    }
    utils.CustomDebug.tempPrint(filteredProductList);
    state = state.copyWith(isSearchOn: true, filteredList: AsyncValue.data(filteredProductList));
  }

  void clearFilters() {
    state = state.copyWith(isSearchOn: false);
  }
}

final productListFilterNotifierProvider =
    StateNotifierProvider<ProductSearchNotifier, ProductListFilter>((ref) {
  return ProductSearchNotifier(ref, ProductListFilter({}, false, const AsyncValue.data([])));
});

List<Product> _convertAsyncValueToProductList(AsyncValue<List<Product>> asyncProductList) {
  return asyncProductList.when(
      data: (products) => products,
      error: (e, st) {
        utils.CustomDebug.print(message: e, stackTrace: st);
        return [];
      },
      loading: () {
        utils.CustomDebug.tempPrint('product list is loading');
        return [];
      });
}
