import 'package:tablets/src/common/functions/debug_print.dart';

class ScreenData {
  ScreenData(this.screenData);
  final List<Map<String, dynamic>> screenData;

  // each newData added must have a key 'dbRef'
  void addData(Map<String, dynamic> newData) {
    if (!newData.containsKey('dbRef')) {
      errorPrint('data does not contain dbRef key');
      return;
    }
    String dbRef = newData['dbRef'];
    int index = _findIndexOfKey(dbRef);
    if (index == -1) {
      screenData.add(newData);
      return;
    }
    screenData[index] = newData;
  }

  void reset() => screenData.clear();

  List<Map<String, dynamic>> getData() => screenData;

  Map<String, dynamic> getCustomerData(String dbRefValue) {
    return screenData.firstWhere((item) => item['dbRef'] == dbRefValue, orElse: () => {});
  }

  int _findIndexOfKey(String dbRefValue) {
    for (int i = 0; i < screenData.length; i++) {
      if (screenData[i].containsKey('dbRef') && screenData[i]['dbRef'] == dbRefValue) {
        return i;
      }
    }
    return -1;
  }
}
