import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextControllerNotifier extends StateNotifier<Map<String, dynamic>> {
  TextControllerNotifier() : super({});

  // Method to add a TextEditingController
  void addController({required String fieldName}) {
    state = {
      ...state,
      fieldName: TextEditingController(),
    };
  }

  // Method to add a TextEditingController to a list by key and index
  void addControllerToList({required String fieldName}) {
    final controller = TextEditingController();
    final List<TextEditingController> list;
    if (state.containsKey(fieldName) && state[fieldName] is List<TextEditingController>) {
      list = state[fieldName];
      list.add(controller);
    } else {
      list = [controller];
    }
    state = {
      ...state,
      fieldName: list,
    };
  }

  // Method to remove a TextEditingController from a list by key and index
  void removeControllerFromList({required String fieldName, required int index}) {
    if (state.containsKey(fieldName) && state[fieldName] is List<TextEditingController>) {
      final list = state[fieldName] as List<TextEditingController>;
      if (index >= 0 && index < list.length) {
        list.removeAt(index);
        state = {
          ...state,
          fieldName: list,
        };
      }
    }
  }

  // Method to get a controller or a list of controllers
  dynamic getControllerFromList({required String fieldName, required int index}) {
    if (state.containsKey(fieldName) && state[fieldName] is List<TextEditingController>) {
      final list = state[fieldName] as List<TextEditingController>;
      if (index >= 0 && index < list.length) {
        return state[fieldName];
      }
      return null;
    }
  }

  // Method to get a controller or a list of controllers
  dynamic getController({required String fieldName}) {
    return state[fieldName];
  }

  bool isValidController({required String fieldName}) {
    return state.containsKey(fieldName);
  }

  bool isValidSubController({required String fieldName, required int subControllerIndex}) {
    if (!state.containsKey(fieldName)) return false;
    if (state[fieldName] is! List<TextEditingController>) return false;
    if (state[fieldName][subControllerIndex] is! TextEditingController) return false;
    return true;
  }

  // this method is very important, and should be called when every you finish
  // your work with TextEditingControllers otherwise they will keep their values
  // and that causes bugs in the code
  void disposeControllers() {
    state.forEach((key, value) {
      if (value is TextEditingController) {
        value.dispose();
      } else if (value is List<TextEditingController>) {
        for (var controller in value) {
          controller.dispose();
        }
      }
    });
    state = {}; // Clear the state
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Map<String, dynamic> get data => state;
}

// Define a provider for the TextEditingController map
final textFieldsControllerProvider =
    StateNotifierProvider<TextControllerNotifier, Map<String, dynamic>>((ref) {
  return TextControllerNotifier();
});
