import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/categories/model/category.dart';

class CategoryFormFieldsData extends StateNotifier<Map<String, dynamic>> {
  CategoryFormFieldsData(super.state);

  void initialize({ProductCategory? category}) {
    state = category?.toMap() ?? {'dbKey': generateRandomString(len: 8)};
  }

  void update({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  void reset() => state = {};

  Map<String, dynamic> getState() => state;
}

final categoryFormFieldsDataProvider =
    StateNotifierProvider<CategoryFormFieldsData, Map<String, dynamic>>(
        (ref) => CategoryFormFieldsData({}));
