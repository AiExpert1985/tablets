import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';

/// columnsSummary is the a map that contains the summary (sum or average) of each desired column in the
/// main screen, some columns don't have summary
/// dataRows is List[{'columnName':{'value': xx, 'details':xx}}] where 'value' is the cell value
/// displayed in the screen. 'details' is usually List<List<String>>? used to open dialog when
/// pressing the cell (some cells are not clickable, so they don't have 'details' property)
class ScreenDataNotifier extends StateNotifier<Map<String, dynamic>> {
  ScreenDataNotifier() : super({'summary': {}, 'data': []});

  void setRowData(List<Map<String, dynamic>> data) {
    state = {
      ...state,
      'data': data,
    };
    updateSummary();
  }

  void updateSummary() {
    final data = [...state['data']];
    final summary = {...state['summary'] as Map};
    // tempPrint('summary before $summary');
    Map<String, num> totalSums = {};
    for (var entry in data) {
      entry.forEach((propertyName, propertyDetails) {
        if (summary.containsKey(propertyName)) {
          var type = summary[propertyName]!['type'];
          var value = summary[propertyName]!['value'];
          var dataValue = propertyDetails['value'];
          if (type == 'sum') {
            summary[propertyName]!['value'] = (value as num) + (dataValue as num);
          } else if (type == 'avg') {
            totalSums[propertyName] = (totalSums[propertyName] ?? 0) + (dataValue as num);
            // summary[propertyName]!['value'] = totalSums[propertyName];
          }
        }
      });
    }
    for (var propertyName in totalSums.keys) {
      if (summary[propertyName]!['type'] == 'avg') {
        summary[propertyName]!['average'] = totalSums[propertyName]! / data.length;
      }
    }
    // tempPrint('summary after $summary');
    // state = {
    //   ...state,
    //   'summary': summary,
    // };
  }

  List<dynamic> get data => state['data'];

  Map get summary => state['summary'];

  void reset() => state = {};

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

final customerScreenDataProvider = StateNotifierProvider<ScreenDataNotifier, Map<String, dynamic>>(
  (ref) => ScreenDataNotifier(),
);
