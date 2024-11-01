import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart';

class ItemFormData extends StateNotifier<Map<String, dynamic>> {
  ItemFormData(super.state);

  void initialize({Map<String, dynamic>? initialData}) {
    state = state = initialData ?? {'dbKey': generateRandomString(len: 8)};
    tempPrint(state);
  }

  void updateProperties(Map<String, dynamic> properties) {
    state = {...state, ...properties};
  }

  /// if no index is passed, subProperties will be appended to the list
  /// if an index is provided, the data will be updated at the given index
  void updateSubProperties(String property, Map<String, dynamic> subProperties, {int? index}) {
    final newState = {...state};
    if (!newState.containsKey(property)) {
      newState[property] = [subProperties];
      state = newState;
      return;
    }
    final existingList = newState[property];
    if (existingList is! List<Map<String, dynamic>>) {
      errorPrint('Property "$property" is not of type List<Map<String, dynamic>>');
      return;
    }
    if (index == null) {
      newState[property].add(subProperties);
      state = newState;
      return;
    }
    if (index >= 0 && index < newState[property].length) {
      existingList[index] = {...existingList[index], ...subProperties};
      return;
    }
    errorPrint('subproperty $subProperties were not added to property "$property" at index $index');
  }

  /// checks whether state contains the mentioned property
  bool isValidProperty({required String property}) {
    return state.containsKey(property);
  }

  /// checks whether state contains the mentioned subProperty
  bool isValidSubProperty(
      {required String property, required int index, required String subProperty}) {
    if (!state.containsKey(property)) return false;
    if (state[property] is! List<Map<String, dynamic>>) return false;
    if (index < 0 && index > state[property].length) return false;
    if (!state[property][index].containsKey(subProperty)) return false;
    return true;
  }

  // usually this is used for initialValue for form fields, which takes either a value or null
  dynamic getProperty(property) {
    if (!state.containsKey(property)) return;
    return state[property];
  }

  // usually this is used for initialValue for form fields, which takes either a value or null
  dynamic getSubProperty(
      {required String property, required int index, required String subProperty}) {
    if (!isValidSubProperty(property: property, index: index, subProperty: subProperty)) return;
    return state[property][index][subProperty];
  }

  /// using notifier to get current state, used to get state instead of using the provider
  /// I used this way because I faced some issues when using the provider to get the updated state
  Map<String, dynamic> get data => state;

// used for debuggin purpose
  String getFormDataTypes() {
    final StringBuffer dataTypesBuffer = StringBuffer('{');

    state.forEach((key, value) {
      if (value is! List) {
        dataTypesBuffer.write("'$key': ${value.runtimeType}, ");
      } else {
        dataTypesBuffer.write('$key: [');
        dataTypesBuffer.write(value.map((item) {
          if (item is Map) {
            return '{${item.entries.map((entry) {
              return "'${entry.key}': ${entry.value.runtimeType}";
            }).join(', ')}}';
          }
          return item.runtimeType.toString();
        }).join(', '));
        dataTypesBuffer.write('], ');
      }
    });

    dataTypesBuffer.write('}');
    return dataTypesBuffer.toString();
  }
}
