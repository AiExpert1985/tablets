import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductSearch {
  ProductSearch(this.fieldValues, this.productList);
  final Map<String, dynamic> fieldValues;
  final List<Product> productList;

  ProductSearch copyWith({
    Map<String, dynamic>? fieldValues,
    List<Product>? productList,
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
    final productListValue = _ref.refresh(productsListProvider);
    List<Product> productList = _convertAsyncValueToProductList(productListValue);
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
    AsyncValue<List<Product>> productListValue = _ref.refresh(productsListProvider);
    List<Product> productList = _convertAsyncValueToProductList(productListValue);

    //below code might be deleted if the state is updated automatically
    if (mounted) {
      utils.CustomDebug.tempPrint('productList state is updated !');
      state = state.copyWith(productList: productList);
    }
  }
}

final productSearchNotifierProvider = StateNotifierProvider<ProductSearchNotifier, ProductSearch>((ref) {
  Map<String, dynamic> fieldValues = {};
  final productListValue = ref.watch(productsListProvider);
  List<Product> productList = _convertAsyncValueToProductList(productListValue);
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
