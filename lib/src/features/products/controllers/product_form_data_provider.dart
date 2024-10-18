import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/products/model/product.dart';

class UserFormData extends StateNotifier<Map<String, dynamic>> {
  UserFormData(super.state);

  void initialize({Product? product}) {
    state = state = product?.toMap() ?? {'dbKey': generateRandomString(len: 8)};
  }

  void update({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  void reset() => state = {};

  Map<String, dynamic> getState() => state;
}

final productFormDataProvider =
    StateNotifierProvider<UserFormData, Map<String, dynamic>>((ref) => UserFormData({}));
