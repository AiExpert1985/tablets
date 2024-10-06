import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/utils/utils.dart' as utils;

ProductSearch _defaultProductSearch = ProductSearch({}, false);

class ProductSearch {
  ProductSearch(this.fieldValues, this.isSearchOn);
  final Map<String, dynamic> fieldValues;
  final bool isSearchOn; // used to make some widgets visible when search is on

  static ProductSearch getDefault() => _defaultProductSearch.copyWith();

  ProductSearch copyWith({
    Map<String, dynamic>? fieldValues,
    bool? isSearchOn,
  }) {
    return ProductSearch(
      fieldValues ?? this.fieldValues,
      isSearchOn ?? this.isSearchOn,
    );
  }
}

class ProductSearchNotifier extends StateNotifier<ProductSearch> {
  ProductSearchNotifier(super.state);
  void reset() => state = ProductSearch.getDefault();

  void updateValue({required String dataType, required String key, required dynamic value}) {
    Map<String, dynamic> fieldValues = state.fieldValues;
    try {
      if (value == null || value.isEmpty) {
        fieldValues.remove(key);
      } else {
        if (dataType == 'int') int.parse(value);
        if (dataType == 'double') double.parse(value);
        fieldValues[key] = value;
      }
      bool isSearchOn = !_isFieldValuesEmpty();
      state = ProductSearch(fieldValues, isSearchOn);
    } catch (e) {
      utils.CustomDebug.print(
          message: 'An error happend when value ($value) was entered in product search field ($key)',
          stackTrace: StackTrace.current);
    }
  }

  bool _isFieldValuesEmpty() => state.fieldValues.keys.isEmpty;

  ProductSearch get getState => state;
}

final productSearchNotifierProvider = StateNotifierProvider<ProductSearchNotifier, ProductSearch>((ref) {
  final productSearch = ProductSearch.getDefault();
  return ProductSearchNotifier(productSearch);
});
