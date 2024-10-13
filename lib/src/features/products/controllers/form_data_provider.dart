import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFormData extends StateNotifier<Map<String, dynamic>> {
  UserFormData(super.state);

  void updateMap({required String key, required dynamic value}) {
    Map<String, dynamic> tempMap = {...state};
    tempMap[key] = value;
    state = {...state};
  }

  void resetMap() => state = {};

  Map<String, dynamic> getState() => state;
}

final productFormDataProvider = StateNotifierProvider<UserFormData, Map<String, dynamic>>((ref) => UserFormData({}));
