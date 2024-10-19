import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

class ItemFormData extends StateNotifier<Map<String, dynamic>> {
  ItemFormData(super.state);

  void initialize({BaseItem? item}) {
    state = state = item?.toMap() ?? {'dbKey': generateRandomString(len: 8)};
  }

  void update({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  Map<String, dynamic> get data => state;
}
