import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

class ItemFormData extends StateNotifier<Map<String, dynamic>> {
  ItemFormData(super.state);

  /// initialize state with either an item or null
  void initialize({BaseItem? item}) {
    state = state = item?.toMap() ?? {'dbKey': generateRandomString(len: 8)};
  }

  /// add key, value pair to the existing state
  void update({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  /// add a whole map to the existing state
  void updateAll(Map<String, dynamic> map) {
    state = {...state, ...map};
  }

  /// using notifier to get current state, used to get state instead of using the provider
  /// I used this way because I faced some issues when using the provider to get the updated state
  Map<String, dynamic> get data => state;
}
