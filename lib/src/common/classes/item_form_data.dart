import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart';

class ItemFormData extends StateNotifier<Map<String, dynamic>> {
  ItemFormData(super.state);

  void initialize({Map<String, dynamic>? initialData}) =>
      state = state = initialData ?? {'dbKey': generateRandomString(len: 8)};

  void updateProperty(Map<String, dynamic> formData) {
    state = {...state, ...formData};
  }

  void updateSubProperty({required String property, required Map<String, dynamic> propertyData}) {
    Map<String, dynamic> newState = Map.from(state);
    if (newState.containsKey(property) && newState[property] is List<Map<String, dynamic>>) {
      newState[property].add(propertyData);
    } else {
      List<Map<String, dynamic>> newList = [propertyData];
      newState[property] = newList;
    }
    state = Map.from(newState);
  }

  /// checks whether state contains the mentioned property
  bool isValidProperty({required String property}) {
    return state.containsKey(property);
  }

  /// checks whether state contains the mentioned subProperty
  bool isValidSubProperty({required String property, required int index, required String subProperty}) {
    if (!state.containsKey(property)) return false;
    if (state[property] is! List<Map<String, dynamic>>) return false;
    if (index < state['items'].length) return false;
    if (state['items'][index].containsKey('price')) return false;
    return true;
  }

  /// using notifier to get current state, used to get state instead of using the provider
  /// I used this way because I faced some issues when using the provider to get the updated state
  Map<String, dynamic> get data => state;
}
