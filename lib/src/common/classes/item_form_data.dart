import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart';

class ItemFormData extends StateNotifier<Map<String, dynamic>> {
  ItemFormData(super.state);

  void initialize({Map<String, dynamic>? initialData}) =>
      state = state = initialData ?? {'dbKey': generateRandomString(len: 8)};

  void update(Map<String, dynamic> formData) {
    state = {...state, ...formData};
    tempPrint(state);
  }

  /// using notifier to get current state, used to get state instead of using the provider
  /// I used this way because I faced some issues when using the provider to get the updated state
  Map<String, dynamic> get data => state;
}
