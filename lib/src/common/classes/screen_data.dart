import 'package:tablets/src/common/functions/debug_print.dart';

class ScreenData {
  ScreenData(this.screenData);
  final List<Map<String, dynamic>> screenData;

  void addData(Map<String, dynamic> newData) {
    screenData.add(newData);
  }

  void reset() => screenData.clear();

  List<Map<String, dynamic>> getData() => screenData;

  Map<String, dynamic> getCustomerData(String dbRefValue) {
    return screenData.firstWhere((item) => item['dbRef']['value'] == dbRefValue, orElse: () => {});
  }
}
