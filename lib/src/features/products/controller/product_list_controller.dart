import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductSearch {
  ProductSearch(this.fieldValues, this.isSearchOn, this.productList);
  final Map<String, dynamic> fieldValues;
  final bool isSearchOn; // used to make some widgets visible when search is on
  final AsyncValue<List<Product>> productList;

  ProductSearch copyWith({
    Map<String, dynamic>? fieldValues,
    bool? isSearchOn,
    AsyncValue<List<Product>>? productList,
  }) {
    return ProductSearch(
      fieldValues ?? this.fieldValues,
      isSearchOn ?? this.isSearchOn,
      productList ?? this.productList,
    );
  }
}

class ProductSearchNotifier extends StateNotifier<ProductSearch> {
  ProductSearchNotifier(this._ref, super.state);
  final StateNotifierProviderRef<ProductSearchNotifier, ProductSearch> _ref;
  void reset() {
    Map<String, dynamic> fieldValues = {};
    const isSearchOn = false;
    final productList = _ref.refresh(productsListProvider);
    state = ProductSearch(fieldValues, isSearchOn, productList);
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
      bool isSearchOn = !_isFieldValuesEmpty();
      state = state.copyWith(fieldValues: fieldValues, isSearchOn: isSearchOn);
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error happend when value ($value) was entered in product search field ($key)',
          stackTrace: StackTrace.current);
    }
  }

  bool _isFieldValuesEmpty() => state.fieldValues.keys.isEmpty;

  ProductSearch get getState => state;

  void updateProductList() {
    utils.CustomDebug.tempPrint(state.productList.value);
    // ignore: unused_result
    _ref.refresh(productsListProvider);
  }
}

final productSearchNotifierProvider = StateNotifierProvider<ProductSearchNotifier, ProductSearch>((ref) {
  Map<String, dynamic> fieldValues = {};
  const isSearchOn = false;
  final productList = ref.watch(productsListProvider);
  return ProductSearchNotifier(ref, ProductSearch(fieldValues, isSearchOn, productList));
});
