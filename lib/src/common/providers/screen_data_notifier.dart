import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

/// columnsSummary Map<String, Map<String, dynamic>>
/// example {totalDebt: {type:sum, value: 100}, closingDuration:{type:avg, value:10}}
/// when creating screenDataNotifier, you should run initialize method, where you provide types
/// for all summary properties, and the value will be 0, when the data is set in the notifier,
/// the summary values will be calculated automatically.
/// data is List<Map<String, dynamic>>
/// example {totalDebt: 1000, totalDebtDetails: [[a, b, z], [x, y, z]]} this data will construct
/// the screen of all features, and it will be searchable. note that the details properties
/// will be used to give clickable reports
class ScreenDataNotifier extends StateNotifier<Map<String, dynamic>> {
  ScreenDataNotifier() : super({'summary': {}, 'data': []});

  void set(List<Map<String, dynamic>> data) {
    state = {
      ...state,
      'data': data,
    };
    calculateSummary();
  }

  void calculateSummary() {
    List<Map<String, dynamic>> data = state['data'];
    Map<String, Map<String, dynamic>> summary = {...state['summary']};
    Map<String, num> totalSums = {};
    for (var itemData in data) {
      for (var property in summary.keys) {
        totalSums[property] = (totalSums[property] ?? 0) + itemData[property];
      }
    }
    for (var propertyName in totalSums.keys) {
      if (summary[propertyName]!['type'] == 'avg') {
        summary[propertyName]!['value'] = totalSums[propertyName]! / data.length;
      } else if (summary[propertyName]!['type'] == 'sum') {
        summary[propertyName]!['value'] = totalSums[propertyName];
      } else {
        errorPrint('unknown summary type');
      }
    }
    state = {
      ...state,
      'summary': summary,
    };
  }

  List<dynamic> get data => state['data'];

  Map get summary => state['summary'];

  void reset() => state = {};

  /// seting the types of summary fields used
  void initialize(Map<String, dynamic> summaryType) {
    Map<String, Map<String, dynamic>> summary = {};
    summaryType.forEach((property, type) {
      summary[property] = {'type': type, 'value': 0};
    });
    state = {
      ...state,
      'summary': summary,
    };
  }
}
