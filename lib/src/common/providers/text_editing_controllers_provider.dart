import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a StateNotifier for managing a list of TextEditingController
class TextEditingControllerListNotifier extends StateNotifier<List<TextEditingController>> {
  TextEditingControllerListNotifier() : super([]);

  void addController() {
    TextEditingController controller = TextEditingController();
    controller.addListener;
    state = [...state, controller]; // Add a new controller
  }

  // Method to remove a TextEditingController at a specific index
  void removeController(int index) {
    if (index >= 0 && index < state.length) {
      final newState = List<TextEditingController>.from(state); // Create a new list
      newState[index].dispose(); // Dispose of the controller
      newState.removeAt(index); // Remove the controller
      state = newState; // Update the state
    }
  }

  void updateControllerText({required int index, required String value}) {
    if (index >= 0 && index < state.length) {
      final newState = List<TextEditingController>.from(state); // Create a new list
      newState[index].text = value; // Dispose of the controller// Remove the controller
      state = newState; // Update the state
    }
  }

  // Method to clear all controllers
  void clearControllers() {
    for (var controller in state) {
      controller.dispose(); // Dispose of each controller
    }
    state = []; // Reset to an empty list
  }

  // Dispose method to clean up controllers when the notifier is disposed
  @override
  void dispose() {
    clearControllers(); // Ensure all controllers are disposed
    super.dispose();
  }
}

final textEditingControllerListProvider =
    StateNotifierProvider<TextEditingControllerListNotifier, List<TextEditingController>>((ref) {
  return TextEditingControllerListNotifier();
});
