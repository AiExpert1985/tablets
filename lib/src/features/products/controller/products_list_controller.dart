import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductSearch {
  ProductSearch(this.fieldValues, this.productList);
  final Map<String, dynamic> fieldValues;
  final AsyncValue<List<Product>> productList;

  ProductSearch copyWith({
    Map<String, dynamic>? fieldValues,
    AsyncValue<List<Product>>? productList,
  }) {
    return ProductSearch(
      fieldValues ?? this.fieldValues,
      productList ?? this.productList,
    );
  }
}

class ProductSearchNotifier extends StateNotifier<ProductSearch> {
  ProductSearchNotifier(this._ref, super.state);
  final StateNotifierProviderRef<ProductSearchNotifier, ProductSearch> _ref;
  void reset() {
    Map<String, dynamic> fieldValues = {};
    final productList = _ref.refresh(productsListProvider);
    state = ProductSearch(fieldValues, productList);
  }

  void updateValue({required String dataType, required String key, required dynamic value}) {
    Map<String, dynamic> fieldValues = state.fieldValues;
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
          message: 'An error happend when value ($value) was entered in product search field ($key)',
          stackTrace: StackTrace.current);
    }
  }

  // bool _isFieldValuesEmpty() => state.fieldValues.keys.isEmpty;

  ProductSearch get getState => state;

  void updateProductList() {
    AsyncValue<List<Product>> newList = _ref.refresh(productsListProvider);

    //below code might be deleted if the state is updated automatically
    if (mounted) {
      utils.CustomDebug.tempPrint('productList state is updated !');
      state = state.copyWith(productList: newList);
    }
  }
}

final productSearchNotifierProvider = StateNotifierProvider<ProductSearchNotifier, ProductSearch>((ref) {
  Map<String, dynamic> fieldValues = {};
  final productList = ref.watch(productsListProvider);

  return ProductSearchNotifier(ref, ProductSearch(fieldValues, productList));
});

List<Product> asyncValueToProductList(AsyncValue<List<Product>> asyncProductList) {
  List<Product> productList = [];
  asyncProductList.when(
    data: (products) => productList = products,
    error: (error) => utils.CustomDebug.tempPrint('Error: $error'),
    loading: () => utils.CustomDebug.tempPrint('product list is loading'),
  );
  return productList;
}
