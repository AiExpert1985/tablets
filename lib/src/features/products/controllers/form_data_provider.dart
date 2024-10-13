import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFormData extends StateNotifier<Map<String, dynamic>> {
  UserFormData(super.state);

  void update({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...tempMap};
  }

  void reset() => state = {};

  Map<String, dynamic> getState() => state;
}

final productFormDataProvider = StateNotifierProvider<UserFormData, Map<String, dynamic>>((ref) => UserFormData({}));
