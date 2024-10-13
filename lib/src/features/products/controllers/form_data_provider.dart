import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/model/product.dart';

class UserFormData extends StateNotifier<Map<String, dynamic>> {
  UserFormData(super.state);

  void initialize(Product product) {
    state = {
      'code': product.code,
      'name': product.name,
      'sellRetailPrice': product.sellRetailPrice,
      'sellWholePrice': product.sellWholePrice,
      'packageType': product.packageType,
      'packageWeight': product.packageWeight,
      'numItemsInsidePackage': product.numItemsInsidePackage,
      'alertWhenExceeds': product.alertWhenExceeds,
      'altertWhenLessThan': product.altertWhenLessThan,
      'salesmanComission': product.salesmanComission,
      'imageUrls': product.imageUrls,
      'category': product.category,
      'initialQuantity': product.initialQuantity
    };
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
