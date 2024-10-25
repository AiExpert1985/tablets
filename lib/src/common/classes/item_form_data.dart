import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

class ItemFormData extends StateNotifier<Map<String, dynamic>> {
  ItemFormData(super.state);

  /// initialize state with either an item or null
  void initializeProperties({BaseItem? item}) {
    state = state = item?.toMap() ?? {'dbKey': generateRandomString(len: 8)};
  }

  /// add key, value pair to the existing state
  void update(
      {required String key, required dynamic value, String? subKey, bool isSubKey = false}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  /// add a whole map to the existing state
  void updateAllProperties(Map<String, dynamic> map) {
    state = {...state, ...map};
  }

  /// to update a key, where the value of the key is a list (not a single value as usual)
  /// for example an invoice which contains a list of items or a salesman with a list of customers
  /// if the value is a list of single values we provide only the key, and the value will be added
  /// to the list, but if the value is a list of Maps then, we need a key and a sub key to reach
  /// the targeted item inside the sub Map
  void updateSubProperty({required String key, String? subKey, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    if (tempMap[key] == null) tempMap[key] = [];
    if (subKey == null) {
      tempMap[key].add(value); // tempMap here is a List of dynamic values
    } else {
      tempMap[key][subKey] = value; // tempMap here is a List of Maps
    }
    state = {...tempMap};
  }

  /// using notifier to get current state, used to get state instead of using the provider
  /// I used this way because I faced some issues when using the provider to get the updated state
  Map<String, dynamic> get data => state;
}
