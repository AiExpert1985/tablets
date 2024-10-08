import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:tablets/src/utils/utils.dart';

class ProductSearch {
  ProductSearch(this.searchedValues, this.productList);
  final Map<String, dynamic> searchedValues;
  final List<Product> productList;

  ProductSearch copyWith({
    Map<String, dynamic>? fieldValues,
    List<Product>? productList,
  }) {
    return ProductSearch(
      fieldValues ?? searchedValues,
      productList ?? this.productList,
    );
  }
}

class ProductSearchNotifier extends StateNotifier<ProductSearch> {
  ProductSearchNotifier(this._ref, super.state);
  final StateNotifierProviderRef<ProductSearchNotifier, ProductSearch> _ref;
  void reset() {
    Map<String, dynamic> fieldValues = {};
    final productListValue = _ref.refresh(productsListProvider);
    List<Product> productList = _convertAsyncValueToProductList(productListValue);
    state = ProductSearch(fieldValues, productList);
  }

  void updateValue({required String dataType, required String key, required dynamic value}) {
    Map<String, dynamic> fieldValues = state.searchedValues;
    try {
      if (value == null || value.isEmpty) {
        fieldValues.remove(key);
      } else {
        if (dataType == 'int') value = int.parse(value);

        if (dataType == 'double') value = double.parse(value);
        fieldValues[key] = value;
      }
      state = state.copyWith(fieldValues: fieldValues);
    } catch (e) {
      utils.CustomDebug.print(
          message:
              'An error happend when value ($value) was entered in product search field ($key)',
          stackTrace: StackTrace.current);
    }
  }

  // bool _isFieldValuesEmpty() => state.fieldValues.keys.isEmpty;

  ProductSearch get getState => state;

  void updateProductList() {
    utils.CustomDebug.tempPrint('3');
    AsyncValue<List<Product>> productListValue = _ref.refresh(productsListProvider);
    utils.CustomDebug.tempPrint('4');
    List<Product> productList = _convertAsyncValueToProductList(productListValue);

    //below code might be deleted if the state is updated automatically
    if (mounted) {
      state = state.copyWith(productList: productList);
    }
  }

  void searchProductList() {
    utils.CustomDebug.tempPrint('1');
    updateProductList();
    utils.CustomDebug.tempPrint('2');
    List<Product> newProductList = [];
    Map<String, dynamic> searchedValues = state.searchedValues;
    if (searchedValues.isEmpty) return;
    // newProductList =
    //     newProductList.where((product) => product.name == searchedValues['name']).toList();
    for (Product product in state.productList) {
      if (searchedValues.containsKey('name') && product.name.contains(searchedValues['name'])) {
        newProductList.add(product);
      }
    }
    state = state.copyWith(productList: newProductList);
  }
}

final productSearchNotifierProvider =
    StateNotifierProvider<ProductSearchNotifier, ProductSearch>((ref) {
  CustomDebug.tempPrint('I am created');
  Map<String, dynamic> fieldValues = {};
  final productListValue = ref.watch(productsListProvider);
  List<Product> productList = _convertAsyncValueToProductList(productListValue);
  ref.onDispose(() => CustomDebug.print(message: 'I am disposed', stackTrace: StackTrace.current));
  return ProductSearchNotifier(ref, ProductSearch(fieldValues, productList));
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
