import 'package:tablets/src/common/functions/debug_print.dart';

enum FilterCriteria { contains, equals, lessThanOrEqual, lessThan, moreThanOrEqual, moreThan }

enum FilterDataTypes { text, num }

class ScreenDataFilters {
  ScreenDataFilters(this._filters);

  /// filters should have these keys {'propertyName':{'criteria': xxx, 'value': xxx}}
  /// for example, in propertyNamed 'name' the criteria is 'contains' the vaue 'moh'
  Map<String, Map<String, dynamic>> _filters;

  /// add filter to filtersMap
  /// if value is empty, then the filter is removed from filtersMap
  void updateFilters(
    FilterDataTypes dataType,
    String propertyName,
    FilterCriteria filterCriteria,
    dynamic value,
  ) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      _filters.remove(propertyName);
    }
    _filters[propertyName] = {
      'criteria': filterCriteria,
      'value': value,
    };
  }

  List<Map<String, dynamic>> applyListFilter(
    List<Map<String, dynamic>> listValue,
  ) {
    _filters.forEach((propertyName, filter) {
      FilterCriteria criteria = filter['criteria'];
      dynamic value = filter['value'];
      if (criteria == FilterCriteria.contains) {
        listValue = listValue.where((item) => item[propertyName].contains(value)).toList();
      } else if (criteria == FilterCriteria.equals) {
        tempPrint('here');
        listValue = listValue.where((item) => item[propertyName] == value).toList();
      } else if (criteria == FilterCriteria.lessThanOrEqual) {
        listValue = listValue.where((item) => item[propertyName] <= value).toList();
      } else if (criteria == FilterCriteria.lessThan) {
        listValue = listValue.where((item) => item[propertyName] < value).toList();
      } else if (criteria == FilterCriteria.moreThanOrEqual) {
        listValue = listValue.where((item) => item[propertyName] >= value).toList();
      } else if (criteria == FilterCriteria.moreThan) {
        listValue = listValue.where((item) => item[propertyName] > value).toList();
      } else {
        errorPrint('unknown filter criteria');
      }
    });
    return listValue;
  }

  String? getFilterValue(String propertyName) {
    if (!_filters.containsKey(propertyName)) {
      return null;
    }
    dynamic value = _filters[propertyName]!['value'];
    if (value is int || value is double) {
      return value.toString();
    } else if (value is String) {
      return value;
    } else {
      errorPrint('unknow value type for filter name $propertyName');
      return value.toString();
    }
  }

  void reset() {
    _filters = {};
  }
}
