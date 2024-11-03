import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

class TextControllerNotifier extends StateNotifier<Map<String, dynamic>> {
  TextControllerNotifier() : super({});

  void addController(String property, {dynamic value}) {
    String? text = value != null && value is! String ? value.toString() : value;
    state = {
      ...state,
      property: TextEditingController(text: text),
    };
  }

  void addSubControllers(String property, Map<String, dynamic> subProperties) {
    Map<String, TextEditingController> newSubControllers = {};
    subProperties.forEach((key, value) {
      String? text = value != null && value is! String ? value.toString() : value;
      newSubControllers[key] = TextEditingController(text: text);
    });

    final List<Map<String, TextEditingController>> list;

    if (state.containsKey(property) && state[property] is List) {
      list = List.from(state[property]);
      list.add(newSubControllers);
    } else {
      list = [newSubControllers];
    }

    state = {
      ...state,
      property: list,
    };
  }

  void removeSubController(String property, int index, String subProperty) {
    if (!isValidSubController(property, index, subProperty)) return;
    final list = state[property] as List<Map<String, TextEditingController>>;
    TextEditingController controller = list[index][subProperty]!;
    list.removeAt(index);
    controller.dispose();
    state = {
      ...state,
      property: list,
    };
  }

  dynamic getSubController(String property, int index, String subProperty) {
    if (!isValidSubController(property, index, subProperty)) return;
    return state[property][index][subProperty];
  }

  dynamic getController(String property) {
    if (!isValidController(property)) return;
    return state[property];
  }

  bool isValidController(String property) {
    if (!state.containsKey(property)) {
      tempPrint('Invalid controller: state[$property] does not exist');
      return false;
    }
    return true;
  }

  bool isValidSubController(String property, int index, String subProperty) {
    if (!state.containsKey(property)) {
      tempPrint('Invalid subController: state[$property] does not exist');
      return false;
    }
    if (state[property] is! List) {
      tempPrint(state[property].runtimeType);
      tempPrint('Invalid subController: state[$property] is not a list');
      return false;
    }
    if (index < 0 || index >= state[property].length) {
      tempPrint('Invalid subController: state[$property][$index] is invalid');
      return false;
    }
    if (state[property][index][subProperty] is! TextEditingController) {
      tempPrint('Invalid subController: state[$property][$index][$subProperty] is not a TextEditingController');
      return false;
    }
    return true;
  }

  void updateControllerText(String property, dynamic value) {
    if (!isValidController(property)) return;
    String text = value is! String ? value.toString() : value;
    state = {
      ...state,
      property: TextEditingController(text: text),
    };
  }

  void updateSubControllerText(String property, int index, String subProperty, dynamic value) {
    if (!isValidSubController(property, index, subProperty)) return;
    String text = value is! String ? value.toString() : value;
    final list = List.from(state[property]);
    final controller = list[index][subProperty];
    controller.text = text;
    state = {
      ...state,
      property: list,
    };
  }

  // this method is very important, and should be called when every you finish
  // your work with TextEditingControllers otherwise they will keep their values
  // and that causes bugs in the code
  void disposeControllers() {
    state.forEach((property, value) {
      if (value is TextEditingController) {
        value.dispose();
      } else if (value is List<Map<String, TextEditingController>>) {
        for (var item in value) {
          item.forEach((subProperty, controller) => controller.dispose());
        }
      }
    });
    state = {};
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Map<String, dynamic> get data => state;
}

final textFieldsControllerProvider = StateNotifierProvider<TextControllerNotifier, Map<String, dynamic>>((ref) {
  return TextControllerNotifier();
});
