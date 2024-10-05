import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductSearch {
  Map<String, dynamic> fieldValues = {};
  bool isSearchOn = false; // used to make some widgets visible when search is on

  void resetFieldValues() => fieldValues = {};

  void updateValue({required String dataType, required String key, required dynamic value}) {
    try {
      if (value == null || value.isEmpty) {
        fieldValues.remove(key);
      } else {
        if (dataType == 'int') int.parse(value);
        if (dataType == 'double') double.parse(value);
      }
      fieldValues[key] = value;
      fieldValues[key] = value;
      isSearchOn = !_isFieldValuesEmpy();
      utils.CustomDebug.tempPrint(fieldValues);
      utils.CustomDebug.tempPrint(isSearchOn);
    } catch (e) {
      utils.CustomDebug.tempPrint(
          'An error happend when value ($value) was entered in product search field ($key)');
    }
  }

  bool _isFieldValuesEmpy() => fieldValues == {};
}

final productsSearchProvider = Provider<ProductSearch>((ref) => ProductSearch());
